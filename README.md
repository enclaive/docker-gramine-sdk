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
docker build -t ubuntu20.04-gramine-sdk -f ubuntu20.04-gramineSDK.dockerfile . 
```

## Run the container
Run the command
```
docker run -it \
  --device=/dev/sgx_enclave \
  -v $(pwd)/manifest:/manifest \
  -v /var/run/aesmd/aesm.socket:/var/run/aesmd/aesm.socket \ 
  ubuntu20.04-gramine-sdk
```
## Test for SGX-readiness
Test if your hosting OS has the SGX drivers properly installed
```
docker run -it \
  --device=/dev/sgx_enclave \
  -v /var/run/aesmd/aesm.socket:/var/run/aesmd/aesm.socket \
  --entrypoint is-sgx-available \ 
  ubuntu20.04-gramine-sdk
```
Check for flags `SGX1`, `SGX driver loaded` and `AESMD installed`.

## SDK file structure
Once you have build the container you have the following structure within the myGramineSDK container
```
\-                              
--\manifest                     # place your manifest here (shared volume)
--\entrypoint                   # place your build here
--\scripts                      # a bunch of helpful build scripts
--\sgx-signer-key\enclaive.pem  # key to sign the enclave
--\templates                    # copy manifest template to \manifest\myApp.manifest.template
```
## How to build an enclave within the container
Build the project in folder `\entrypoint`
```
cd gramine-sdk/sample
make
make check                      # [Success] if compilation went through
cp helloword /entrypoint
```
Create a manifest in folder `/manifest`
```
cp gramine-sdk/templates/helloworld.manifest.template
```
Generate the enclave 
```
gramine-manifest \
      -Dlog-level=error \
      /manifest/helloworld.manifest.template /manifest/helloworld.manifest
      
gramine-sgx-sign \
	    --key /gramine-sdk/sgx-signer-key/enclaive-key.pem \
	    --manifest /manifest/helloworld.manifest \
	    --output /manifest/helloworld.manifest.sgx
```
Run the enclave
```
gramine-sgx /manifest/helloword
```
