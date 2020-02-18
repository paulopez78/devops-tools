#!/bin/bash
set -e
# export DOCKER_BUILDKIT=1

registry=${DOCKER_REGISTRY:-"paulopez"} 
network=votingapp
base_image=${BASE_IMAGE:-"alpine"}
image=$registry/votingapp
test_image=$registry/votingapp-test

docker network create "$network"|| true

# cleanup
docker rm -f myvotingapp || true
docker rm -f myredis || true

# build
docker build \
    -t "$image" \
    -f ./src/votingapp/docker/"$base_image"/Dockerfile \
    ./src/votingapp

docker build \
    -t "$test_image" \
    -f ./test/docker/"$base_image"/Dockerfile \
    ./test

# run
docker run \
    --name myredis \
    --network "$network" \
    -d redis 

docker run \
    --name myvotingapp \
    --network "$network" \
    -p 8080:5000 \
    -e REDIS="myredis:6379" \
    -d "$image"

# test
docker run \
    --rm -e VOTINGAPP_HOST="myvotingapp:5000" \
    --network "$network" \
    "$test_image"

# delivery
docker login -u "$registry" --password-stdin < docker-password
docker push "$image"
