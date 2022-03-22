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


ENTRYPOINT ["/bin/bash"]
