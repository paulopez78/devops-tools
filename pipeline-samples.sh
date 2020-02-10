#!/bin/bash

pipeline_example1(){
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

pipeline_example1