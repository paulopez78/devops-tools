#!/bin/bash

# cleanup
docker-compose rm -s -f

docker-compose up --build \
    --abort-on-container-exit \
    --exit-code-from test ||
    (docker-compose logs && exit 1)

docker-compose push