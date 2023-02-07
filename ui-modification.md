
## Dashboard
Please NOTE - ChAMP and Minfi are two different algorithms designed and developed by Yuan Tian et al and Kasper D. Hansen & Jean-Phillipe Fortin [Link](https://bioconductor.org/packages/release/bioc/vignettes/minfi/inst/doc/minfi.html), respectively to perform the DNA Methylation analysis from Illumina 450K or EPIC HumanMethylation Array. We here added both of them (with some modifications) and using only one pipeline is enough to get the analysis result.

## ChAMP analysis
1. At present, methylR can handle the Illumina HumanMethylation Array (450K and EPIC) signal intensity data (.idat) files. PLEASE NOTE Differential Methylation Analysis can only be done between two sample groups. Multiple groups (more than two) are not allowed. If used, may return unexpected results.
2. Please create a directory with all IDAT files for the analysis and a sample sheet in CSV format. Check the manual how to do it.
3. After the parameters setup, upload the data directory (zip file, as mentioned in the manual), please wait till the process finish ('Upload complete'). It might take few minutes depend on the size of the data. The analysis will start when the upload finish.
4. PLEASE NOTE, the normalized table can only show the first 1000 rows (can be downloaded as MS Excel file) and the whole data table will be downloaded as text file from the 'Download Results' tab.
5. The same format is also applied to the Differentially Methylated CpG (DMC) list, if there is significant a list. The DMC table will show top 1000 rows. For better viewing of the result, we colored *blue* for hypomethylated CpGs and *red* for hypermethylated CpGs. 
6. PLEASE NOTE, on the DMC table, for each gene, a link to the NCBI, GeneCards and Wikigenes provided. If you click on the links, it will direct to the above databases on a new tab.
7. In addtion, we provided a small 'question mark' or 'tip' for each parameter. Please check those (and the manual, if required), if you are running methylR for the first time.
8. If you are facing any issue with the pipeline, please contact us via support or google-groups or email.

## Minfi analysis

1. In the current version, the methylR can handle the Illumina HumanMethylation Array (450K and EPIC) signal intensity data (.idat) files. PLEASE NOTE Differential Methylation Analysis can only be done between two sample groups. Multiple groups (more than two) are not allowed. If used, may return unexpected results.
2. Please create a directory with all IDAT files for the analysis and a sample sheet in CSV format. Check the manual how to do it.
3. After the parameters setup, upload the data directory (zip file, as mentioned in the manual), please wait till the process finish ('Upload complete'). It might take few minutes depend on the size of the data. The analysis will start when the upload finish.
4. The 'QC result' tab in the viewing panel will show the result of 'plotQC' function used in 'Minfi' package. However, the user will get the detail QC analysis result as a PDF from the 'Download results' tab.
5. The normalized table can only show the first 1000 rows (can be downloaded as MS Excel file) and the whole data table will be downloaded as text file from the 'Download Results' tab. For Minfi analysis, the tab panel shows the normalized file only for beta values. The normalized file with M-value is avaible from the 'Download results'.
6. For Minfi, the DMC file is annotated with as per user's choice of genome annotation database and will get the complete result without filtered with the BH-correction. In the viewing tab, user can see the top 1000 CpGs with the annotation. However, we modified the viewing result with some specific columns for better viewing. All annotation and full table is available in the 'Download results' section. For better viewing of the result, we colored *blue* for hypomethylated CpGs and *red* for hypermethylated CpGs.
7. In addtion, we provided a small 'question mark' or 'tip' for each parameter. Please check those (and the manual, if required), if you are running methylR for the first time.
8. If you are facing any issue with the pipeline, please contact us via support or google-groups or email.