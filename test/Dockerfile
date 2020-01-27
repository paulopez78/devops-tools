FROM ubuntu:18.04

RUN apt-get update && apt-get install -y \
    curl \
    jq \
    && rm -rf /var/lib/apt/lists/*

COPY test.sh .
RUN chmod +x test.sh

ENTRYPOINT ["bash", "-c", "./test.sh" ]