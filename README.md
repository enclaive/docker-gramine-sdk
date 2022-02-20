<div id="top"></div>
<!-- PROJECT SHIELDS -->

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![LGPL License][license-shield]][license-url]
[![Twitter][twitter-shield]][twitter-url]



<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/othneildrew/Best-README-Template">
    <img src="https://avatars.githubusercontent.com/u/84978589" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">gramineSDK</h3>

  <p align="center">
    Build environment to enclave applications in 5 min 🚀🚀 🚀  
    <br>
    #intelsgx # confidentialcompute
    <br />
    <br />
    <a href="https://github.com/enclaive/docker-gramineSDK/discussions"><strong>Join the discussion »</strong></a>
    <br />
    <br />
    <a href="#usage">Example</a>
    ·
    <a href="https://github.com/enclaive/docker-gramineSDK/issues">Report Bug</a>
    ·
    <a href="https://github.com/enclaive/docker-gramineSDK/issues">Request Feature</a>
  </p>
</div>

<!-- TABLE OF CONTENTS -->
## Table of Contents
- [About the project](#about-the-project)
- [Getting started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Usage blueprint](#usage)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [Support](#support)
- [Licence](#licence)
- [Contact](#contact)
- [Acknowledgments](#acknowledgments)

<!-- ABOUT THE PROJECT -->
## About The Project

<!--[![Product Name Screen Shot][product-screenshot]](https://enclaive.io) -->

> Gramine (formerly called Graphene) is a lightweight library OS, designed to run a single application with minimal host requirements. Gramine can run applications in an isolated environment with benefits comparable to running a complete OS in a virtual machine -- including guest customization, ease of porting to different OSes, and process migration.

Application enclavation is a fragile and delicate task. Specifically the design of the enclave manifest is an iterative and time-consuming process. Common pitfuls are the wrong linking of (dynamic) libraries, folders and files. To speed of the process the gramineSDK advocates a *blueprint* of how to strucutre and enclave applications. In addition, the SDK comes with a bunch of command line tools to speed the debugging and enclavation.

The aim of this project is a standardized build environment to ease the development of SGX-ready applications along tools and scripts. Note, the SDK aims to help with building and testing the `manifest.template` as well as debugging the enclave. Once the manifest is in place, you may want a self-contained container of your application. 

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- GETTING STARTED -->
## Getting Started

This is an example of how you may give instructions on setting up your project locally.
To get a local copy up and running follow these simple example steps.

### Prerequisites

An enclave-ready computing platform. You can check for *Intel Security Guard Extension (SGX)* presence by running the following
```
grep sgx /proc/cpuinfo
```
or have a thorough look at Intel's <a href="https://www.intel.com/content/www/us/en/support/articles/000028173/processors.html">processor list</a>. (We remark that macbooks with CPUs transitioned to Intel are unlikely supported. If you find a configuration, please [contact](#contact) us know.)

Note that in addition to SGX the hardware module must support FSGSBASE. FSGSBASE is an architecture extension that allows applications to directly write to the FS and GS segment registers. This allows fast switching to different threads in user applications, as well as providing an additional address register for application use. If your kernel version is 5.9 or higher, then the FSGSBASE feature is already supported and you can skip this step.

There are several options to proceed
* Case: No SGX-ready hardware </br> 
[Azure Confidential Compute](https://azure.microsoft.com/en-us/solutions/confidential-compute/") cloud offers VMs with SGX support. Prices are fair and have been recently reduced to support the [developer community](https://azure.microsoft.com/en-us/updates/announcing-price-reductions-for-azure-confidential-computing/). First-time users get $200 USD [free](https://azure.microsoft.com/en-us/free/) credit. Other cloud provider like [OVH](https://docs.ovh.com/ie/en/dedicated/enable-and-use-intel-sgx/) or [Alibaba](https://www.alibabacloud.com/blog/alibaba-cloud-released-industrys-first-trusted-and-virtualized-instance-with-support-for-sgx-2-0-and-tpm_596821) cloud have similar offerings.
* Case: Virtualization <br>
  Ubuntu 21.04 (Kernel 5.11) provides the driver off-the-shelf. Read the [release](https://ubuntu.com/blog/whats-new-in-security-for-ubuntu-21-04). 
* Case: Ubuntu (Kernel 5.9 or higher) <br>
Install the DCAP drivers from the Intel SGX [repo](https://github.com/intel/linux-sgx-driver)

  ```sh
  sudo apt update
  sudo apt -y install dkms
  wget https://download.01.org/intel-sgx/sgx-linux/2.13.3/linux/distro/ubuntu20.04-server/sgx_linux_x64_driver_1.41.bin -O sgx_linux_x64_driver.bin
  chmod +x sgx_linux_x64_driver.bin
  sudo ./sgx_linux_x64_driver.bin

  sudo apt -y install clang-10 libssl-dev gdb libsgx-enclave-common libsgx-quote-ex libprotobuf17 libsgx-dcap-ql libsgx-dcap-ql-dev az-dcap-client open-enclave
  ```

* Case: Other </br>
  Upgrade to Kernel 5.11 or higher. Follow the instructions [here](https://ubuntuhandbook.org/index.php/2021/02/linux-kernel-5-11released-install-ubuntu-linux-mint/).   


Install the docker engine
```sh
 sudo apt-get update
 sudo apt-get install docker-ce docker-ce-cli containerd.io
 sudo usermod -aG docker $USER    # manage docker as non-root user (obsolete as of docker 19.3) 
```
Use `docker run hello-world` to check if you can run docker (without sudo).

### Installation

Add your favorite tools to `packages.txt` list
```
libprotobuf-c1      # mandatory
build-essential     # mandatory
curl                # mandatory
nano
```
Build image
```
docker build \  
  -t ubuntu20.04-gramine-sdk \
  -f ubuntu20.04-gramineSDK.dockerfile . 
```

To see if the hosting OS provisioned the Intel SGX driver `/dev/sgx_enclave`, run 
```
docker run -it \
  --device=/dev/sgx_enclave \
  -v /var/run/aesmd/aesm.socket:/var/run/aesmd/aesm.socket \
  --entrypoint is-sgx-available \ 
  ubuntu20.04-gramine-sdk
```
and check flags `SGX1`, `SGX driver loaded` and `AESMD installed` are `true`.
				
Run container
```
docker run -it \
  --device=/dev/sgx_enclave \
  -v $(pwd)/manifest:/manifest \
  -v /var/run/aesmd/aesm.socket:/var/run/aesmd/aesm.socket \
  --name mygraminesdk
  ubuntu20.04-gramine-sdk
```

Restart container
```
docker start -i mygraminesdk
```
Useful to continue working with the last changes made (e.g. installed dependencies, applications, other tools)

Optional: Shared volume `/manifest`may be tricky to use when host and container have varying permissions. Change permissions
```
chown -R 777 ./manifest
```
to access the files without `sudo`(e.g. from IDE)
<p align="right">(<a href="#top">back to top</a>)</p>

<!-- USAGE EXAMPLES -->
## Usage blueprint

### SDK folder structure
Once you have build the container you have the following structure within the myGramineSDK container
```
-/                              
--/manifest                     # place the manifest here (shared volume)
--/entrypoint                   # place the build here
--/scripts                      # a bunch of helpful scripts, incl. manifest, launch & build
--/scripts/ssl                  # script to create self-signed SSL/TLS certicate (e.g. for server applications)
--/sgx-signer-key/enclaive.pem  # key to sign the enclave ($SGX_SIGNER_KEY)
--/templates                    # copy manifest template to /manifest/myApp.manifest.template
```

### SDK structure
The following commands are available to ease the enclavation of an application
```
manifest <entrypoint>           # generates signed manifest from  /manifest/<entrypoint>.manifest.template
launch <entrypoint>             # launches /entrypoint/<entrypoint> in an enclave
build <entrypoint>              # invocation of manifest & launch
```
Remark: Gramine supports the enclavation of binaries only. `<entrypoint>` must be the name of the binary. Scripts (e.g. bash, python) are invoked by running the interpreter (e.g. `/bin/bash`) and passing `myscript.sh` as argument.  

### How to build an enclave with gramineSDK
Build the project in folder `/entrypoint`
```
cd gramine-sdk/sample
make
make check                      # expects output [Success] 
cp helloworld /entrypoint
```
Create a manifest in folder `/manifest`
```
cp /gramine-sdk/templates/helloworld.manifest.template /manifest
```
Configure and sign the enclave 
```
# SDK
manifest helloworld

# 'manifest' calls  

cd /manifest

gramine-manifest \
      -Dlog_level=error \
      helloworld.manifest.template helloworld.manifest
      
gramine-sgx-sign \
	    --key $SGX_SIGNER_KEY \
	    --manifest helloworld.manifest \
	    --output helloworld.manifest.sgx

gramine-sgx-get-token -s helloworld.sig -o helloworld.token     // requires helloworld.manifest.sgx

```
Pre-load and execute `helloworld` in the enclave
```
# SDK
launch helloworld

# 'launch' calls
gramine-sgx /manifest/helloworld      // requires helloworld.manifest.sgx helloworld.sig helloworld.token
```

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- ROADMAP -->
## Roadmap

- [x] Add README
- [ ] Add more templates
- [ ] Add more examples
- [ ] Add tutorials
- [ ] Add debug section
- [ ] New features
    - [ ] Secret key provisioning
    - [ ] Remote attestation

See the [open issues](https://github.com/othneildrew/Best-README-Template/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**. If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- SUPPORT -->
## Support

Don't forget to give the project a star! Spread the word on social media! Thanks again!

<!-- LICENSE -->
## License

Distributed under the GNU Lesser General Public License v3.0 License. See `LICENSE` for more information.

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- CONTACT -->
## Contact

Sebastian Gajek - [@sebgaj](https://twitter.com/sebgaj) - sebastianl@enclaive.io

Project Site - [https://enclaive.io](https://enclaive.io)

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

This project greatly celebrates all contributions from the gramine team. Special shout out to [Dmitrii Kuvaiskii](https://github.com/dimakuv) from Intel for his support. 

* [Gramine Project](https://github.com/gramineproject)
* [Intel SGX](https://github.com/intel/linux-sgx-driver)

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/othneildrew/Best-README-Template.svg?style=for-the-badge
[contributors-url]: https://github.com/othneildrew/Best-README-Template/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/othneildrew/Best-README-Template.svg?style=for-the-badge
[forks-url]: https://github.com/othneildrew/Best-README-Template/network/members
[stars-shield]: https://img.shields.io/github/stars/othneildrew/Best-README-Template.svg?style=for-the-badge
[stars-url]: https://github.com/enclaive/docker-gramineSDK/stargazers
[issues-shield]: https://img.shields.io/github/issues/othneildrew/Best-README-Template.svg?style=for-the-badge
[issues-url]: https://github.com/enclaive/docker-gramineSDK/issues
[license-shield]: https://img.shields.io/github/license/othneildrew/Best-README-Template.svg?style=for-the-badge
[license-url]: https://github.com/othneildrew/Best-README-Template/blob/master/LICENSE.txt
[twitter-shield]: https://img.shields.io/twitter/url?label=Twitter&style=social&url=https%3A%2F%2Ftwitter.com%2Fenclaive_io
[twitter-url]: https://twitter.com/enclaive_io
[product-screenshot]: images/screenshot.png
