# Image used by ../test.sh: CodeCrafters' Rust build image plus the prebuilt redis-tester.
FROM rust:1.96-trixie

# Pinned tester version; bump it when upstream adds stages (github.com/codecrafters-io/redis-tester/releases)
ARG TESTER_VERSION=v213
RUN mkdir /tester && curl -fsSL "https://github.com/codecrafters-io/redis-tester/releases/download/${TESTER_VERSION}/${TESTER_VERSION}_linux_$(dpkg --print-architecture).tar.gz" | tar -xz -C /tester

ENV TESTER_DIR=/tester
