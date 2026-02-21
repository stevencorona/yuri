use std::net::SocketAddr;

pub struct ClientSession {
    addr: SocketAddr,
}

impl ClientSession {
    pub fn new(addr: SocketAddr) -> Self {
        ClientSession { addr: addr }
    }
}

pub struct ServerState {
    pub xor_key: [u8; 9],
    pub major_version: u16,
    pub patch_url: String,
}
