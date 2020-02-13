FROM golang:1.13 AS builder

WORKDIR /app

COPY . .
RUN go build -o /build/votingapp && \
    cp -r ui /build

WORKDIR /build
ENTRYPOINT [ "./votingapp" ]