#![allow(unused_imports)]
use std::{
    io::{Read, Write},
    net::TcpListener,
};

fn main() {
    println!("redis>");

    let listener = TcpListener::bind("127.0.0.1:6379").unwrap();

    for stream in listener.incoming() {
        match stream {
            Ok(mut _stream) => loop {
                let mut buf = [0; 1024];

                let bytes_read = _stream.read(&mut buf).unwrap();

                let _command = String::from_utf8_lossy(&buf[..bytes_read]);

                _stream.write_all(b"+PONG\r\n").unwrap();
            },
            Err(e) => {
                println!("error: {}", e);
            }
        }
    }
}
