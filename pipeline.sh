#!/bin/bash
set -e

# install deps
deps(){
    go mod download
}

# cleanup
cleanup(){
    pkill votingapp || ps aux | grep votingapp | awk 'print $1' | head -1 | xargs kill 9
    rm -rf build
}

unit_test(){
    go test ./src/votingapp
}

# build 
build(){
    mkdir build
    go build -o ./build ./src/votingapp 
    cp -r ./src/votingapp/ui ./build

    pushd build
    # docker run -p 6379:6379 -d redis || true
    # REDIS=localhost:6379 ./votingapp &
    ./votingapp &
    popd
}

retry(){
    n=0
    interval=5
    retries=3
    "$@" && return 0
    until [ $n -ge $retries ]
    do
        n=$((n+1))
        echo "Retrying...$n of $retries, wait for $interval seconds"
        sleep $interval
        "$@" && return 0
    done

    return 1
}

# test
test() {
    votingurl='http://localhost:5000/vote'
    curl --url  $votingurl \
        --request POST \
        --data '{"topics":["dev", "ops"]}' \
        --header "Content-Type: application/json" 

    curl --url $votingurl \
        --request PUT \
        --data '{"topic": "dev"}' \
        --header "Content-Type: application/json" 
    
    winner=$(curl --url $votingurl \
        --request DELETE \
        --header "Content-Type: application/json" | jq -r '.winner')

    echo Winner IS "$winner"

    expectedWinner="dev"

    if [ "$expectedWinner" == "$winner" ]; then
        echo 'TEST PASSED'
        return 0
    else
        echo 'TEST FAILED'
        return 1
    fi
}

deps
cleanup || true
unit_test
build
retry test