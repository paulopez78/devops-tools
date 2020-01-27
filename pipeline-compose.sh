#!/bin/bash

docker-compose rm -f && \
docker-compose up --build -d && \
docker-compose run --rm mytest && \
docker-compose push && \
echo "GREEN" || echo "RED"