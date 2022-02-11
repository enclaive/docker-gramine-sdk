## Copyright (c) 2022 enclaive.io community
##
## author: Sebastian Gajek
## date: Feb 10 2022

FROM ubuntu:20.04
MAINTAINER sebastian@enclaive.io

RUN apt-get update && apt-get install -y libprotobuf-c1 curl build-essential
RUN curl -fsSLo /usr/share/keyrings/gramine-keyring.gpg https://packages.gramineproject.io/gramine-keyring.gpg
RUN echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/gramine-keyring.gpg] https://packages.gramineproject.io/ stable main' | tee /etc/apt/sources.list.d/gramine.list
RUN apt-get update && apt-get install -y gramine 


## setup environment
ENV PATH="/gramineSDK/scripts/:${PATH}"
ENV ENTRYPOINT="/entrypoint"
ENV SGX-SIGNER-KEY="/gramineSDK/sgx-signer-key/enclaive-key.pem"

COPY templates/ /gramineSDK/templates
COPY scripts /gramineSDK/scripts
COPY sample /gramineSDK/sample
RUN chmod +x /gramineSDK/scripts/
RUN /gramineSDK/scripts/setup.sh # generate sgx-signer-key
RUN mkdir /entrypoint  # copy binary here

ENTRYPOINT ["/bin/bash"]
