# Welcome to methylR: DNA Methylation Data Analysis Pipeline

DNA Methylation is one of the most studied epigenetic modifications in humans, playing a critical role in cellular response, development and differentiation {cite:p}`Das2019`. The transfer of a methyl group onto the C5 position of the cytosine to form 5-methylcytosine is considered as the DNA methylation or epigenetic mechanism in human or mammalian genome {cite:p}`moore2013dna`.   
Epigenetic research has its roots in plant science, which emerged in the early 20th century. In human medicine, cancer biology has driven the field forwards during the last two decades and in combination with modern, array-based techniques and nex-generation sequencing now provides the scientific community with an easily accessible tool to study epigenetics at a whole-genome level {cite:p}`das2021dna`. 
To find the methylated site or the CpG site, Illumina(R) uses DNA methylation array-based techonology. Till date three different array platforms are avaible from Illumina for human genome to identify the CpG site or specific DNA methylation location, namely 27K, 450K or 850K. A more detail history and timeline can be found here in this [article](https://www.frontiersin.org/articles/10.3389/fgene.2011.00074/full) by Harrison and Pari-McDermott (2011){cite:p}`harrison2011dna`. After performing the array, the major part is the analysis of the raw data generated from the machine. Numerous tools are available to analyze the data using different operating system, various computational languages. And all of these tools require extensive handling of computational resources. For the Biologist or those who have limited computational knowledge, it is extremely difficult to handle all these tools.

Here, in *methylR*, we presented a shiny-based web server approach to minimize the above-mentioned difficulties. MethylR has graphical user interface to support and understand the various options used in the DNA methylation analysis with an extensive manual/tutorial how to use it. The background computational power depends on the user's computer which can also be optimized. We successfully tested the pipeline on Mac and Linux based system. 

## How to Use
### Web server
*methylR* has a dedicated web server to run all modules. 
[methylr](https://methylr.it.liu.se)

Note: If you want to run with the test data. 

Please download the testdata from [here](https://github.com/JD2112/methylr)

### Local use
*methylR* is packed into docker container that is available online. Singularity can also be used to run the docker container directly from terminal. 
Please use the [github link](https://https://github.com/JD2112/methylr)

```{tableofcontents}
```
