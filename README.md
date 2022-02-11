# gramineSDK: Build Environment for development of enclaved applications 
## Objective
The aim is a standardized build environment to ease the development of SGX-ready applications along tools and scripts. Note, the SDK aims to help with building and testing the `manifest.template` as well as debugging the enclave. Once the manifest is in place, you may want a self-contained container of your application. Please read [here](https://github.com/enclaive/docker-gramineOS).

## Prerequisites
An SGX-ready computing environment. Read more

Install the docker engine
```
 sudo apt-get update
 sudo apt-get install docker-ce docker-ce-cli containerd.io
```

## Build image
Run the command
```
docker build -t ubuntu20.04-gramineSDK -f ubuntu20.04-gramineSDK.dockerfile . 
```

## Run the container
Run the command
```
# first time create a container name myGramineSDK
docker run -it 
  --name myGramineSDK
  --device=/dev/sgx_enclave
  -v ./manifest:/manifest
  -v /var/run/aesmd/aesm.socket:/var/run/aesmd/aesm.socket 
  ubuntu20.04-gramineSDK

# thereafter invoke the container myGramineSDK
docker run -it 
  --device=/dev/sgx_enclave
  -v ./manifest:/manifest
  -v /var/run/aesmd/aesm.socket:/var/run/aesmd/aesm.socket
  myGramineSDK
```

## Structure
Once you have build the container you have the following structure within the myGramineSDK container
```
\-                              
--\manifest                     # place your manifest here (shared volume)
--\entrypoint                   # place your build folder here
--\scripts                      # a bunch of helpful build scripts
--\sgx-signer-key\enlaive.pem   # key to sign the enclave
--\templates                    # copy manifest template to \manifest\myApp.manifest.template
```
## How to build an enclave
