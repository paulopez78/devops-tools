#!/bin/bash
set -e

integration_test(){
    run_tests(){
        url="http://localhost:8080"
        # test api with curl (test serialization and broken contract)
        curl \
        --url $url/vote \
        --request POST \
        --data '{"topics":["Dev", "Ops"]}' \
        --header "Content-Type: application/json"

        curl \
        --url $url/vote \
        --request PUT \
        --data '{"topic":"Ops"}' \
        --header "Content-Type: application/json"

        winner=$(curl \
        --silent \
        --url $url/vote \
        --request DELETE \
        --header "Content-Type: application/json" | jq -r .winner)
        
        if [ "$winner" == "Ops" ]; then
            echo "Test passed!"
        else
            echo "Test Failed!"
            return 1
        fi
    }

    retry (){
        for i in {1..5}; do
            echo "Trying $i of 5"
            sleep $((i*i)) 
            "$@" && return 0
        done
        
        return 1
    }

    retry run_tests
}

docker build \
    -t paulopez/votingapp:0.1 \
    -f ./src/votingapp/docker/Dockerfile \
    ./src/votingapp

docker rm -f myvotingapp || true
docker run \
    --name myvotingapp -d \
    -p 8080:5000 \
    paulopez/votingapp:0.1

integration_test

docker push paulopez/votingapp:0.1