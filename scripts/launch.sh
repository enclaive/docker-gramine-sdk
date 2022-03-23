#! /bin/bash

if [ -n "$1" ]; then
  gramine-sgx /manifest/$1 $2 $3 $4 $5 
else
  echo "Manifest: argument missing"
fi

