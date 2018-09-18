#!/bin/bash

source /scripts/constants
source /scripts/utils.sh

exdir=$(executing_dir)

cd "$exdir"

docker build --network=build -t my/dc01 "$exdir"
if [ "$?" != "0" ]; then echo "build failed"; exit 1; fi
