# ubuntu 21.10 and intel/linux-sgx 0af6a83e
FROM ubuntu:impish

# set to noninteractive for debconf, just in case
ENV DEBIAN_FRONTEND noninteractive

# these packages are not required, since it is using a prebuilt version
COPY linux-sgx/packages.txt .
RUN apt-get update && xargs -a packages.txt -r apt-get install -y

COPY sgx_linux_x64_sdk_2.15.101.1.bin .
RUN ./sgx_linux_x64_sdk_2.15.101.1.bin --prefix /opt/intel

COPY sgx_debian_local_repo/ /opt/sgx_debian_local_repo/
COPY linux-sgx/intel-sgx-psw.list /etc/apt/sources.list.d/
RUN apt-get update && apt-get install -y libsgx-launch libsgx-urts

ENTRYPOINT [ "/bin/bash" ]
