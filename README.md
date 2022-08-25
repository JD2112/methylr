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
- [Step-by-step guide](#step-by-step-guide)
- [Workflow summaries](#workflow-summaries)
    - [input dataset](#input-dataset)
    - [component tools](#component-tools)
    - [third-party tools/dependencies](#third-party-toolsdenpendencies)
- [Additional notes](#additional-notes)
- [HELP/FAQ/Troubleshooting](#helpfaqtroubleshooting)
- [License(s)](#licenses)
- [Acknowledgement](#acknowledgement)
- [Citation](#citation)
- [Credits](#credits)

## Description
For non-commercial Academic and Research purpose only! \
Here we introduce methylR, a complete pipeline for the analysis of both 450K and EPIC Illumina arrays which not only offers data visualization and normalization but also provide additional features such as the annotation of the genomic features resulting from the analysis, pairwise comparisons of DMCs with different graphical representation plus functional and pathway enrichment as downstream analysis, all packed in a minimal, elegant and intuitive graphical user interface which brings the analysis of array DNA methylation data.


## Diagram

<img  width="300" height="400" src = "artworks/Flowchart.png">

## Test data
1. All required test data except DNA methylation raw files, can be found [here](https://github.com/JD2112/methylr/tree/main/data) \
    i. **testDataFile1** - differentially methylated data file, can be used for gene features, Volcano plot, chromosome map, gene ontology and pathway enrichment analysis modules. \
    ii. **testDataFile2** - normalized beta value data table, can be used for MDS, PCA plots. PCA plot requires additional group data information, 'groupData'. \
    iii. **heatmapMatrix** - heatmap matrix test data file added in the testdata directory.

2. DNA methylation test data can be found [here](https://sourceforge.net/projects/methylr/files/testData.zip)

## Quick start
### Web-server: 
Go to the webserver and run the complete tool for different analysis - [methylr.research.liu.se](https://methylr.research.liu.se)

### Local use:
We provide a lite version for local use with Docker container. 

### Computational requirements
- Linux - AMD64 (tested on Ubuntu 20.04)
- Windows (not tested)
- [Singularity](https://singularity-tutorial.github.io/01-installation/) (version >=3.7.1)
- [Docker](https://docs.docker.com/get-docker/) (latest only)


### Run from terminal
```
singularity run docker://jd21/methylr:latest
```

## Step-by-step guide
Check the [manual for more details](https://methylr.netlify.app/intro.html)

## Workflow summaries

### Prepare your input data for methylation analysis

MethylR module mythylysis requires a zipped file as the input dataset that contains Illumina IDAT files and a Sample_sheet as CSV format (See details in the [manual](https://methylr.netlify.app/methylysis.html)). To ease the task for the user, we provided a bash script (['createInputZip.sh'](createInputZip.sh)) to make the input zip file with IDAT and sample_sheet files (See details in the [manual](https://methylr.netlify.app/inputzip.html)). 

### Input test dataset

A test dataset from a previously published result ([GSE207426](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE207426)) with RAW IDAT files for Illumina EPIC array can be found at [https://sourceforge.net/projects/methylr/](https://sourceforge.net/projects/methylr/). The test  dataset contains three samples in each group and the samples collected from solid tissue (will not work for 'Cell type heterogeneity'). More about the dataset can be found on the *[Methylome analysis for prediction of long and short-term survival in glioblastoma patients from the Nordic trial](https://www.frontiersin.org/articles/10.3389/fgene.2022.934519/abstract)* (Lysiak, M et al; 2022)

### Component tools
1. methylysis: [ChAMP](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3904520/); [minfi](https://academic.oup.com/bioinformatics/article/30/10/1363/267584?login=true)
2. multi-D analysis: [MDS](https://rdrr.io/bioc/minfi/man/mdsPlot.html); [PCA](https://rdrr.io/cran/FactoMineR/)
3. gene feature analysis: piechart
4. heatmap analysis: [heatmap.2](https://cran.r-project.org/web/packages/gplots/gplots.pdf); [d3heatmap](https://github.com/talgalili/d3heatmap)
5. volcano plot: [plotly](https://plotly.com/r/)
6. chromosome map: [chromPlot](https://bioconductor.org/packages/release/bioc/html/chromPlot.html)
7. gene ontology: [clusterProfiler](https://bioconductor.org/packages/release/bioc/html/clusterProfiler.html)
8. pathway analysis: [clusterProfiler](https://bioconductor.org/packages/release/bioc/html/clusterProfiler.html)
9. venn analysis: [Vennerable](https://github.com/js229/Vennerable)
10. upset analysis: [UpSetR](https://cran.r-project.org/web/packages/UpSetR/UpSetR.pdf)

## HELP/FAQ/Troubleshooting
Please check [the manual](https://methylr.netlify.app/intro.html) for details. If you have additional problems, check the [google group](https://groups.google.com/g/methylr) or contact the developer(methylr@googlegroups.com). 

## License(s)
[GNU-3 public license](https://www.gnu.org/licenses/gpl-3.0.en.html)

## Acknowledgement
We are thankful to the Linköping University IT-division for providing the server support to release the package. We would also like to acknowledge the Core Facility, Faculty of Medicine and Health Sciences, Linköping University, Linköping, Sweden and Clinical Genomics Linköping, Science for Life Laboratory, Sweden for their support.  

## Citation

## Credits
Massimiliano Volpe, Jyotirmoy Das
