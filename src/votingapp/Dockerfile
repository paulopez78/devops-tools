######## BUILDER #########
FROM golang AS builder

RUN go get github.com/gorilla/websocket && \
    go get github.com/labstack/echo && \
    go get github.com/go-redis/redis

COPY . .

RUN go build -o /build/votingapp && \
    cp -r ui /build


######## RUNTIME #########
FROM ubuntu:18.04

WORKDIR /app
COPY --from=builder /build .

ENTRYPOINT [ "./votingapp" ]