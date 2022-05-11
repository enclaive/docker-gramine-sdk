#! /bin/bash

if [ -n "$1" ]; then
  gramine-sgx /manifest/$1  
else
  echo "Manifest: argument missing"
fi

