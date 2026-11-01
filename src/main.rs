use tokio::net::TcpListener;
use tokio::io::{AsyncReadExt, AsyncWriteExt};

#[tokio::main]
async fn main() {
    let listener = TcpListener::bind("127.0.0.1:6379")
        .await
        .unwrap();

    loop {
        let (mut socket, address) = listener.accept().await.unwrap();

        println!("New client: {}", address);

        tokio::spawn(async move {
            let mut buf = [0; 1024];

            loop {
                match socket.read(&mut buf).await {
                    Ok(0) => break,

                    Ok(n) => {
                        println!(
                            "Received: {}",
                            String::from_utf8_lossy(&buf[..n])
                        );

                        socket.write_all(b"+PONG\r\n").await.unwrap();
                    }

                    Err(e) => {
                        println!("Error: {e}");
                        break;
                    }
                }
            }
        });
    }
}