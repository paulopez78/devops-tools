#!/bin/bash
set -e
# export DOCKER_BUILDKIT=1

registry=${DOCKER_REGISTRY:-"paulopez"} 
tag=${TAG:-"1.0"} 
network=votingapp
base_image=${BASE_IMAGE:-"alpine"}
test_type=${TEST_TYPE:-"shell"}
image=$registry/votingapp:$tag-$base_image
test_image=$registry/votingapp-test:$base_image

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
    -f ./test/"$test_type"/docker/"$base_image"/Dockerfile \
    ./test/"$test_type"

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
    --rm -e VOTING_URL="http://myvotingapp:5000" \
    --network "$network" \
    "$test_image"

# delivery
docker login -u "$registry" --password-stdin < docker-password
docker push "$image"
