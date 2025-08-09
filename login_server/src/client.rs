use crate::packet::{self, ClientPacket, ServerPacket};
use crate::server_state::{ClientSession, ServerState};
use crate::Result;
use std::net::SocketAddr;
use std::sync::Arc;
use tokio::io::{AsyncReadExt, AsyncWriteExt};
use tokio::net::TcpStream;
use tracing::{error, info, warn};

/// Handles a single client connection from start to finish.
pub async fn handle_connection(
    state: Arc<ServerState>,
    mut stream: TcpStream,
    addr: SocketAddr,
) -> Result<()> {
    // Create a session state for this specific client.
    let mut session = ClientSession::new(addr);

    // Send the initial "CONNECTED" packet
    stream.write_all(b"\xAA\x00\x13\x7E\x1B\x43\x4F\x4E\x4E\x45\x43\x54\x45\x44\x20\x53\x45\x52\x56\x45\x52\x0A").await?;

    let mut buffer = vec![0u8; 4096]; // A buffer for reading incoming data.

    loop {
        // tokio's select! allows waiting on multiple async operations.
        tokio::select! {
            // Read data from the client stream
            result = stream.read(&mut buffer) => {
                let bytes_read = match result {
                    Ok(0) => {
                        info!("Client {} disconnected.", addr);
                        break; // Connection closed
                    },
                    Ok(n) => n,
                    Err(e) => {
                        warn!("Error reading from client {}: {}", addr, e);
                        break;
                    }
                };

                // In a real implementation, a proper framing solution like
                // `tokio_util::codec` would be used to handle packet boundaries.
                // For this example, we assume one packet per read for simplicity.
                let data = &buffer[..bytes_read];

                // The original code has a custom static "encryption". We would
                // decrypt the packet here before parsing.
                // let decrypted_data = packet::tk_crypt_static(data);

                match ClientPacket::from_bytes(data) {
                    Ok(packet) => {
                        if let Err(e) = handle_packet(packet, &state, &mut session, &mut stream).await {
                            error!("Error processing packet for {}: {}", addr, e);
                            // Send an error message to the client before closing.
                            let error_msg = ServerPacket::message(0x03, "An internal server error occurred.");
                            stream.write_all(&error_msg.to_bytes()).await?;
                            break;
                        }
                    }
                    Err(e) => {
                        warn!("Packet parsing error from {}: {}", addr, e);
                        break; // Invalid packet, close connection
                    }
                }
            }
        }
    }

    Ok(())
}

/// Dispatches packets to the appropriate handler logic.
/// This replaces the large `switch` statement in the C code.
async fn handle_packet(
    packet: ClientPacket,
    state: &Arc<ServerState>,
    session: &mut ClientSession,
    stream: &mut TcpStream,
) -> Result<()> {
    match packet {
        ClientPacket::Version { version, patch } => {
            info!("Client version: {}, patch: {}", version, patch);
            if version == state.major_version {
                let response = ServerPacket::version_ok(&state.xor_key);
                stream.write_all(&response.to_bytes()).await?;
            } else {
                let response = ServerPacket::patch_required(state.major_version, &state.patch_url);
                stream.write_all(&response.to_bytes()).await?;
            }
        }
        ClientPacket::LoginRequest { username, password } => {
            // Validate credentials
            if username.len() < 3 || username.len() > 12 {
                let response = ServerPacket::message(0x03, "Invalid username format.");
                stream.write_all(&response.to_bytes()).await?;
                return Ok(());
            }

            info!("Login attempt for user: {}", username);

            return Ok(());
        }
        // ... other packet handlers would go here ...
        ClientPacket::Unknown { id, data } => {
            warn!(
                "Received unknown packet with ID {:#04X} and data: {:?}",
                id, data
            );
        }
    }
    Ok(())
}
