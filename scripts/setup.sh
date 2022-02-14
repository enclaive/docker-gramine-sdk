#! /bin/bash
shopt -u expand_aliases

# create enclave signing key
mkdir /gramine-sdk/sgx-signer-key/
openssl genrsa -3 -out /gramine-sdk/sgx-signer-key/enclaive-key.pem 3072

# build environment
mkdir /entrypoint
mkdir /manifest
cd /gramine-sdk/scripts
chmod +x build.sh && echo "alias build='/gramine-sdk/scripts/build.sh'" >> ~/.bashrc
chmod +x launch.sh && echo "alias launch='/gramine-sdk/scripts/launch.sh'" >> ~/.bashrc
chmod +x manifest.sh && echo "alias manifest='/gramine-sdk/scripts/manifest.sh'" >> ~/.bashrc
chmod +x manifest.sh && echo "alias relaunch='/gramine-sdk/scripts/relaunch.sh'" >> ~/.bashrc

