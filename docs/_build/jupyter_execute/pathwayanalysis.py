#!/usr/bin/env python
# coding: utf-8

# # Pathway enrichment analysis
# 
# ## How to use
# 
# ### Data upload & Parameters setup
# #### Data upload
# User can upload the direct output result from the methylysis run.
# 
# #### Parameters setup
# 
# 1. *Choose pathway database*: Please select pathway database for the analysis from the drop-down list
#     - ReactomeDB;
#     - KEGGdb;
#     - Wikipathways
#     By default, the tool will use the ReactomeDB analysis.
# 
# 2. *Choose number of pathways*: Please select number of pathways for graphical display. The default is Top 20 pathways. The Top 20 enriched pathways is selected based on the adjusted P-values.
# 
# 3. *Choose pathway database*: user can choose to use different pathway database, namely ReactomeDB, KEGG or wikipathways.
# 
# 4. *Select p-value adjustment method*: The default method for adjustment of P-value is the Benjamini-Hochberg (BH) correction method. User can choose different method using the drop-down list:
#     - Benjamini-Hochberg (BH)
#     - Benjamini-Yeketuli (BY)
#     - Bonferroni
#     - Holm
#     - Hommel
#     - Hochberg
#     - FDR
#     - none
# 
# 5. *Choose the adjusted P-value*: The default value for BH-correction is set to 0.05. User can set their own cut-off values.
# 
# 6. *Choose pathway analysis type*: The pathway analysis type can be chosen from the drop-down list -
#     - Over representation analysis (ORA) 
#     - Gene set enrichment analysis (GSEA).
# 
# ## Analysis result
# 1. *Pathway enrichment plot*: after "Run Analysis", the plot will be generated as soon as computation has been done. Depends on the size of data, it might take some more time. At present the plot will be generated as a dot plot which is also a product of plotly, hence dynamic and have similar functionalities with mouse pointing. At present, with the mouse hover over, each dot will show the pathway name, count of genes from the input list for that particular pathway, the corrected p-value and gene ratio. The color scale bar shows in the legend. User can download the figure as PNG as described above and the dynamic figure as a html file.
# ![pathway enrichment](images/Pathway-Enrichment.png)
# 2. *Pathway enrichment table*: with the same input file and parameter setup, user can also get the result as an excel file (current page as well as full table).
# ![pathway enrichment table](images/PathEnrichTable.png)
# 
# ## R packages used
# 1. clusterProfiler
# 2. bitr
