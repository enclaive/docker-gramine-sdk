#! /bin/bash
mkdir /gramine-sdk/sgx-signer-key/
openssl genrsa -3 -out /gramine-sdk/sgx-signer-key/enclaive-key.pem 3072


