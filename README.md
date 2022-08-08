![image](artworks/logo-final.png)
[![Docker Image CI](https://github.com/JD2112/MethylationAnalysis/actions/workflows/docker-image.yml/badge.svg)](https://github.com/JD2112/MethylationAnalysis/actions/workflows/docker-image.yml)[![Docker Image CI](https://github.com/JD2112/MethylationAnalysis/actions/workflows/docker-image.yml/badge.svg)](https://github.com/JD2112/MethylationAnalysis/actions/workflows/docker-image.yml)

# **methylr: a single shiny solution from sequencer data to pathway analysis**

- [Description](#description)
- [Diagram](#diagram)
- [Quick start](#quick-starte)
    - [test data](#test-data)
    - [web server](#web-server)
    - [local run](#local-use)
        - [requirements](#computational-requirements)
        - [run command](#run-from-terminal)


## Description
For non-commercial Academic and Research purpose only!
Here we introduce methylR, a complete pipeline for the analysis of both 450K and EPIC Illumi-na arrays which not only offers data visualization and normalization but also provide additional features such as the annotation of the genomic features resulting from the analysis, pairwise comparisons of DMCs with different graphical representation plus functional and pathway enrichment as downstream analysis, all packed in a minimal, elegant and intuitive graphical user interface which brings the analysis of array DNA methylation data.

$$\textcolor{red}{\text{NOTE: methylR has a signed docker container with 2048-bit RSA encryption. User requires the key to run the container locally. Please contact the developer.}}$$  

## Diagram

## Test data
1. All required test data except DNA methylation raw files, can be found [here](https://github.com/JD2112/methylr/tree/main/data)
2. DNA methylation test data can be found [here](https://sourceforge.net/projects/methylr/files/testData.zip)

## Quick start
### Web-server: 
Go to the webserver and run the complete tool for different analysis - [methylr.research.liu.se](https://methylr.research.liu.se)


### Local use:
### Computational requirements
- MacOS - AMD64, ARM64 (tested on Monterey 12.5)
- Linux - AMD64 (tested on Ubuntu 20.04)
- Windows (not tested)
- [Singularity](https://singularity-tutorial.github.io/01-installation/) (version >=3.7.1)
- [Docker](https://docs.docker.com/get-docker/) (latest only)

### Run from terminal
```
singularity run docker://jd21/methylr:latest
```
