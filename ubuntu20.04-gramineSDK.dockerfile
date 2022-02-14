## Copyright (c) 2022 enclaive.io community
##
## author: Sebastian Gajek
## date: Feb 10 2022

FROM ubuntu:20.04

COPY packages.txt packages.txt
RUN apt-get update && xargs -r apt-get install -y < packages.txt 

RUN curl -fsSLo /usr/share/keyrings/gramine-keyring.gpg https://packages.gramineproject.io/gramine-keyring.gpg
RUN echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/gramine-keyring.gpg] https://packages.gramineproject.io/ stable main' | tee /etc/apt/sources.list.d/gramine.list
RUN apt-get update && apt-get install -y gramine 

## setup build environment
COPY templates/ /gramine-sdk/templates
COPY sample /gramine-sdk/sample
COPY scripts /gramine-sdk/scripts
RUN . /gramine-sdk/scripts/setup.sh  

# cleaning up
RUN rm -f packages.txt /gramine-sdk/script/setup.sh 

# path to enclave signing key
ENV SGX_SIGNER_KEY=/gramine-sdk/sgx-signer-key/enclaive-key.pem

 

ENTRYPOINT ["/bin/bash"]
