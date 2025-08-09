#[derive(Debug, PartialEq)]
pub enum XorMode {
    None,
    Fixed,
    Rolling,
}

#[derive(Debug, PartialEq)]
pub enum Source {
    Server,
    Client,
}

macro_rules! bitmask {
    ($($opcode:expr),* $(,)?) => {{
        let mut bits = [0u8; 32];
        $(
            bits[($opcode / 8) as usize] |= 1 << ($opcode % 8);
        )*
        bits
    }};
}

impl XorMode {
    const SERVER_BITMAP: [u8; 32] =
        bitmask![0x02, 0x03, 0x0A, 0x40, 0x44, 0x5E, 0x60, 0x62, 0x66, 0x6F];
    const CLIENT_BITMAP: [u8; 32] = bitmask![
        0x02, 0x03, 0x04, 0x0B, 0x15, 0x26, 0x3A, 0x42, 0x43, 0x4B, 0x50, 0x57, 0x62, 0x71, 0x73,
        0x7B
    ];

    #[inline(always)]
    const fn is_static(opcode: u8, bitmap: &[u8; 32]) -> bool {
        (bitmap[(opcode / 8) as usize] & (1 << (opcode % 8))) != 0
    }

    pub fn from(source: Source, opcode: u8) -> Self {
        match source {
            Source::Server if opcode == 0x00 => XorMode::None,
            Source::Server if Self::is_static(opcode, &Self::SERVER_BITMAP) => XorMode::Fixed,
            Source::Client if Self::is_static(opcode, &Self::CLIENT_BITMAP) => XorMode::Fixed,
            _ => XorMode::Rolling,
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_xor_mode_from() {
        assert_eq!(XorMode::from(Source::Server, 0x00), XorMode::None);
        assert_eq!(XorMode::from(Source::Server, 0x01), XorMode::Rolling);
        assert_eq!(XorMode::from(Source::Server, 0x02), XorMode::Fixed);
        assert_eq!(XorMode::from(Source::Server, 0x04), XorMode::Rolling);
        assert_eq!(XorMode::from(Source::Client, 0x01), XorMode::Rolling);
        assert_eq!(XorMode::from(Source::Client, 0x02), XorMode::Fixed);
        assert_eq!(XorMode::from(Source::Client, 0x02), XorMode::Fixed);
    }
}
