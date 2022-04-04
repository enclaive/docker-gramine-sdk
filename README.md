# docker-gramineSDK

This branch contains `Dockerfile`s for building and using the Intel(R) SGX SDK and PSW in debug-mode.

## TODO

- built a container containing `gramine` in debug-mode
- add debug tools inside the container

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
```

The requirements of the in-kernel driver are described here: [Intel(R) SGX Software Installation Guide](https://download.01.org/intel-sgx/sgx-linux/2.15.1/docs/Intel_SGX_SW_Installation_Guide_for_Linux.pdf#page=5)

For additonal information about FLC, visit: https://gramine.readthedocs.io/en/latest/sgx-intro.html#term-flc

## Building

To build the container:

```bash
docker build -t IMAGE_NAME_HERE -f impish-sgx-build.dockerfile .
```

After building, you should copy the created files to your host:

```bash
id=$(docker create IMAGE_NAME_HERE)
docker cp $id:/home/user/linux-sgx/linux/installer/bin/sgx_linux_x64_sdk_2.15.101.1.bin .
docker cp $id:/opt/sgx_debian_local_repo .
docker rm -v $id
```

This way, minor modifications be made (packages etc.) without waiting for the build every time:

```bash
docker build -t IMAGE_NAME_HERE -f impish-sgx-prebuilt.dockerfile .
```

## Usage

TBD

## Versions

This build was tested on `5.13.0-39-generic` (Ubuntu 21.10) using the latest commit `0af6a83e` (11.3.2022, last tag: `sgx_2.15.1`) of the `intel/linux-sgx` repository and `docker` with version `1.5-2`.

## Additional information

The build process for the PSW is broken. Patches are included in `linux-sgx/`.

To update them

```bash
# for tracked files
git diff psw/ linux/installer/ > linux-sgx/patch.diff

# for untracked files, create the original in a/ and modification in b/
diff -r a/ b/ > linux-sgx/external.diff
```
