#!/usr/bin/env python
# coding: utf-8

# ## How to convert .Rmd to .ipynb
# 1. Require an R package, rmd2jupyter
# ```
# devtools::install_github("mkearney/rmd2jupyter")
# library(rmd2jupyter)
# ```
# 2. Prepare the .Rmd file
# 3. Convert the file
# ```
# rmd2jupyter("sample_file.Rmd")
# ```
# 
# 
# ## Notes
# 
# 
# [1] See Table 1
# 
# [2] adding other parameters to the plot to make it more useful and
# understandable
# 
# [3] In this, the value is multiplied by 100
# 
# [4] For strings parallel to the axis, adj =0 means left or bottom
# alignment and adj = 1 means right or top alignment
# 
# [5] [R plot **pch**
# symbols](http://www.sthda.com/english/wiki/r-plot-pch-symbols-the-different-point-shapes-available-in-r)
# 
# [6] could not find the required symbols in LaTeX
# 
# [7] convert data into a local data frame,
# 
# [8] if library(dplyr) has been called and filter with grepl
# 
# [9] **Note:** *par* function, par sets or adjusts plotting parameters,
# and *mar* is a numeric vector of length 4, mar(bottom, left, top, right)
# 
# [10] mgp is a numeric vector of length 3, sets the axis label locations
# relative to the edge of the inner plot window. The first value
# represents the location of the labels, the second - the tick-maeks
# labels, and third - the tick marks. The default is c(3,1,0).
# 
# [11] is also a numeric value indicating the orientation of the tickmarks
# labels and any other text added to the plot after the initialization. 0
# - always parallel to the axis (default), 1 - always horizontal, 2 -
# always perpendiclar to the axis, and 3 - always vertical
# 
# [12] ifelse is used as if ... else statement. ifelse(text expression, x,
# y)
# 
# [13] Abbreviations used$:$ Con$:$Control and Exp$:$ Exposed
# 
# [14] TB patient, household contacts and controls data from Linköping,
# Sweden
# 
# [15] this can only be used if the sample group contains more than two
# groups. In this case, we used the patient sample data as "Exposed"
# because one data sample group cannot be analyzed. We have only two
# sample groups, Exposed vs NonExposed
# 
# [16] [HumanMethylation450 manifest
# file](https://emea.support.illumina.com/downloads/infinium_humanmethylation450_product_files.html)
# 
# [17] [Links to source
# package](https://github.com/kevinblighe/EnhancedVolcano)
# 
# [18] [Links to github package](https://wencke.github.io/)
# 
# [19] A. A list of 4131 DMGs (BH adjusted *p value* $<$ 0.05) are used
# from the CD3 cell types to analyze the functional enrichment.  
# B. For HLA-DR cell types, a total of 9266 DMGs (BH adjusted *p value*
# $<$ 0.05) are taken.  
# C. The functional enrichment analysis of PBMC cell types contain 537
# DMGs (BH adjusted *p value* $<$ 0.2)
# 
# [20] [Links to Panther database](http://www.pantherdb.org/)
# 
# [21] [Links to reactome](https://reactome.org/)
# 
# [22] [Links to database](http://www.webgestalt.org/)
# 
# [23] Kyoto Encyclopedia of Gene and Genome
# 
# [24] Protein ANalysis THrough Evolutionary Relationships
# 
# [25] WEB-based GEne SeT AnaLysis Toolkit[Link to
# database](http://www.webgestalt.org/)
# 
# [26] For the dotplot, I used *ggpubr* package in R
