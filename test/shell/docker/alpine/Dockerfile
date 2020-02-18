FROM alpine:3.11

RUN apk update && apk add --no-cache \
    curl \
    jq

COPY test.sh .
RUN chmod +x test.sh

ENTRYPOINT ["sh", "-c", "./test.sh" ]