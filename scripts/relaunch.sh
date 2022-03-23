#! /bin/bash

if [ -n "$1" ]; then
    /gramine-sdk/scripts/sign.sh $1
    /gramine-sdk/scripts/relaunch.sh $1 $2 $3 $4 $5    
else
    echo "Manifest: argument missing"
fi