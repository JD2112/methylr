#!/usr/bin/env python
# coding: utf-8

# # Multi-D Analysis
# Multiple dimensional analysis includes two type of analysis -
# 1. MDS: Multidimensional Scaling
# 2. PCA: Prinicipal Component Analysis
# 
# Multidimensional scaling is a visual representation of distances or dissimilarities between set of objects ("Objects" can be anything). MDS finds set of vectors in p-dimensional space such that the matrix of Euclidean distance among them corresponds as closely as possible to some function of the input matrix. The input to multidimensional scaling is a distance matrix. To get some more details on how to use MDS in biological data, read {cite:p}`mugavin2008multidimensional`, {cite:p}`lacher1987interpretation`, {cite:p}`lacher1988comparison`
# Principal Component Analysis (PCA) is the original vectors in n-dimensional space and the data are projected onto the directions in the data with the most variance.
# 
# ## How to use
# For both analysis, user need to provide a TEXT (tab-delimited) file with numeric values, e.g. the output normalized table from methylysis, i.e. the normalized \beta value table. However the user can use similar tables for the analysis.
# 
# ### Data Upload
# 1. Select the text file (tab-delimited file) and upload it.
# 2. User can choose the option to use number of variables from the uploaded data file.
# 3. On the right tab, under "MDS plot", user will find the button to "Run MDS Analysis"
# 4. Next tab is designed for the PCA plot and here user can have an input of text file to highlight the group.
# *NOTE* Please note that, the single column with header "group" should be supplied in this file. Match the column names of the variable data file with the group.
# Example:
# If in the variable data file, the column names are -
#     sampleA1 sampleA2 sampleA3  sampleB1    sampleB2    sampleB3
# the group text file should be like this -
# group
# A
# A
# A
# B
# B
# B
# For more, please see the demo data files.
# 
# ## Analysis result
# 
# ### MDS plot
# 1. After the click on "Run MDS Analysis", the program will take some time to generate the plot and will appear as soon the run finishes. The zoom bar can be used to zoom in/out the plot.
# 2. The generated figure can be downloaded in different format, vector graphics support - PDF and SVG or PNG and TIFF. User can download all different options for the same figure.
# ![mdsplot](images/mdsPlot.png)
# 
# ### PCA plot
# 1. The plot will be generated after computing the PCA, "Run PCA" with the group colors and legend.
# 2. The generated plot is dynamic and positional details with the group name can be seen with mouse hovering.
# 3. The plot is generated using the plotly application, it can zoom in/out, save figure as PNG format, and do all other available functionality for plotly figures.
# 4. User can also download the dynamic figure as html file.
# ![pca plot](images/PCA.png)
# 
# 
# ## R packages used
# 1. minfi
# 2. FactoMineR
# 3. factoExtra
# 4. explor
