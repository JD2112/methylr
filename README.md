![image](artworks/logo-final.png)
[![Docker Image CI](https://github.com/JD2112/MethylationAnalysis/actions/workflows/docker-image.yml/badge.svg)](https://github.com/JD2112/MethylationAnalysis/actions/workflows/docker-image.yml)[![Docker Image CI](https://github.com/JD2112/MethylationAnalysis/actions/workflows/docker-image.yml/badge.svg)](https://github.com/JD2112/MethylationAnalysis/actions/workflows/docker-image.yml)


**methylr: a single shiny solution from sequencer data to pathway analysis**

## How to use
### Option 1: 
Go to the webserver and run the complete tool for different analysis - [methylr.it.liu.se](https://methylr.it.liu.se)


### Option 2:
1. singularity using the docker container
#### Installing singularity
Singularity can be installed from the singularity source as mentioned in the [documentation](https://singularity-tutorial.github.io/01-installation/) or [here](https://sylabs.io/guides/3.7/user-guide/quick_start.html)
```
export VERSION=3.7.0 && # adjust this as necessary \
    wget https://github.com/hpcng/singularity/releases/download/v${VERSION}/singularity-${VERSION}.tar.gz && \
    tar -xzf singularity-${VERSION}.tar.gz && \
    cd singularity

./mconfig && \
    make -C builddir && \
    sudo make -C builddir install
```
#### Get Docker
Docker should be installed on the computer. Please see the details [here](https://docs.docker.com/get-docker/)
```
## For Linux only
wget https://desktop.docker.com/linux/main/amd64/docker-desktop-4.8.0-amd64.deb?utm_source=docker&utm_medium=webreferral&utm_campaign=docs-driven-download-linux-amd64
sudo dpkg -i docker-desktop-4.8.0-amd64.deb
docker version
```
#### Run the methylR from your local computer
```
singularity run docker://jd21/methylr:latest
```

###### Notes on multi-OS architecture
Currently we have docker container for both amd64 and arm64 architecture to use in Linux, Mac OS.
1. amd64
2. arm64