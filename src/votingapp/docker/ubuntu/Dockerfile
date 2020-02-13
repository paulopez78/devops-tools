######## BUILDER #########
FROM golang:1.13 AS builder
WORKDIR /votingapp

COPY go.mod .
COPY go.sum .

# Get dependancies - layer will be cached if we won't update mod/sum files
RUN go mod download

COPY . .
RUN go test
RUN go build -o /build/votingapp && \
    cp -r ui /build


######## RUNTIME #########
FROM ubuntu:18.04

WORKDIR /app
COPY --from=builder /build .

ENTRYPOINT [ "./votingapp" ]