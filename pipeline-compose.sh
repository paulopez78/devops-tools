#!/bin/bash

# cleanup
docker-compose rm -s -f

docker-compose up --build \
    --abort-on-container-exit \
    --exit-code-from mytest ||
    (docker-compose logs && exit 1)