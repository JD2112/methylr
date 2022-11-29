![image](artworks/logo-final.png)
[![Docker Image CI](https://github.com/JD2112/methylr-devel/actions/workflows/docker-image.yml/badge.svg)](https://github.com/JD2112/methylr-devel/actions/workflows/docker-image.yml)
[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/JD2112/methylr/main?labpath=docs)

# **methylr: a single shiny solution from sequencer data to pathway analysis**

- [Description](#description)
- [Diagram](#diagram)
- [Quick start](#quick-starte)
    - [test data](#test-data)
    - [local run](#local-use)
        - [requirements](#computational-requirements/compatibility)
        - [run command](#run-the-app)
- [Step-by-step guide](#step-by-step-guide)
- [Workflow summaries](#workflow-summaries)
    - [User input data preparation](#prepare-your-input-data-for-methylation-analysis)
    - [input dataset](#input-test-dataset)
    - [component tools](#component-tools)
- [Additional notes](#additional-notes)
- [HELP/FAQ/Troubleshooting](#helpfaqtroubleshooting)
- [License(s)](#licenses)
- [Acknowledgement](#acknowledgement)
- [Citation](#citation)
- [Credits](#credits)

## Description
For non-commercial Academic and Research purpose only! \
Here we introduce *methylR*, a complete pipeline for the analysis of both 450K and EPIC Illumina arrays which not only offers data visualization and normalization but also provide additional features such as the annotation of the genomic features resulting from the analysis, pairwise comparisons of DMCs with different graphical representation plus functional and pathway enrichment as downstream analysis, all packed in a minimal, elegant and intuitive graphical user interface which brings the analysis of array DNA methylation data.


## Diagram

<img  width="300" height="400" src = "artworks/Flowchart.png">

## Quick start

### Test data
1. All required test data except DNA methylation raw files, can be found [here](https://github.com/JD2112/methylr/tree/main/data) \
    i. **testDataFile1** - differentially methylated data file, can be used for gene features, Volcano plot, chromosome map, gene ontology and pathway enrichment analysis modules. \
    ii. **testDataFile2** - normalized beta value data table, can be used for MDS, PCA plots. PCA plot requires additional group data information, 'groupData'. \
    iii. **heatmapMatrix** - heatmap matrix test data file added in the testdata directory.

2. DNA methylation test data can be found [here](https://sourceforge.net/projects/methylr/files/testData.zip)

### Local use:
We provide Docker container for local use. 

### Computational requirements/compatibility (AMD64 only)
- **LinuxOS** - (AMD64)
    - *Ubuntu 20.04LTS* 
    - *Docker* (version 20.10.18)
    - *web-browser*: *Firefox* (version 105)
- **MacOS** - (AMD64)
    - *Monterey (version 12.5.1)* 
    - *Docker* (version 20.10.17)
    - *Docker Desktop* (version 4.12.0)
    - *web-browsers*: 
        - *Google Chrome* (version 106), 
        - *Firefox* (version 106), 
        - *Apple Safari* (version 15.6.1)
- **WindowsOS** - (AMD64)
    - *Windows 10* (version 21H2)
    - *Docker* (version 20.10.20)
    - *Docker Desktop* (version 4.13.0)
    - *WSL2* - (**Ubuntu 20.04LTS**)
    - web-browsers: 
        - Firefox (version 106), 
        - Google Chrome (version 107), 
        - Microsoft Edge (version 106).

### Run the app
#### Step:1 - from terminal
```
# with docker container
docker run --rm -p 3838:3838 jd21/methylr:latest

# with singularity container
singularity run docker://jd21/methylr:latest
```

#### Step:2 - web-browser
Open the web-browser (check above for your OS), and type:
```
https://localhost:3838
```
*NOTE*: The follwing command can be run directly from Windows *PowerShell* or *CMD*, Ubuntu *terminal*, MacOS *terminal* or the docker image can run using the **Docker Desktop** as well. If you run using *terminal*, open the web-browser and type *localhost:3838* on the address bar. It will take few moments to load the entire app. Using the *Docker Desktop*, open the web-browser and type *localhost:3838* and wait till it loads the app. Please refresh the web-browser, if not loading (wait few minutes before refreshing the web-browser). If you want to use the **Docker Desktop** to run the app, please follow the instructions on the [manual](https://methylr.netlify.app/dockercontainer.html)


## Step-by-step guide
Check the [manual for more details](https://methylr.netlify.app/intro.html). You can also find a complete PDF manual [here](MethylR-manual%20—%20DNA%20Methylation%20Data%20Analysis.pdf)

## Workflow summaries

### Prepare your input data for methylation analysis

*MethylR* module *mythylysis* requires a zipped file as the input dataset that contains Illumina IDAT files and a Sample_sheet as CSV format (See details in the [manual](https://methylr.netlify.app/methylysis.html)). To ease the task for the user, we provided a bash script (['createInputZip.sh'](createInputZip.sh)) to make the input zip file with IDAT and sample_sheet files (See details in the [manual](https://methylr.netlify.app/inputzip.html)). 

### Input test dataset

A test dataset from a previously published result ([GSE207426](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE207426)) with RAW IDAT files for Illumina EPIC array can be found at [https://sourceforge.net/projects/methylr/](https://sourceforge.net/projects/methylr/). The test  dataset contains three samples in each group and the samples collected from solid tissue (will not work for 'Cell type heterogeneity'). More about the dataset can be found on the *[Methylome analysis for prediction of long and short-term survival in glioblastoma patients from the Nordic trial](https://www.frontiersin.org/articles/10.3389/fgene.2022.934519/abstract)* (Lysiak, M et al; 2022)

### Component tools
1. **methylysis**: [ChAMP](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3904520/); [minfi](https://academic.oup.com/bioinformatics/article/30/10/1363/267584?login=true)
2. **multi-D analysis**: [MDS](https://rdrr.io/bioc/minfi/man/mdsPlot.html); [PCA](https://rdrr.io/cran/FactoMineR/)
3. **gene feature analysis**: [plotly](https://plotly.com/r/); piechart
4. **heatmap analysis**: [heatmap.2](https://cran.r-project.org/web/packages/gplots/gplots.pdf); [d3heatmap](https://github.com/talgalili/d3heatmap)
5. **volcano plot**: [plotly](https://plotly.com/r/)
6. **chromosome map**: [chromPlot](https://bioconductor.org/packages/release/bioc/html/chromPlot.html)
7. **gene ontology**: [clusterProfiler](https://bioconductor.org/packages/release/bioc/html/clusterProfiler.html)
8. **pathway analysis**: [clusterProfiler](https://bioconductor.org/packages/release/bioc/html/clusterProfiler.html)
9. **venn analysis**: [Vennerable](https://github.com/js229/Vennerable); [intervene](https://intervene.shinyapps.io/intervene/)
10. **upset analysis**: [UpSetR](https://cran.r-project.org/web/packages/UpSetR/UpSetR.pdf); [intervene](https://intervene.shinyapps.io/intervene/)

## Additional notes
We provided an additional *python* script, *ChAMP2bed.py* for advanced users who want to visualize their DNA methylation results (from *ChAMP* workflow result) with additional annotation in [Integrative Genomics Viewer (IGV)](https://software.broadinstitute.org/software/igv/). Please check the [manual](https://methylr.netlify.app/bedscript.html) for more details.

## HELP/FAQ/Troubleshooting
Please check [the manual](https://methylr.netlify.app/intro.html) for details. 

For additional problems, check the [google group](https://groups.google.com/g/methylr) or contact the developer(mailto:methylr@googlegroups.com).

Please create [issues on github](https://github.com/JD2112/methylr-full/issues)

## License(s)
[GNU-3 public license - click to read details](https://www.gnu.org/licenses/gpl-3.0.en.html)

## Acknowledgement
We would like to acknowledge the **Core Facility, Faculty of Medicine and Health Sciences, Linköping University, Linköping, Sweden** and **Clinical Genomics Linköping, Science for Life Laboratory, Sweden** for their support.  

## Citation

We have submitted the manuscript to the journal and update once it published.

## Credits
Massimiliano Volpe, Jyotirmoy Das
