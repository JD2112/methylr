#!/usr/bin/env python
# coding: utf-8

# # Gene Ontology (GO) enrichment analysis
# Gene Ontology is a very well-known method for accessing the functions of the gene identified through methylation analysis or expression analysis.
# Here in this pipeline, we used ontology analysis using the clusterProfiler package (latest version) {cite:p}`yu2012clusterprofiler`, {cite:p}`wu2021clusterprofiler`.
# 
# ## How to use
# ### Data upload & Parameters setup
# 
# #### Parameters setup
# 1. *Choose GO analysis type*: user can choose to do the analysis whether over-representation analysis or the gene-set enrichment analysis (GSEA).
# 2. *Select the adjusted p-value*: user can also choose the adjusted p-value for the analysis. Default is set to 0.05.
# 3. *Select the adjusted q-value*: q-value or the FDR can also be adjusted as per user's requirement. Default is 0.05.
# 4. *Select number of ontology classes*: to see the number of ontologies on the graph, user can setup different number. Default is 20.
# 5. *Select P-value adjustment method* As per clusterProfiler, we set different p-value adjustment methods, Benjamini-Hochberg, Benjamini-Yeketuli, Bonferroni, Holm, Hommel, Hochberg, FDR or none. Default is Benjamini-Hochberg.
# 6. *Select ontology class*: As defined in GO classification, we included all three ontology classes which user can select to show the plot.
# 
# #### Data upload
# At present, user can upload the DMC data produced by the methylysis pipeline directly. The input file should be in a text (tab-delimited) format.
# 
# ## Analysis result
# 1. On the right tab, the analysis result the plot will be generated as soon as computation finished. The plot is generated with plotly and it will be dynamic in nature as before. User can download the plot as PNG format, zoom in/out or do other stuffs as per plotly figures. The dynamic figure can also be downloaded as a html file.
# 
# ### Biological processes
# ![GO-BP](images/GO-BP.png)
# 
# ### Cellular component
# ![GO-CC](images/GO-CC.png)
# 
# ### Molecular function
# ![GO-MF](images/GO-MF.png)
# 
# 2. On the second right tab, user will get the result as a table format. It might takes some time to compute result and generates the table. User can download the result as an Excel file from the current page or the entire result.
# 
# 
# ## R packages used
# 1. bitr
# 2. clusterProfiler
