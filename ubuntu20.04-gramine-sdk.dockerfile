## Copyright (c) 2022 enclaive.io community
##
## author: Sebastian Gajek
## date: Feb 10 2022

FROM enclaive/gramine-os:latest

ENV DEBIAN_FRONTEND noninteractive

COPY packages.txt packages.txt
RUN apt-get update && xargs -r apt-get install -y < packages.txt 

## setup build environment
WORKDIR /gramine-sdk/templates
COPY templates/ .

WORKDIR /gramine-sdk/sample
COPY sample/ .

WORKDIR /gramine-sdk/scripts
ENV PATH=$PATH:/gramine-sdk/scripts

COPY scripts/launch.sh .
RUN chmod +x launch.sh 
RUN echo "alias launch='/gramine-sdk/scripts/launch.sh'" >> ~/.bashrc

COPY scripts/relaunch.sh .
RUN chmod +x relaunch.sh 
RUN echo "alias relaunch='/gramine-sdk/scripts/relaunch.sh'" >> ~/.bashrc

COPY scripts/sign.sh .
RUN chmod +x sign.sh 
RUN echo "alias sign='/gramine-sdk/scripts/sign.sh'" >> ~/.bashrc

WORKDIR /gramine-sdk/sgx-signer-key
RUN openssl genrsa -3 -out /gramine-sdk/sgx-signer-key/enclaive-key.pem 3072
ENV SGX_SIGNER_KEY /gramine-sdk/sgx-signer-key/enclaive-key.pem

## sshd
WORKDIR /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
EXPOSE 22

ENTRYPOINT service ssh start && bash
