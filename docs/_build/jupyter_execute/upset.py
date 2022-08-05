#!/usr/bin/env python
# coding: utf-8

# # UpSet Plots
# The following analysis and diagram is forked from ...
# 
# ## How to use
# 
# ### Data upload
# 1. *Upload*: Data can be uploaded as TEXT or CSV or Semicolon separated format. Please look into the example data file.
#     UpSet module takes three types of inputs.
# 
#     1. List type data:
#    List data is a correctly formatted csv/text file, with lists of names. Each column represents a set, and each row represents an element (names/gene/SNPs). Header names (first row) will be used as set names.
#     2. Binary type data:
#     In the binary input file each column represents a set, and each row represents an element. If a names is in the set then it is represented as a 1, else it is represented as a 0.
#     3. Combination/expression type data:
#     Combination/expression type data is the possible combinations of set intersections. For example;
# ```
# H3K4me2&H3K4me3=16321,H3K4me2&H3K4me3&H3K27me3=5756,H3K27me3=25174,H3K4me3&H3K27me3=15539,H3K4me3=32964,H3K4me2&H3K27me3=19039,H3K4me2=60299,H3K27ac&H3K4me2&H3K4me3&H3K27me3=7235,H3K27ac&H3K4me2&H3K4me3=17505,H3K27ac&H3K4me2=21347,H3K27ac&H3K4me2&H3K27me3=1698,H3K27ac&H3K4me3=8134,H3K27ac&H3K4me3&H3K27me3=295,H3K27ac&H3K27me3=7605,H3K27ac=42164
# ```
# 
# ### Parameters setup
# 2. *Settings*: Under settings, there are multiple options to display the plot -
#     
#     i. *select sets*: select the dataset from the input data.
#     
#     ii. *Number of intersections to show*: Please add the number to calculate the intersection.
#     
#     iii. *Order intersections by*: From the drop-down menu, please select the intersection order -  
#     - Frequency
#     - degree
#     iv. *Increaing/Decreasing*: Please select the order of the frequency/degree. 
# 
#     v. *Scale intersections*: Please select the scale intersection from the drop-down menu -
#     - Original,
#     - log10,
#     - log2
#     
#     vi. *scale sets*: Please select the scale intersection from the drop-down menu -
#     - Original,
#     - log10,
#     - log2    
#     
#     vii. *Plot width*: select the plot width from the slider.
#     
#     viii. *Plot height*: select the plot height from the slider.
#     
#     ix. *Bar matrix ratio*: select the bar matrix ratio from the slider.
#     
#     x. 
# 
# 3. *Font & Color*: multiple ooptions are included for font and colours -
#     
#     i. *Select color theme*: Colour theme can be chosen from the drop-down menu.
#     
#     ii. *Label font size*: Change the font size of the Label.
#     
#     iii. *Number font size*: Change the font size of the number.
# 
# ## R packages used
