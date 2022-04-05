FROM enclaive/debug-sgx

COPY gramine-build/packages.txt .
RUN apt-get update && xargs -a packages.txt -r apt-get install -y
RUN apt-get install -y "linux-headers-$(uname -r)"

USER user
WORKDIR /home/user

RUN git clone https://github.com/enclaive/gramine.git
WORKDIR ./gramine

RUN meson setup build/ \
    --buildtype=debug \
    -Ddirect=enabled \
    -Dsgx=enabled \
    -Dsgx_driver=upstream

RUN ninja -C build/

USER root
RUN ninja -C build/ install

ENTRYPOINT [ "/bin/bash" ]
