######## BUILDER #########
FROM golang:1.13-alpine3.11 AS builder
WORKDIR /votingapp

COPY go.mod .
COPY go.sum .

# Get dependancies - layer will be cached if we won't update mod/sum files
RUN go mod download

COPY . .
# alpine does not have gcc installed
ENV CGO_ENABLED=0
RUN go test
RUN go build -o /build/votingapp && \
    cp -r ui /build


######## RUNTIME #########
FROM alpine:3.11 

WORKDIR /app
COPY --from=builder /build .

ENTRYPOINT [ "./votingapp" ]