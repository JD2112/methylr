![image](artworks/logo-final.png)
[![Docker Image CI](https://github.com/JD2112/MethylationAnalysis/actions/workflows/docker-image.yml/badge.svg)](https://github.com/JD2112/MethylationAnalysis/actions/workflows/docker-image.yml)[![Docker Image CI](https://github.com/JD2112/MethylationAnalysis/actions/workflows/docker-image.yml/badge.svg)](https://github.com/JD2112/MethylationAnalysis/actions/workflows/docker-image.yml)


**methylr: a single shiny solution from sequencer data to pathway analysis**

## How to use
### Option 1: 
Go to the webserver and run the complete tool for different analysis - [methylr.it.liu.se](https://methylr.it.liu.se)


### Option 2:
1. singularity using the docker container
```
singularity run docker://jd21/methylr:latest
```

###### Notes on multi-OS architecture
Currently we have docker container for both amd64 and arm64 architecture to use in Linux, Mac OS.
1. amd64
2. arm64