FROM enclaive/debug-gramine

COPY debug-env/packages.txt .
RUN apt-get update && xargs -a packages.txt -r apt-get install -y

COPY debug-env/entrypoint.sh /

WORKDIR /gramine-os/sgx-signer-key
RUN openssl genrsa -3 -out /gramine-os/sgx-signer-key/enclaive-key.pem 3072
ENV SGX_SIGNER_KEY /gramine-os/sgx-signer-key/enclaive-key.pem

WORKDIR /manifest
COPY scripts/manifest.sh .
RUN chmod +x manifest.sh
RUN echo "alias manifest='/manifest/manifest.sh'" >> ~/.bashrc

WORKDIR /entrypoint
COPY scripts/enclaive.sh .
RUN chmod +x enclaive.sh
RUN echo "alias enclaive='/entrypoint/enclaive.sh'" >> ~/.bashrc

ENTRYPOINT [ "/entrypoint.sh" ]
