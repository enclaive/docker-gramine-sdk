#! /bin/bash

if [ -n "$1" ]; then
    source /gramine-sdk/scripts/sign.sh $1
    source /gramine-sdk/scripts/launch.sh $1   
else
    echo "Manifest: argument missing"
fi