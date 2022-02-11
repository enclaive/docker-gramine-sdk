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


## setup build environment
ENV PATH="/gramine-sdk/scripts/:${PATH}"
ENV ENTRYPOINT="/entrypoint"
ENV SGX-SIGNER-KEY="/gramine-sdk/sgx-signer-key/enclaive-key.pem"

COPY templates/ /gramine-sdk/templates
COPY scripts /gramine-sdk/scripts
COPY sample /gramine-sdk/sample
RUN chmod +x /gramine-sdk/scripts/setup.sh
RUN /gramine-sdk/scripts/setup.sh # generate sgx-signer-key
RUN mkdir /entrypoint  # add binary here
RUN mkdir /manifest  # add manifest here

ENTRYPOINT ["/bin/bash"]
