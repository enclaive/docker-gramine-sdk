<div id="top"></div>
<!-- PROJECT SHIELDS -->

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![Twitter][twitter-shield]][twitter-url]



<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/othneildrew/Best-README-Template">
    <img src="https://avatars.githubusercontent.com/u/84978589" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">gramineSDK</h3>

  <p align="center">
    Build environment to enclave applications in 5 min! 
    <br>
    #intelsgx # confidentialcompute
    <br />
    <a href="https://github.com/othneildrew/Best-README-Template"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="#usage>Example</a>
    ·
    <a href="https://github.com/enclaive/docker-gramineSDK/issues">Report Bug</a>
    ·
    <a href="https://github.com/enclaive/docker-gramineSDK/issues">Request Feature</a>
  </p>
</div>



<!-- TABLE OF CONTENTS -->

## Table of Contents
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#why">Why</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>




<!-- ABOUT THE PROJECT -->
## About The Project

<!--[![Product Name Screen Shot][product-screenshot]](https://enclaive.io) -->

The aim of this project is a standardized build environment to ease the development of SGX-ready applications along tools and scripts. Note, the SDK aims to help with building and testing the `manifest.template` as well as debugging the enclave. Once the manifest is in place, you may want a self-contained container of your application. Please read [here](https://github.com/enclaive/docker-gramineOS).

<p align="right">(<a href="#top">back to top</a>)</p>

### Why

Application enclavation is a fragile and delicate task. Specifically the debugging of the manifest file is an iterative and time-consuming process. Common pitfuls are the wrong linking of (dynamic) libraries, folders and files. To speed of the process the gramineSDK advocates a blueprint of how to strucutre and enclave applications. In addition, the SDK comes with a bunch of command line tools to speed the debugging and enclavation.

<!--
### Built With

This section should list any major frameworks/libraries used to bootstrap your project. Leave any add-ons/plugins for the acknowledgements section. Here are a few examples.

* [Next.js](https://nextjs.org/)


<p align="right">(<a href="#top">back to top</a>)</p>

-->

<!-- GETTING STARTED -->
## Getting Started

This is an example of how you may give instructions on setting up your project locally.
To get a local copy up and running follow these simple example steps.

### Prerequisites

An SGX-ready computing environment. Read [more].

Install the docker engine
```
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

Run container
```
docker run -it \
  --device=/dev/sgx_enclave \
  -v $(pwd)/manifest:/manifest \
  -v /var/run/aesmd/aesm.socket:/var/run/aesmd/aesm.socket \ 
  ubuntu20.04-gramine-sdk
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
<p align="right">(<a href="#top">back to top</a>)</p>



<!-- USAGE EXAMPLES -->
## Usage

### SDK folder structure
Once you have build the container you have the following structure within the myGramineSDK container
```
-/                              
--/manifest                     # place the manifest here (shared volume)
--/entrypoint                   # place the build here
--/scripts                      # a bunch of helpful scripts, incl. manifest, launch & build
--/sgx-signer-key/enclaive.pem  # key to sign the enclave ($SGX_SIGNER_KEY)
--/templates                    # copy manifest template to /manifest/myApp.manifest.template
```
Remark: Shared volumes may be tricky to use when host and container have varying permissions. See how to avoid the continous change of file permissions with a permanent [volume](https://docs.docker.com/storage/volumes/).

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
cp gramine-sdk/templates/helloworld.manifest.template .
```
Configure and sign the enclave 
```
# SDK
manifest helloworld

# command manifest internally calls  

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

# command start internally calls
gramine-sgx /manifest/helloworld      // requires helloworld.manifest.sgx helloworld.sig helloworld.token
```

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- ROADMAP -->
## Roadmap

- [x] Add README
- [ ] Add more templates
- [ ] Add more examples
- [ ] Add How to debug section
- [ ] New features
    - [ ] Secret key provisioning
    - [ ] Remote attestation

See the [open issues](https://github.com/othneildrew/Best-README-Template/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**. If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

Sebastian Gajek - [@sebgaj](https://twitter.com/sebgaj) - sebastianl@enclaive.io

Web Site: [https://enclaive.io](https://enclaive.io)

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