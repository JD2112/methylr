#!/usr/bin/env python
# coding: utf-8

# # Volcano plot
# Volcano plot is a nice tool to visualize in a two-dimensional way for differentially methylated CpG site or differentially expressed genes using the statistical p-values as well as the fold change value. Like a volcano, the plot can show the significant or insignificant data in a scatter plot manner.
# Here with this tool, we used plotly output to visualize the volcano plot to see the CpG or gene name (if the data from the differential analysis) with their respective p-values (adjusted p-values) and the logFC (or mean methylation difference).
# ## How to use
# 
# ### Data upload & Parameters setup
# #### Data upload
# 1. User needs to upload a text (tab-delimited) file with adjusted p-values and logFC values. At present, user can use the DMCs data file directly generated from methylysis run.
# 2. To setup the adjusted p-value, user can change the cut-off. Default is setup to 0.05.
# 3. LogFC cut-off can also be changed as per user requirement.
# 4. After the file upload and setting up the cut-off for adjusted P-value and logFC, click the "Run Analysis" button.
# 
# 
# ## Analysis result
# 
# ### Volcano plot
# 1. The figure will generated as soon as the computation finishes. However, it might takes some more time depending on the size of the file. If user upload a file with 750K rows, it will take 2-3 minutes to generate the figure. It is noteworthy that this big data in volcano plot, may be unstable in the browser.
# 2. User can download the plot as figure (same as before) and the dynamic figure as a html file.
# ![volcano plot](images/Volcano1.png)
# 3. On the right tab, user can also see the volcano data table which is useful when they are using the full dataset from the methylysis result.
# 
# ### Volcano data
# One data table will be generated using the input data and will have a column marked with "significant & Fold Change", "Significant" or "insignificant" depends on the adjusted *p*-value and logFC cut-off.
# ![Volcano data table](images/Volcano2.png)
# 
# ## R packages used
# 1. plotly
