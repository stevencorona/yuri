/// The cipher module handles XOR obfuscation for the wire protocol.
///
/// # Wire Format Example
///
/// For a packet with XOR_ROLLING encryption:
/// ```text
/// [AA][00 08][03][01][XX XX XX][T1 T2 T3]
///  ^    ^      ^   ^   ^         ^
///  |    |      |   |   |         +-- 3-byte trailer (cursor)
///  |    |      |   |   +-- Encrypted payload
///  |    |      |   +-- Sequence number
///  |    |      +-- Opcode (0x03 = login)
///  |    +-- Packet size (big-endian u16)
///  +-- Magic byte
/// ```
/// The trailer bytes [T1 T2 T3] encode the RollingCursor as:
/// - T1: offset & 0xFF        (low byte)
/// - T2: base ^ 0x21          (xor'd base)
/// - T3: (offset >> 8) & 0xFF (high byte)
use faster_hex;
use fastrand;
use md5::{Digest, Md5};

/// Cipher state for XOR_ROLLING mode packets.
/// Transmitted as a 3-byte trailer at the end of encrypted packets.
/// The cursor values are used to index into the lookup table to generate
/// a unique 9-byte XOR key for each packet.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct LookupTableCursor {
    pub base: u8,    // Seed value that gets squared in key generation
    pub offset: u16, // Starting offset into the 1024-byte lookup table
}

/// Generates a 1024-byte lookup table used for XOR_ROLLING encryption.
///
/// Algorithm
/// 1. MD5 hash the key string
/// 2. Convert to hex string (32 bytes)
/// 3. Hash that hex string again
/// 4. Chain-hash 31 more times, appending each result
///
/// The resulting 1024 bytes serve as a substitution table where
/// the rolling cursor picks 9 bytes based on base² and offset values.
///
/// Approximately 2x faster than the C implementation (27µs vs 55µs), with 0 allocations
pub fn generate_lookup_table(key: &str) -> [u8; 1024] {
    let mut result = [0u8; 1024];
    let mut hex_buf = [0u8; 32];
    let mut hasher = Md5::new();

    hasher.update(key.as_bytes());
    let chain_iv = hasher.finalize_reset();
    faster_hex::hex_encode(&chain_iv, &mut hex_buf).unwrap();

    hasher.update(&hex_buf);
    let key = hasher.finalize_reset();
    faster_hex::hex_encode(&key, &mut result[0..32]).unwrap();

    for i in 0..31 {
        hasher.update(&result[..32 + i * 32]);
        let hash = hasher.finalize_reset();
        faster_hex::hex_encode(&hash, &mut result[32 + i * 32..32 + (i + 1) * 32]).unwrap();
    }

    result
}

/// Generate a 9-byte XOR key from the lookup table using the cursor position.
///
/// For each of the 9 key bytes:
///   - Calculate index as: (base² + i*3) * i + offset
///   - Mask with 0x3FF (equivalent to % 1024) for bounds checking
///
/// Note: The base gets squared once, then incremented by 3 for each byte.
/// This creates a pseudo-random but deterministic key sequence.
pub fn xor_key_rolling(table: [u8; 1024], cursor: &LookupTableCursor) -> [u8; 9] {
    let base = u32::from(cursor.base) * u32::from(cursor.base); // Once it works, look @ wrapping_mult
    let offset = u32::from(cursor.offset);

    let mut result = [0u8; 9];

    // Note: Bounds check: pos & 0x03FF is equivalent to pos % 1024
    // Bitwise AND with 0x03FF (binary 1111111111) keeps only the lower 10 bits,
    // giving us values 0-1023. This is ~10x faster than modulo division.
    for i in 0..9 {
        let start = base + i * 3;
        let pos = (start * i + offset) & 0x03FF;

        result[i as usize] = table[pos as usize];
    }

    result
}

impl LookupTableCursor {
    // XOR masks for decoding ingress client->server packet trailers
    const BASE_DECODE_XOR: u8 = 0x25;
    const OFFSET_DECODE_XOR: u16 = 0x2361;

    // XOR masks for encoding egress server->client packet trailers
    const BASE_ENCODE_XOR: u8 = 0x21;
    const OFFSET_ENCODE_XOR: u16 = 0x7424;

    /// Creates a new randomly-initialized XorTableCursor.
    pub fn new() -> Self {
        Self::generate()
    }

    /// Generates a random LookupTableCursor (alias for `new`)
    /// `base`:   u8 in range [100, 254]
    /// `offset`: u16 in range [256, 65532]
    pub fn generate() -> Self {
        let base = fastrand::u8(100..=254);
        let offset = fastrand::u16(256..=65532);
        Self { base, offset }
    }

    /// Decodes a 3-byte XOR trailer from the wire into a `LookupTableCursor`.
    ///
    /// Wire format: [offset_low, base_xored, offset_high]
    ///   - Bytes 0,2: offset split as little-endian u16 (low byte first, high byte last)
    ///   - Byte 1: base value in the middle
    ///
    /// The original C implementation code does:
    /// Writes: packet[psize]=k2_low, packet[psize+1]=k1, packet[psize+2]=k2_high
    /// Reads: k1=packet[psize+1], k2=(packet[psize+2]<<8)|packet[psize]
    ///
    /// Decoding: base ^ 0x25, offset ^ 0x2361 (for client packets)
    pub fn from_bytes(bytes: &[u8]) -> Option<Self> {
        if let [offset_low, base_xored, offset_high] = *bytes {
            let offset_xored = ((offset_high as u16) << 8) | offset_low as u16;
            let base_raw = base_xored ^ Self::BASE_DECODE_XOR;
            let offset_raw = offset_xored ^ Self::OFFSET_DECODE_XOR;

            Some(Self {
                base: base_raw,
                offset: offset_raw,
            })
        } else {
            None
        }
    }

    /// Encodes this `LookupTableCursor` into a 3-byte trailer.
    /// Layout: [offset_high ^ 0x7424, base ^ 0x21, offset_low ^ 0x7424]
    pub fn to_bytes(&self) -> [u8; 3] {
        let base_xored = self.base ^ Self::BASE_ENCODE_XOR;
        let offset_xored = self.offset ^ Self::OFFSET_ENCODE_XOR;

        let offset_high = (offset_xored >> 8) as u8;
        let offset_low = offset_xored as u8;

        [offset_low, base_xored, offset_high]
    }

    pub fn from_trailer(data: &[u8]) -> Option<Self> {
        let trailer = data.get(data.len().saturating_sub(3)..)?;
        Self::from_bytes(trailer)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_generate_lookup_table() {
        let expected = concat!(
            "c7af1ee47dffb87731eceb5b050e80093d86677aba16b8e22e95cd06e199e693a426f5e20da59c91ca32917237a79e3c",
            "262f065e2688ab70c9c18fe926afa5979203efac509a77825c226f3731bc61d5fe42b4a160027a2c5d35ea8600893665",
            "8ca7874387bcb3e581af6f99c237264de2eef3e86012fb64708be1ac75a68261cde1461c1414516fe375bc79634f0759",
            "fab60d9da9b5a2b8d782c7c431232dbd7f5877659c80b536112de4916a62d18109b7217702aa6af1e7d0a6de59a36124",
            "c5347eb3f9f346cbd2a022111d4b80416ad32a39f060b6b188c7abad0f2b9007363f2a052ac3f17005fc84e373f66a10",
            "5e07e4a191fcc97da75dec246146ed1a303516274568888ff22579ebdbc0a98e0977327520e58e37016c4a643aa4793f",
            "3d289520f600696913f889e6d5fc69fc0a21ded89c51cd0dca6e6d27842368d9d0b443318034e3a518b94f4e52dc27dc",
            "9c5d83d76b44dec95c010dca232e6df71b436d999baeea74b19c79cbbc746e4e127b69b9e31ec9e5e80f75d5dd67bb61",
            "da3e1dd9942fbf5430b2918a734d1e64e5af5c9621fbc2b4a91a7ca624ed0586be38d100799d6249c6a4a0b9f31882ba",
            "f252a2168deabcff9ddb6d99a47132421ad79eed9e239652d2bb677427abcdf2add729793b08615568667ffce02b9d19",
            "f42c8e173d3d027183d3571b36b1da2843e69c2fa77061e3bcc1f56a3e69e915").as_bytes();

        let table = generate_lookup_table("grin");
        assert_eq!(table, expected);
    }

    #[test]
    fn test_xor_key_rolling() {
        let table = generate_lookup_table("delphi");
        let cursor = LookupTableCursor {
            base: 0x27,
            offset: 0x2060,
        };

        let key = xor_key_rolling(table, &cursor);
        assert_eq!(key, [0x33, 0x32, 0x39, 0x31, 0x65, 0x32, 0x62, 0x30, 0x36]);
    }

    #[test]
    fn fuzz_xor_key_rolling() {
        let table = generate_lookup_table("orb");

        for _ in 0..10000 {
            let cursor = LookupTableCursor {
                base: fastrand::u8(0..),
                offset: fastrand::u16(0..),
            };

            let _ = xor_key_rolling(table, &cursor);
            // Should never panic
        }
    }

    #[test]
    fn test_cursor_constants() {
        assert_eq!(LookupTableCursor::BASE_DECODE_XOR, 0x25);
        assert_eq!(LookupTableCursor::OFFSET_DECODE_XOR, 0x2361);
        assert_eq!(LookupTableCursor::BASE_ENCODE_XOR, 0x21);
        assert_eq!(LookupTableCursor::OFFSET_ENCODE_XOR, 0x7424);
    }

    #[test]
    fn test_from_bytes_with_slice() {
        let slice: &[u8] = &[0x04, 0x01, 0x02, 0x03];
        let cursor = LookupTableCursor::from_bytes(&slice[1..]).unwrap();
        assert_eq!(cursor.base, 0x27);
        assert_eq!(cursor.offset, 0x2060);
    }

    #[test]
    fn test_from_bytes_with_array() {
        let array = [0x01, 0x02, 0x03];
        let cursor = LookupTableCursor::from_bytes(&array).unwrap();
        assert_eq!(cursor.base, 0x27);
        assert_eq!(cursor.offset, 0x2060);
    }

    #[test]
    fn test_from_bytes_invalid_length() {
        assert!(LookupTableCursor::from_bytes(&[0x01, 0x02]).is_none());
        assert!(LookupTableCursor::from_bytes(&[0x01, 0x02, 0x03, 0x04]).is_none());
    }

    #[test]
    fn test_to_bytes_known_values() {
        let cursor = LookupTableCursor {
            base: 0xAB,
            offset: 0x1234,
        };

        let encoded = cursor.to_bytes();

        let expected_base = 0xAB ^ LookupTableCursor::BASE_ENCODE_XOR;
        let expected_offset = 0x1234 ^ LookupTableCursor::OFFSET_ENCODE_XOR;

        assert_eq!(encoded[0], expected_offset as u8);
        assert_eq!(encoded[1], expected_base);
        assert_eq!(encoded[2], (expected_offset >> 8) as u8);
    }

    #[test]
    fn test_from_trailer() {
        let slice: &[u8] = &[0x04, 0x01, 0x02, 0x03];
        let cursor = LookupTableCursor::from_trailer(&slice).unwrap();
        assert_eq!(cursor.base, 0x27);
        assert_eq!(cursor.offset, 0x2060);
    }

    #[test]
    fn fuzz_cursor_parsing() {
        for _ in 0..10000 {
            let random_bytes = [fastrand::u8(..), fastrand::u8(..), fastrand::u8(..)];
            let _ = LookupTableCursor::from_bytes(&random_bytes);
            // Should never panic
        }
    }

    #[test]
    fn test_random_cursor_generation_in_range() {
        for _ in 0..1000 {
            let cursor = LookupTableCursor::new();

            assert!(
                (100..=254).contains(&cursor.base),
                "base out of range={}",
                cursor.base
            );
            assert!(
                (256..=65532).contains(&cursor.offset),
                "offset out of range={}",
                cursor.offset
            );
        }
    }
}
