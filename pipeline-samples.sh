#!/bin/bash

unit_test(){
    set -e
    go test ./src/votingapp
    set +e
    echo $?
}

build(){
    rm -r build
    echo $?

    mkdir -p ./build
    echo $?

    # option 1: using flags 
    set -e
    go build -o build ./src/votingapp
    set +e
    echo $?

    # option 2: inline
    # go build -o build ./src/votingapp || exit 1 

    # option 3: check variable
    # if [ $? -gt 0 ]; then
    #     exit 1
    # fi

    # option 4: check command
    # if ! go build -o build ./src/votingapp;  then
    #     exit 1
    # fi

    cp -r ./src/votingapp/ui build
    echo $?
}

integration_test(){
    run_app(){
        # kill application
        pkill votingapp

        # run application
        pushd build
        ./votingapp &
        echo $?
        popd
    }

    run_tests(){
        # test api with curl (test serialization and broken contract)
        curl \
        --url http://localhost:5000/vote \
        --request POST \
        --data '{"topics":["Dev", "Ops"]}' \
        --header "Content-Type: application/json"
        echo $?

        curl \
        --url http://localhost:5000/vote \
        --request PUT \
        --data '{"topic":"Ops"}' \
        --header "Content-Type: application/json"
        echo $?

        winner=$(curl \
        --silent \
        --url http://localhost:5000/vote \
        --request DELETE \
        --header "Content-Type: application/json" | jq -r .winner)
        echo $?
        
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
            echo $?
        done
        
        return 1
    }

    run_app

    # option1, hack: wait for app to startup
    # sleep 1 && run_tests

    # option2, must retry when doing integration test
    set -e
    retry run_tests
    set +e

}

deliver(){
    #build_number=$(date +%s) 
    build_number=$(git rev-parse --short HEAD)
    tar cvf votingapp"$build_number".tar.gz build
    # upload to shared repository (NFS, FTP, ...)
}

unit_test
build
integration_test
deliver