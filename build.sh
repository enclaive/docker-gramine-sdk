#!/bin/sh

su - user -c '
    git clone --branch=master https://github.com/enclaive/gramine.git \
    && cd ./gramine/ \
    && git checkout 57b2cb3 \
    && git reset --hard \
    && meson setup build/ \
        -Ddirect=enabled \
        -Dsgx=enabled \
        -Ddcap=enabled \
        -Dsgx_driver=oot \
        -Dsgx_driver_include_path=/usr/include/x86_64-linux-gnu/ \
    && ninja -C build/
'

ninja -C /home/user/gramine/build/ install
