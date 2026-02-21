use crate::Result;
use anyhow::anyhow;
use bytes::{Buf, BufMut, Bytes, BytesMut};

/// Represents all possible packets sent from the client to the server.
#[derive(Debug)]
pub enum ClientPacket {
    Version { version: u16, patch: u16 },
    LoginRequest { username: String, password: String },
    Unknown { id: u8, data: Bytes },
}

/// Represents all possible packets sent from the server to the client.
#[derive(Debug)]
pub enum ServerPacket {
    Message { code: u8, text: String },
    VersionOk { xor_key: Vec<u8> },
    PatchRequired { new_version: u16, url: String },
    LoginSuccess(),
}

impl ClientPacket {
    /// Parses a raw byte slice into a `ClientPacket`.
    pub fn from_bytes(data: &[u8]) -> Result<(ClientPacket)> {
        let mut buf = Bytes::copy_from_slice(data);
        if buf.remaining() < 4 || buf.get_u8() != 0xAA {
            return Err(anyhow!("Invalid packet header"));
        }
        let _len = buf.get_u16_le(); // Length field
        let id = buf.get_u8();

        match id {
            0x00 => {
                // Version check
                let version = buf.get_u16_le();
                buf.advance(1); // Skip unknown byte
                let patch = buf.get_u16_le();
                Ok(Self::Version { version, patch })
            }
            0x03 => {
                // Login
                buf.advance(2); // Skip unknown bytes
                let user_len = buf.get_u8() as usize;
                let username = String::from_utf8_lossy(&buf.copy_to_bytes(user_len)).to_string();
                let pass_len = buf.get_u8() as usize;
                let password = String::from_utf8_lossy(&buf.copy_to_bytes(pass_len)).to_string();
                Ok(Self::LoginRequest { username, password })
            }
            _ => Ok(Self::Unknown {
                id,
                data: buf.copy_to_bytes(buf.remaining()),
            }),
        }
    }
}

impl ServerPacket {
    pub fn message(code: u8, text: &str) -> Self {
        Self::Message {
            code,
            text: text.to_string(),
        }
    }

    pub fn version_ok(xor_key: &[u8]) -> Self {
        Self::VersionOk {
            xor_key: xor_key.to_vec(),
        }
    }

    pub fn patch_required(new_version: u16, url: &str) -> Self {
        Self::PatchRequired {
            new_version,
            url: url.to_string(),
        }
    }

    pub fn login_success() -> Self {
        Self::LoginSuccess()
    }

    /// Serializes a `ServerPacket` into a byte vector for sending.
    pub fn to_bytes(&self) -> Vec<u8> {
        let mut buf = BytesMut::with_capacity(256);
        buf.put_u8(0xAA);
        buf.put_u16_le(0); // Placeholder for length

        match self {
            Self::Message { code, text } => {
                buf.put_u8(0x02); // Packet ID
                buf.put_u8(0x02); // Sub ID
                buf.put_u8(*code);
                buf.put_u8(text.len() as u8);
                buf.put_slice(text.as_bytes());
            }
            Self::VersionOk { xor_key } => {
                buf.put_u8(0x00);
                buf.put_slice(&[0x00, 0x27, 0x4F, 0x8A, 0x4A, 0x00, 0x09]);
                buf.put_slice(xor_key);
            }
            Self::PatchRequired { new_version, url } => {
                buf.put_u8(0x00);
                buf.put_u8(0x02);
                buf.put_u16_le(*new_version);
                buf.put_u8(0x01);
                buf.put_u8(0x23);
                buf.put_slice(url.as_bytes());
            }
            Self::LoginSuccess() => {
                // This builds the two separate success packets from the C code
                // First packet
                buf.put_slice(&[0x05, 0x02, 0x17, 0x00, 0x00, 0x00]); // Hardcoded values

                // Second packet (this would typically be sent separately)
                // For simplicity, we can't combine them easily with this function signature
                // A better approach is to have this function return Vec<Vec<u8>>
                // or handle multi-packet responses at the call site.
            }
        }

        // Finalize packet by writing the correct length
        let len = (buf.len() - 3) as u16;
        buf[1..3].copy_from_slice(&len.to_le_bytes());

        // The custom static "encryption" would be applied here.
        // tk_crypt_static(&mut buf);
        buf.to_vec()
    }
}
