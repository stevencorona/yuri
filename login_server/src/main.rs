use std::sync::Arc;
use tokio::net::TcpListener;
use tokio::signal;
use tokio::sync::broadcast;
use tracing::{error, info};

mod client;
mod packet;
mod server_state;

type Result<T> = anyhow::Result<T>;

#[tokio::main]
async fn main() -> Result<()> {
    // Set up logging
    tracing_subscriber::fmt::init();

    let (shutdown_tx, mut shutdown_rx) = broadcast::channel(1);
    // Task to listen for Ctrl+C
    tokio::spawn(async move {
        signal::ctrl_c().await.expect("Failed to listen for Ctrl+C");
        info!("Ctrl+C received, initiating shutdown...");
        // Send a shutdown signal to other tasks
        let _ = shutdown_tx.send(());
    });

    let listener = TcpListener::bind("0.0.0.0:2000").await?;
    info!("Login server listening on {}", "0.0.0.0:2000");

    let state = Arc::new(server_state::ServerState {
        xor_key: [1, 2, 3, 4, 5, 6, 7, 8, 9],
        major_version: 752,
        patch_url: "https://example.com/patch".to_string(),
    });

    loop {
        tokio::select! {
            // Accept new connections
            Ok((socket, addr)) = listener.accept() => {
                info!("Accepted connection from {:?} {:?}", socket.peer_addr(), addr);
                let state_clone = Arc::clone(&state);
                // Handle the connection in a new task
                tokio::spawn(async move {
                    if let Err(e) = client::handle_connection(state_clone, socket, addr).await {
                         error!("Error handling client {}: {}", addr, e);
                     }
                });
            }
            // Receive shutdown signal
            _ = shutdown_rx.recv() => {
                info!("Shutdown signal received, stopping server.");
                break; // Exit the main loop
            }
        }
    }

    Ok(())
}
