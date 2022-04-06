# docker-gramineSDK

This branch contains `Dockerfile`s for building and using the Intel(R) SGX SDK and PSW in debug-mode.

## TODO

- setup gdb extensions

## Requirements

It is expected that you are using a kernel version `>=5.11` with the upstream driver, providing the SGX devices, after confirming that SGX and FLC is supported by your cpu:

```bash
# check your kernel release
uname -r

# the availability of flc can be checked using /proc/cpuinfo
grep -q 'sgx_lc' /proc/cpuinfo && echo "SGX LC available"

# alternatively use cpuid (available from apt)
cpuid -1 | grep -i sgx
>      SGX: Software Guard Extensions supported = true
>      SGX_LC: SGX launch config supported      = true

# verify that the driver is loaded
dmesg | grep -i sgx
> ... sgx: EPC section ...

# these devices should exist on your host
ls /dev/sgx_*
> /dev/sgx_enclave  /dev/sgx_provision  /dev/sgx_vepc
# the aesmd uses /dev/sgx/enclave, which is just a symlink to sgx_enclave
```

The requirements of the in-kernel driver are described here: [Intel(R) SGX Software Installation Guide](https://download.01.org/intel-sgx/sgx-linux/2.15.1/docs/Intel_SGX_SW_Installation_Guide_for_Linux.pdf#page=5)

For additonal information about FLC, visit: https://gramine.readthedocs.io/en/latest/sgx-intro.html#term-flc

## Building

To build the container:

```bash
docker build -t enclaive/debug-sgx -f impish-sgx-build.dockerfile .
```

After building, you should copy the created files to your host:

```bash
id=$(docker create enclaive/debug-sgx)
docker cp $id:/home/user/linux-sgx/linux/installer/bin/sgx_linux_x64_sdk_2.16.100.4.bin .
docker cp $id:/opt/sgx_debian_local_repo .
docker rm -v $id
```

To build all three images at once, use `docker-compose build`. This will use the `prebuilt`-`dockerfile`, so make sure these files exists. This way, minor modifications can be made (packages etc.) without waiting for the build every time.

## Usage

After building `enclaive/debug-env`, you can either start it manually or with `docker-compose up -d debug-env`, then attach a shell using `docker-compose exec debug-env /bin/bash`. This will duplicate the shell from `debug-env/entrypoint.sh`, which is used as a shortcut when manually running the container using `docker` and for keeping the container alive after the `aesm_service` forked itself and exited.

## Versions

This build was tested on `5.13.0-39-generic` (Ubuntu 21.10) using `sgx_2.16` of `intel/linux-sgx` and `docker` with version `1.5-2`. The `gramine` repository is `enclaive/gramine` using the latest commit on the default branch.

## Additional information

The build process for the PSW is broken. Patches are included in `linux-sgx/`.

To update them

```bash
# for tracked files
git diff psw/ linux/installer/ > linux-sgx/patch.diff

# for untracked files, create the original in a/ and modification in b/
diff -Naur a/ b/ > linux-sgx/external.diff
```
