FROM ubuntu:18.04

RUN apt-get update && apt-get install curl -y && rm -rf /var/lib/apt/lists/*

ENTRYPOINT [ "curl" ]