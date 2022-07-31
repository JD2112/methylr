# Author details
## Script name: app.R
## Purpose of the script: Using shiny to analyze DNA methylation array data and dwonstream analysis 
## Author(s): Jyotirmoy Das, Ph.D.
## Date Created: 2019-03-21
## Date Last Modified: 2022-04-17
## Copyright statement: GNU3 open license
## Contact information: jyotirmoy.das@liu.se
## Please cite: 
## @article{},
## Notes:  
## Please read the manual/tutorial file for the sample preparation of the analysis.

# libraries
suppressWarnings(suppressMessages(library(shinydashboard)))
suppressWarnings(suppressMessages(library(shinydashboardPlus)))
suppressWarnings(suppressMessages(library(d3heatmap)))
suppressWarnings(suppressMessages(library(plotly)))
suppressWarnings(suppressMessages(library(ggplot2)))
suppressWarnings(suppressMessages(library(gridExtra)))
suppressWarnings(suppressMessages(library(plyr)))
suppressWarnings(suppressMessages(library(UpSetR)))
suppressWarnings(suppressMessages(library(colourpicker)))
suppressWarnings(suppressMessages(library(corrplot)))
suppressWarnings(suppressMessages(library(Vennerable)))
suppressWarnings(suppressMessages(library(BBmisc)))
suppressWarnings(suppressMessages(library(readr)))
suppressWarnings(suppressMessages(library(shiny)))
suppressWarnings(suppressMessages(library(shinyFiles)))
suppressWarnings(suppressMessages(library(shinyjs)))
suppressWarnings(suppressMessages(library(stringdist)))
suppressWarnings(suppressMessages(library(RecordLinkage)))
suppressWarnings(suppressMessages(library(tidyr)))
suppressWarnings(suppressMessages(library(scales)))
suppressWarnings(suppressMessages(library(DT)))
suppressWarnings(suppressMessages(library(Cairo)))
suppressWarnings(suppressMessages(library(ggplot2)))
suppressWarnings(suppressMessages(library(data.table)))
suppressWarnings(suppressMessages(library(htmlwidgets)))
suppressWarnings(suppressMessages(library(webshot)))
suppressWarnings(suppressMessages(library(r2symbols)))
suppressWarnings(suppressMessages(library(gridExtra)))
suppressWarnings(suppressMessages(library(viridis)))
suppressWarnings(suppressMessages(library(chromoMap)))
suppressWarnings(suppressMessages(library(manhattanly)))
suppressWarnings(suppressMessages(library(plotrix)))
suppressWarnings(suppressMessages(library(BiocManager)))
suppressWarnings(suppressMessages(library(glue)))
suppressWarnings(suppressMessages(library(chromPlot)))
suppressWarnings(suppressMessages(library(GenomicFeatures)))
options(repos = BiocManager::repositories())
suppressWarnings(suppressMessages(require(AnnotationDbi)))
suppressWarnings(suppressMessages(require(Biobase)))
suppressWarnings(suppressMessages(require(BiocGenerics)))
suppressWarnings(suppressMessages(require(DO.db)))
suppressWarnings(suppressMessages(require(DOSE)))
suppressWarnings(suppressMessages(require(GO.db)))
suppressWarnings(suppressMessages(require(GOSemSim)))
suppressWarnings(suppressMessages(require(clusterProfiler)))
suppressWarnings(suppressMessages(require(org.Hs.eg.db)))
suppressWarnings(suppressMessages(require(dplyr)))
suppressWarnings(suppressMessages(require(ReactomePA)))
suppressWarnings(suppressMessages(library(ggforce)))
suppressMessages(suppressMessages(library(ggfortify)))
suppressMessages(suppressMessages(library(FactoMineR)))
suppressMessages(suppressMessages(library(factoextra)))
suppressMessages(suppressMessages(library(magrittr)))
suppressMessages(suppressMessages(library(dplyr)))
suppressMessages(suppressMessages(library(minfi)))
suppressMessages(suppressMessages(library(explor)))
suppressMessages(suppressMessages(library(qpdf)))
suppressMessages(suppressMessages(library(shinyWidgets)))
suppressMessages(suppressMessages(library(ggpubr)))
suppressMessages(suppressMessages(library(shinylogs)))


# Logged = FALSE
# my_username <- "methylr"
# my_password <- "methylr"
# my_username <- "admin"
# my_password <- "admin"

js <- '
$(document).keyup(function(event) {
  if ($("#password").is(":focus") && (event.keyCode == 13)) {
      $("#ok").click();
  }
});
'
modify_stop_propagation <- function(x) {
  x$children[[1]]$attribs$onclick = "event.stopPropagation()"
  x
}

# tags$script(HTML(
#   "Enable navigation prompt
#         window.onbeforeunload = function() {
#             return 'Your changes will be lost!';
#         };"
# )) 

# js <- HTML("
# var changes_done = false;

# Shiny.addCustomMessageHandler('changes_done', function(bool_ch) {
#   console.log('Are changes done?');
#   console.log(bool_ch);
#   changes_done = bool_ch;
# });

# function goodbye(e) {
#   if (changes_done === true) {
#     if(!e) e = window.event;

#     //e.cancelBubble is supported by IE - this will kill the bubbling process.
#     e.cancelBubble = true;

#     //This is displayed on the dialog
#     e.returnValue = 'Are you sure you want to leave without saving the changes?';

#     //e.stopPropagation works in Firefox.
#     if (e.stopPropagation) {
#       e.stopPropagation();
#       e.preventDefault();
#     }
#   }
# }

# window.onbeforeunload = goodbye;
# ")

sidebar <- dashboardSidebar(
  width = 200, collapsed = FALSE,
  sidebarMenu(
    menuItem("Dashboard", tabName = "main", icon=icon("database")),
    menuItem("Methylysis", tabName = "methylysis", icon = icon("compass")),
    modify_stop_propagation(
    menuItem("Feature analysis", startExpanded = TRUE, icon=icon(name="fa-solid fa-anchor", class= NULL, lib = "font-awesome"),
      menuSubItem("Multi-D Analysis", tabName = "multidim", icon = icon("calculator")),
      menuSubItem("Gene Features", tabName = "features", icon = icon("chart-pie")),
      menuSubItem("Pairwise Plot", tabName = "pairwise", icon = icon("th")),
      menuSubItem("Volcano Plot", tabName = "volcano", icon = icon("jedi")),
      menuSubItem("Chromosome Plot", tabName = "chromplot", icon = icon("dna")))
    ),
    modify_stop_propagation(
    menuItem("Association study", startExpanded = TRUE, icon=icon(name="fa-solid fa-anchor", class= NULL, lib = "font-awesome"),
      menuSubItem("GO analysis", tabName = "go", icon = icon("spinner")),
      menuSubItem("Pathway analysis", tabName = "pathway", icon = icon("battle-net")))
    ),
    modify_stop_propagation(
    menuItem("Set analysis", startExpanded = TRUE, icon=icon(name="fa-solid fa-anchor", class= NULL, lib = "font-awesome"),
      menuSubItem("Venn Analysis", tabName = "venn", icon = icon("venus-mars")),
      menuSubItem("UpSet Plot", tabName = "upset", icon = icon("chart-line")))
    ),
    menuItem("User Manual", tabName = "manual", icon = icon("file-pdf"))
  )
)

#========================================#
## Home
#========================================#
bodyHome <- tabItem(tabName = "main",
                    # fluidPage(
                    #   # Navigation prompt
                    #   tags$head(tags$script(HTML("
                    #     // Enable navigation prompt
                    #     window.onbeforeunload = function() {
                    #     return 'Your changes will be lost!';
                    #     };
                    #   ")
                    #   ))),
                    fluidRow(
                      box(
                        title = "Welcome to methylR: single solution from sequencer to publication", width = 12, status = "primary",
                        div(style = "font-size:16px; color:orange",
                            HTML("<b>For non-commercial Academic and Research purpose only!</b>")
                        ),
                        div(style = "font-size:16px; color:black",
                          HTML("Here we introduce methylR, a complete pipeline for the analysis of both 450K and EPIC Illumi-na arrays which not only offers data visualization and normalization but also provide additional features such as the annotation of the genomic features resulting from the analysis, pairwise comparisons of DMCs with different graphical representation plus functional and pathway enrichment as downstream analysis, all packed in a minimal, elegant and intuitive graphical user interface which brings the analysis of array DNA methylation data")
                        )),
                      fluidRow(
                        box(width = 12, status = "success",
                            title = "Publications related to MethylR",
                            div(style = "font-size:16px;",
                                tags$ol(tags$a(href = "https://www.tandfonline.com/doi/epub/10.1080/15592294.2019.1603963?needAccess=true", "1. Das J et al, Epigenetics. 2019 Jun;14(6):589-601.", target="_blank")),
                                tags$ol(tags$a(href = "https://www.tandfonline.com/doi/epub/10.1080/15592294.2021.1969499?needAccess=true", "2. Das J et al, Epigenetics. 2021 Sep 5:1-12.", target="_blank")),
                                tags$ol(tags$a(href = "https://www.nature.com/articles/s41598-021-98542-3.pdf", "3. Karlsson L et al, Sci Rep. 2021 Sep 30;11(1):19418.", target="_blank")),
                            ))
                      ),
                      fluidRow(
                        box(width = 12, status = "success",
                            title = "Other tools from Us",
                            div(style = "font-size:16px;",
                                tags$ol(tags$a(href = "https://jd2112.github.io/ImageProcessingMATLAB/", "1. Live cell image processing with MATLAB", target="_blank")),
                                tags$ol(tags$a(href = "https://jd2112.github.io/MA_analysis/", "2. PCA from different cytokines", target="_blank")),
                                tags$ol(tags$a(href = "https://jd2112.github.io/AlveolarCellTypeDeconvolution/", "3. Alveolar specific cell type deconvolution pipeline", target="_blank")),
                            ))
                      ),
                      fluidRow(
                        box(width = 12, status = "success",
                            HTML(
                              "<b>Disclaimer:</b> This program is free software: you can redistribute it and/or modify
                          it under the terms of the GNU General Public License as published by
                          the Free Software Foundation, either version 3 of the License, or
                          (at your option) any later version.

                          This program is distributed in the hope that it will be useful,
                          but WITHOUT ANY WARRANTY; without even the implied warranty of
                          MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
                          GNU General Public License for more details.

                          You should have received a copy of the GNU General Public License
                          along with this program.  If not, see"), tags$a(href="https://www.gnu.org/licenses/","www.gnu.org/licenses/.", target = "_blank"))
                      )

                    ))
#========================================#
## methylysis
#========================================#
bodyMethylysis <- tabItem(tabName = "methylysis",
                          h2("DNA methylation analysis"),
                          tags$style(
                            HTML(".tabbable > .nav > li[class=active] > a {text-decoration-color: green}")
                          ),

                          fluidRow(
                            box(
                              title= "Usage Instructions", width = 12, status = "primary",
                              #  h4("Usage instructions"),
                              div(style = "font-size:14px; color:black",
                                tags$ol(HTML("1. In the current version, the <b><i>methylR</i></b> can handle the Illumina array raw data files.")),
                                tags$ol(tags$a(href = "https://github.com/JD2112/methylr", "2. Please create a directory with all IDAT files for the analysis and a sample sheet in CSV format.", target = "_blank")),
                                tags$ol(HTML("3. Upload the directory as mentioned in the manual, please wait till the process finish. It might take few minutes depend on the size of the data.")),
                                tags$ol("4. Please note: the normalized table can only show the first 100 rows and the whole data table can be downloaded as text file (can be found at the bottom of the table)."),
                                tags$ol("5. The same format is also applied to the Differentially Methylated CpG (DMC) list, if there is significant a list."),
                                h5("R packages used"),
                                div(style = "font-size:14px; color: black",
                                tags$ol(tags$a(href = "https://bioconductor.org/packages/release/bioc/vignettes/ChAMP/inst/doc/ChAMP.html", "1. The Chip Analysis Methylation Pipeline (ChAMP)", target = "_blank")),
                                tags$ol(tags$a(href = "https://bioconductor.org/packages/release/bioc/vignettes/minfi/inst/doc/minfi.html", "2. Minfi package + Maksimovic et al (F1000, 2016)", target="_blank"))
                                ))
                            ),
                            box(
                              title = "Data Upload & Parameters Setup", width = 4, status = "warning",
                              #tabBox(
                                #id = "methylysistab", height = "100%", width = "100%",
                              tabsetPanel(id = "methylysisType",
                                tabPanel("Methylysis",
                                         selectInput("analysisType", 
                                         div(style = "font-size:20px; color: #008080; font-family: papyrus",
                                          HTML("<b>Choose analysis pipeline</b>")),
                                                     choices = list("ChAMP pipeline" = 1,
                                                                    "Minfi pipeline" = 2),
                                                     selected = NULL)),
                                tabPanel("ChAMP parameters",
                                #      id = "champ",
                                        value = "1",
                                         #h3("ChAMP pipeline parameters"),
                                         div(style = "font-size:20px; color: #133337; font-family: papyrus",
                                          HTML("<b>ChAMP pipeline parameters</b>")),
                                         selectInput("arrayType", h4("Choose type of Illumina array"),
                                                     choices = list(
                                                                    "Illumina HumanMethylation450K" = 2,
                                                                    "Illumina HumanMethylationEPIC" = 3),
                                                     selected = 3),
                                         numericInput("adjpval",
                                                      h4("adjusted P-value"),
                                                      value = 0.05),
                                         selectInput("normalization", h4("Choose normalization method"),
                                                     choices = list("BMIQ" = "BMIQ",
                                                                    "SWAN" = "SWAN",
                                                                    "PBC" = "PBC",
                                                                    "FuncNorm" = "FunctionalNormalization"),
                                                     selected = "BMIQ"),
                                        switchInput("batchEffect",
                                                    label = "Compute batch effect",
                                                    onStatus = "success",
                                                    offStatus = "danger",
                                                    labelWidth = "300px"),
                                        switchInput("cellTypeDecon",
                                                    label = "Compute Cell Type Hetergeneity",
                                                    onStatus = "success",
                                                    offStatus = "danger",
                                                    labelWidth = "300px")
                                        ),
                                  tabPanel("Minfi parameters",
                                          #id = "minfi",
                                          value = "2",
                                         #h3("Minfi pipeline parameters"),
                                         div(style = "font-size:20px; color: #420420; font-family: papyrus",
                                          HTML("<b>Minfi pipeline parameters</b>")),
                                         selectInput("preprocess", h4("Choose preprocess method"),
                                                    choices = list(
                                                      "Raw" = "preprocessRaw",
                                                      "SWAN" = "preprocessSWAN",
                                                      "Qunatile" = "preprocessQuantile",
                                                      "Noob" = "preprocessNoob",
                                                      "Illumina" = "preprocessIllumina",
                                                      "Funnorm" = "preprocessFunnorm"),
                                                    selected = "preprocessQuantile"),
                                         h4("Select filteration method"),
                                         switchInput("dropxy",
                                                    label = "Drop X and Y chromosomes",
                                                    onStatus = "success",
                                                    offStatus = "danger",
                                                    labelWidth = "300px"),
                                         switchInput("dropsnps",
                                                    label = "Drop SNPs",
                                                    onStatus = "success",
                                                    offStatus = "danger",
                                                    labelWidth = "300px"),
                                         switchInput("nsp",
                                                    label = "remove non-specific probes",
                                                    onStatus = "success",
                                                    offStatus = "danger",
                                                    labelWidth = "300px"),
                                         h4("Compute cell type heterogeneity"),
                                         switchInput("cellcount",
                                                    label = "Cell Proportion estimation",
                                                    onStatus = "success",
                                                    offStatus = "danger",
                                                    labelWidth = "300px"),
                                         h4("Please select the compare groups"),
                                         textInput("group1", "Type first group name", "groupA",
                                                    width = "300px"),
                                         textInput("group2", "Type second group name", "groupB",
                                                    width = "300px"),
                                         selectInput("anno", h4("Choose genome annotation database"),
                                                    choices = list(
                                                      "hg19" = "hg19",
                                                      "hg38" = "hg38"),
                                                    selected = "hg38")
                                          ),
                                      tabPanel("Upload data",
                                      div(style = "font-size:20px; color: #468499; font-family: papyrus",
                                          HTML("<b>Technical parameters</b>")),
                                         numericInput("cores",
                                                      h4("Number of cores"),
                                                      value = 4),

                                         shinyDirButton("directory", "Choose sample directory", "Upload"),
                                         textOutput('directory_name'),
                                        waiter::use_waiter(),
                                        actionButton("runMethylysis", "Run Analysis") 
                                      )
                              )
                            ),
                            box(
                              title = "Methylation Analysis Result", width = 8, status = "warning",
                              tabBox(
                                id = "tabset1", height = "100%", width = "100%",
                                # tabPanel("R console",
                                #       shinyjs::useShinyjs(),
                                #       pre(id="console")),
                                tabPanel("QC result",
                                         actionButton("qcgenerate", "Show QC result"),
                                         uiOutput("qcview")
                                         #,
                                        #  br(),
                                        #  downloadButton('qcResult', 'Download QC result')
                                         ),
                                    
                                tabPanel("Normalized data table",
                                         div(style = 'overflow-x: scroll', DT::dataTableOutput("tabnorm", width = "100%")),
                                         br(),
                                         downloadButton('normTable', 'Download full normalized data (text file)')),

                                tabPanel("Cell type deconvolution plot",
                                         actionButton("decongenerate", "Show Cell Type Deconvolution Plot"),
                                         br(),
                                         br(),
                                         sliderInput(
                                            "decon_size",
                                            label = "Zoom in/out plot",
                                            value = 700,
                                            min = 200,
                                            max = 1200,
                                            ticks = TRUE,
                                            step = 10),    
                                   box(
                                     width = NULL,  status = "warning",
                                     radioButtons(
                                       inputId = "filetype_deconv",
                                       label = "Choose file type to download:",
                                       inline = TRUE,
                                       choices = list("PDF", "PNG","SVG","TIFF")),
                                     downloadButton(outputId = "deconvDown", label = "Download Plot"))),           
                                
                                tabPanel("DMC table",
                                         div(style = 'overflow-x: scroll', DT::dataTableOutput("tabdmc", width = "100%")),
                                          br(),
                                          downloadButton('dmcTable', 'Download DMC full data (as text)')),
                                
                               tabPanel("Download results",
                                        div(style = "font-size:14px; color:black",
                                        tags$ol(HTML("1. Result folder will contains individual <b>Quality Control</b> figures")),
                                        tags$ol(HTML("2. Normalized file (using user-defined normalized method)")),
                                        tags$ol(HTML("3. Differential methylated CpG (DMC) analysis results with annotation")),
                                        tags$ol(HTML("4. Batch Effect Correction data table and Figure (if applicable)")),
                                        tags$ol(HTML("5. Cell Deconvolution data table and Figure (if applicable)")),
                                        tags$ol(HTML("6. <b>NOTE: All data files will be downloaded as text format (can be exported into MS Excel)</b>")),
                                        tags$ol(HTML("7. <b>NOTE: All data tables are compatible with further analysis on <i>methylR</i>, please </b>")),

                                        
                                        actionButton("download_btn", label = "Download methylysis results as zip file")))
                                )
                              )
                            )

)

#=====================================================#
#  Chromosome map analysis-ui
#=====================================================#

bodyChrom <- tabItem(tabName = "chromplot",
                    h2("Chromosome mapping"),
                    
                    fluidRow(
                      box(
                        title = "Usage Instructions", width = 12, status = "primary",
                        tabBox(
                          id = "chromomap", height="100%", width="100%",
                          div(style = "font-size:14px",
                            tags$ol(HTML("1. Please upload the differentially methylated CpG result file as input. The current version of <b><i>methylR</i></b> can handle the differentially methylated CpG data file without any modification.")),
                            tags$ol("2. Users can choose the fold change as cut-off to view most differentially methylated CpGs and correspnding gene symbols on chromosomes"),
                            tags$ol(tags$a(href="https://methylr.netlify.app/intro.html", "3. Check the manual for more details", target="_blank"))
                        ),
                        h5("R package used"),
                        div(style = "font-size:14px; color:black",
                            tags$ol(tags$a(href= "https://bioconductor.org/packages/release/bioc/html/chromPlot.html", "1. chromPlot - Global visualization tool of genomic data", target= "_blank"))
                            )
                          )
                        ),
                      box(
                        title = "Data Upload", width=4, status = "warning",
                        tabBox(
                          id= "chromoplot", height = "100%", width = "100%",

                          tabPanel("Upload",
                                  fileInput("chromfile", 
                                            label = "Select annotated DMC file",
                                            accept = c(
                                              'text/csv',
                                              'text/comma-separated-values',
                                              'text/tab-separated-values',
                                              '.csv',
                                              '.tsv',
                                              '.txt'
                                            )
                                    ),
                                  checkboxInput('header_chrom', label = 'Header', TRUE),
                                  
                                  selectInput("chr", 
                                              label = "Select Chromosome number",
                                              selected = 1,
                                              multiple = TRUE,
                                              choices = c("Chromosome 1" = 1,"Chromosome 2" = 2, "Chromosome 3" = 3,
                                                          "Chromosome 4" = 4,"Chromosome 5" = 5,"Chromosome 6" = 6,
                                                          "Chromosome 7" = 7,"Chromosome 8" = 8,"Chromosome 9" = 9,
                                                          "Chromosome 10" = 10,"Chromosome 11" = 11,"Chromosome 12" = 12,
                                                          "Chromosome 13" = 13,"Chromosome 14" = 14,"Chromosome 15" = 15,
                                                          "Chromosome 16" = 16,"Chromosome 17" = 17,"Chromosome 18" = 18,
                                                          "Chromosome 19" = 19,"Chromosome 20" = 20,"Chromosome 21" = 21,
                                                          "Chromosome 22" = 22,"Chromosome X" = "X","Chromosome Y" = "Y")
                                                ),
                                    numericInput("fc", 
                                              label = "Select logFC cut-off", 
                                              value = 0.3,
                                              step = 0.1),
                                    
                                    numericInput("cex",
                                              label = "Change font size",
                                              value = 0.9,
                                              min = 0.3,
                                              max = 2,
                                              step = 0.1),
                                  actionButton("plot", label = "Create plot")
                                  )
                                )
                          ),
                        box(
                          title = "Chromosome map", status = "warning", width = 8,
                          tabBox(
                            id = "chromresult", height = "100%", width= "100%",

                            tabPanel("Chromosomal Mappping",
                            box(
                            width = NULL, status = "warning",
                            radioButtons(
                                    inputId = "filetype_chromoplot",
                                    label = "Choose file type to download the plot:",
                                    inline = TRUE,
                                    choices = list("PDF", "PNG", "SVG", "TIFF")
                               ),
                              downloadButton(outputId = "chromoplotDownload", lable = "Download Plot")),
                              plotOutput("myChromoMap", width = "1400px", height = "1200px")
                            )
                          )
                        )  
                    )
                  )



#=====================================================#
#  multi-dimensional analysis
#=====================================================#

bodyMDA <- tabItem(tabName = "multidim",
                   h2("Multi-Dimensional Analysis"),

                   fluidRow(
                     box(
                       title = "Usage Instructions", width = 12, status = "primary",
                       tabBox(
                         id = "mdause", height = "100%", width = "100%",
                         div(style= "font-size:14px",
                            tags$ol(HTML("1. Please upload TEXT (.txt) file as input. The current version of <b><i>methylR</i></b> can handle the normalized beta-value DNA methylation data file without any modification.")),
                            tags$ol("2. Users can select the number of variables to generate the MDS plot as well as PCA plot."),
                            tags$ol(tags$a(href="https://methylr.netlify.app/intro.html", "3. Check the manual for more details.", taget="_blank"))
                            ),
                          h5("R packages used"),
                          div(style = "font-size:14px; color:black",
                            tags$ol(tags$a(href= "https://www.rdocumentation.org/packages/minfi/versions/1.18.4/topics/mdsPlot", "1. mdsPlot from minfi package", target= "_blank")),
                            tags$ol(tags$a(href= "https://cran.r-project.org/web/packages/FactoMineR/index.html", "2. FactoMineR", target="_blank")),
                            tags$ol(tags$a(href= "https://cran.r-project.org/web/packages/factoextra/index.html", "3. factoextra", target="_blank"))
                            )
                       )
                     ),
                     box(
                       title = "Data Upload", width = 4, status = "warning",
                       tabBox(
                         id = "mdaplot", height = "100%", width = "100%",

                         tabPanel("Upload",
                                  fileInput('file_mds',
                                            label = "Upload file",
                                            accept = c(
                                              'text/csv',
                                              'text/comma-separated-values',
                                              'text/tab-separated-values',
                                              '.csv',
                                              '.tsv',
                                              '.txt'
                                            )))),
                       
                       numericInput("numdms",
                                    h4("Number of most variables"),
                                    value = 1000)
                     ),
                     box(
                       title = "Multi-dimensional Analysis Result", status = "warning", width = 8,
                       tabBox(
                         id = "mdaresult", height = "100%", width = "100%",

                         tabPanel("MDS plot",

                          actionButton("runmda", "Run MDS Analysis"),
                          br(),
                          br(),
                          sliderInput(
                                    "mds_size",
                                    label = "Zoom in/out MDS diagram",
                                    value = 500,
                                    min = 200,
                                    max = 1200,
                                    ticks = TRUE,
                                    step = 10),
                          box(
                            width = NULL, status = "warning",
                            radioButtons(
                                    inputId = "filetype_mds",
                                    label = "Choose file type to download the plot:",
                                    inline = TRUE,
                                    choices = list("PDF", "PNG", "SVG", "TIFF")
                               ),
                         downloadButton(outputId = "mdsDownload", lable = "Download Plot")),

                         plotOutput("mdsPlot", width = "100%", height = "100%")
                          
                         ),
                         tabPanel("PCA plot",

                              fileInput('group_pca',
                                label = " Upload file for group information (mandatory)",
                                accept = '.txt'),
                                
                                actionButton("runpca", "Run PCA"),
                                
                                plotlyOutput("pcaplot", width="100%", height="100%"),
                                br(),
                                    downloadButton(outputId = "downloadpca", label = "Download Plot")       
                         )
                       )
                     )
                   )
)

#====================================================#
## Genomic Features
#====================================================#
bodyFeatures <- tabItem(tabName = "features",
                        h2("Genomic Features"),

                        fluidRow(
                          box(
                            title = "Usage Instructions", width = 12, status = "primary",
                            tabBox(
                              id = "features_use", height = "100%", width = "100%",
                              div(style="font-size:14px",
                              tags$ol("1. Please upload TEXT (.txt) file as input."),  
                              tags$ol(HTML("2. The current version of <b><i>methylR</i></b> can handle ChAMP DNA methylation analysis package differentially methylated CpG (DMC) data file.")),
                              tags$ol(tags$a(href= "https://methylr.netlify.app/intro.html", "3. Please check the manual for more details.", target = "_blank"))
                            ),
                            h5(" R packages used"),
                            div(style = "font-size:14px",
                              tags$ol(tags$a(href= "https://cran.r-project.org/web/packages/plotly/index.html", "1. Plotly", taget= "_blank"))))
                          ),
                          box(
                            title = "Data Upload", width = 4, status = "warning",
                            tabBox(
                              id = "features_plot", height = "100%", width = "100%",

                              tabPanel("Upload",
                                       fileInput('file_genfea',
                                                 label = "Upload file",
                                                 accept = c(
                                                   'text/csv',
                                                   'text/comma-separated-values',
                                                   'text/tab-separated-values',
                                                   '.csv',
                                                   '.tsv',
                                                   '.txt'
                                                 )))),
                            #actionButton("demogenfea", "Use Demo data"),
                            actionButton("rungenfea", "Run Analysis")
                          ),
                          box(
                            title = "Genomic Feature Analysis Result", status = "warning", width = 8,
                            tabBox(
                              id = "features_tab", height = "100%", width = "100%",

                              tabPanel("Genomic Features",
                                       plotlyOutput("piechart", width = "600px", height = "600px"),
                                       box(
                                         downloadButton(outputId = "downloadpie", lable = "Download Plot"))
                              ),
                              tabPanel("Data table",
                                       div(style = 'overflow-x: scroll', DT::dataTableOutput("tablegf", width = "80%"))
                                       #  br(),
                                       #  downloadButton('genfeatable', 'Download Genomic features data'))
                              )
                            )
                          )
                        )
)
#====================================================#
## Venn module ####
#====================================================#
bodyVenn <- tabItem(tabName = "venn",
                    h2("Venn diagrams"),

                    fluidRow(
                      box(
                        title="Usage Instructions", width = 12, status = "primary",
                        div(style="font-size:14px",
                              tags$ol("1. Please upload TEXT (.txt), Comma-separated file (.csv) file as input."),  
                              tags$ol(HTML("2. Each column represents a set, and each row represents an element (names/gene/SNPs). User can upload a file containing maximum of 6 sets")),
                              tags$ol(tags$a(href= "https://asntech.shinyapps.io/intervene/","3. Examples are taken from Intervene shiny app.", target="_blank")),
                              tags$ol(tags$a(href= "https://methylr.netlify.app/intro.html", "4. Please check the manual for more details.", target = "_blank"))
                            ),
                            h5("R packages used"),
                            div(style = "font-size:14px",
                              tags$ol(tags$a(href= "https://github.com/js229/Vennerable", "1. Vennerable", taget= "_blank")))
                      ),
                      box( title = "Data Upload & Parameters Setup & settings", width = 4, status = "warning",
                           tabBox(
                             id = "venntab", height = "100%", width = "100%",

                             tabPanel("Upload",
                                      fileInput(
                                        'file_venn',
                                        label = "Upload file",
                                        accept = c(
                                          'text/csv',
                                          'text/comma-separated-values',
                                          'text/tab-separated-values',
                                          '.csv',
                                          '.tsv'
                                        )
                                      ),
                                      checkboxInput('header_venn', label = 'Header', TRUE),
                                      radioButtons(
                                        'sep_venn',
                                        label = 'Separator',
                                        #inline = TRUE,
                                        choices = c(
                                          Comma = ',',
                                          Tab = '\t',
                                          Semicolon = ';'
                                        ),
                                        selected = ','
                                      ),
                                      br(),
                                      HTML("<hr> <a href='Whyte_et_al_2013_SEs_genes.csv'> <i class='fa fa-download'> </i> List example data</a>")
                             ),
                             tabPanel("Settings",
                                      #add content
                                      htmlOutput("venn_sets"),
                                      selectInput(
                                        "venn_type",
                                        label = "Venn type",
                                        choices = list("Classical" = "Classical",
                                                       "Chow-Ruskey" = "ChowRuskey",
                                                       "Edwards" = "AWFE",
                                                       "Squares" = "squares",
                                                       "Battle" = "battle"
                                        ),
                                        selected = "ChowRuskey"),

                                      checkboxInput('doWeights', label = "Weighted", value = TRUE),
                                      checkboxInput('doEuler', label = "Eular", value = FALSE),

                                      sliderInput(
                                        "venn_lwd",
                                        label = "Border line width",
                                        value = 2.0,
                                        min = 0.0,
                                        max = 10.0,
                                        ticks = TRUE,
                                        step = 0.5),

                                      selectInput('venn_lty', label="Border line type",
                                                  choices = list(
                                                    "Solid" = 1,
                                                    "Dashed" = 2,
                                                    "Dotted" = 3,
                                                    "Dot dash" = 4,
                                                    "Long dash" = 5,
                                                    "Two dash" = 6,
                                                    "Blank" = 0
                                                  ),
                                                  selected = "1"
                                      ),

                                      sliderInput(
                                        "venn_size",
                                        label = "Zoom in/out Venn diagram",
                                        value = 500,
                                        min = 200,
                                        max = 1200,
                                        ticks = FALSE,
                                        step = 10)
                             ),
                             tabPanel("Font & Color",
                                      selectInput('venn_color_type', label="Select color theme",
                                                  choices = list(
                                                    Set1 = "Set1",
                                                    #YlOrRd = "YlOrRd",
                                                    Custom = "custom"
                                                  ),
                                                  selected = "Set1"
                                      ),
                                      conditionalPanel(condition = "input.venn_color_type=='custom'",
                                                       fluidRow(
                                                         column(2,colourpicker::colourInput("set1_color", label = "Set1", value = "#E41A1C")),
                                                         column(2, colourpicker::colourInput("set2_color", label = "Set2", value = "#377EB8")),
                                                         column(2,colourpicker::colourInput("set3_color", label = "Set3", value = "#4DAF4A")),
                                                         column(2, colourpicker::colourInput("set4_color", label = "Set4", value = "#984EA3")),
                                                         column(2,colourpicker::colourInput("set5_color", label = "Set5", value = "#FF7F00")),
                                                         column(2, colourpicker::colourInput("set6_color", label = "Set6", value = "#FFFF33")))
                                      ),
                                      numericInput(
                                        "venn_labelsize",
                                        label = "Label font size",
                                        value = 15,
                                        min = 1,
                                        max = 50),

                                      numericInput(
                                        "venn_cex",
                                        label = "Number font size",
                                        value = 1.5,
                                        min = 0.5,
                                        max = 20)
                             )
                           )
                      ),
                      box(
                        status = "warning", width = 8,
                        tabBox(
                          # The id lets us use input$tabset1 on the server to find the current tab
                          id = "tabset1", height = "100%", width = "100%",
                          tabPanel("Venn diagram",

                                   #htmlOutput('plot_text_p'),
                                   plotOutput("vennPlot", width = "100%", height = "100%"),
                                   box(
                                     width = NULL,  status = "warning",
                                     radioButtons(
                                       inputId = "filetype_venn",
                                       label = "Choose file type to download:",
                                       inline = TRUE,
                                       choices = list("PDF", "PNG","SVG","TIFF")),

                                     downloadButton(outputId = "VennDown", label = "Download Plot")
                                   )
                          )
                        )
                      )
                    )
)

#====================================================#
## UpSet module ####
#====================================================#
bodyUpSet <- tabItem(tabName = "upset", value="upset_plot",
                     h2("UpSet plots"),
                     fluidRow(
                       box(
                         title="Usage Instructions", width =12, status = "primary",
                          div(style="font-size:14px",
                              tags$ol("1. Please upload TEXT (.txt), Comma-separated file (.csv) file as input."),  
                              tags$ol(HTML("2. Each column represents a set, and each row represents an element (names/gene/SNPs).")),
                              tags$ol(tags$a(href= "https://asntech.shinyapps.io/intervene/","3. Examples are taken from Intervene shiny app.", target="_blank")),
                              tags$ol(tags$a(href= "https://methylr.netlify.app/intro.html", "4. Please check the manual for more details.", target = "_blank"))
                            ),
                            h5("R packages used"),
                            div(style = "font-size:14px",
                              tags$ol(tags$a(href= "https://cran.r-project.org/web/packages/UpSetR/index.html", "1. UpSetR", taget= "_blank")))
                       ),
                       box(
                         status = "warning", width = 4,
                         tabBox(
                           # The id lets us use input$tabset1 on the server to find the current tab
                           id = "upset_plot", height = "100%", width = "100%",

                           tabPanel("Upload",
                                    radioButtons('upset_input_type',
                                                 label ='Input type ',
                                                 choices = c(
                                                   "List of Genes/SNPs" = 'list',
                                                   "Binary data (0 & 1)" = 'binary'
                                                 ),
                                                 selected = 'list'
                                    ),
                                    fileInput(
                                      'file1',
                                      label = "Upload file",
                                      accept = c(
                                        'text/csv',
                                        'text/comma-separated-values',
                                        'text/tab-separated-values',
                                        '.csv',
                                        '.tsv'
                                      )
                                    ),
                                    checkboxInput('header', label = 'Header', TRUE),
                                    radioButtons('sep',
                                                 label ='Separator',
                                                 choices = c(
                                                   Comma = ',',
                                                   Semicolon = ';',
                                                   Tab = '\t'
                                                 ),
                                                 selected = ','
                                    ),
                                    #actionButton("confirm_upset", "Plot UpSet"),
                                    textAreaInput('upset_comb', label = "OR enter set combinations/expression", rows = 4, placeholder = "Enter combinations of sets to plot"),
                                    p("For example: A=3, B=3, C=2, A&B=1, A&C=2, B&C=1 ,A&B&C=1"),
                                    #actionLink("confirm_upset_demo", "Or load demo data")

                                    HTML("<hr> <a href='Whyte_et_al_2013_SEs_genes.csv'> <i class='fa fa-download'> </i> List example data</a> | "),
                                    HTML("<a href='mutations_glioblastoma_TCGA.csv'> <i class='fa fa-download'> </i> Binary example data</a>")
                           ),

                           tabPanel("Settings",
                                    #add content
                                    htmlOutput("sets"),
                                    numericInput(
                                      "nintersections",
                                      label = "Number of intersections to show",
                                      value = 30,
                                      min = 1,
                                      max = 60),

                                    selectInput(
                                      "order",
                                      label = "Order intersections by",
                                      choices = list("Degree" = "degree",
                                                     "Frequency" = "freq"),
                                      selected = "freq"),
                                    selectInput(
                                      "decreasing",
                                      label = "Increasing/Decreasing",
                                      choices = list("Increasing" = "inc",
                                                     "Decreasing" = "dec"),
                                      selected = "dec"),

                                    selectInput(
                                      "scale.intersections",
                                      label = "Scale intersections",
                                      choices = list("Original" = "identity",
                                                     "Log10" = "log10",
                                                     "Log2" = "log2"),
                                      selected = "identity"),

                                    selectInput(
                                      "scale.sets",
                                      label = "Scale sets",
                                      choices = list("Original" = "identity",
                                                     "Log10" = "log10",
                                                     "Log2" = "log2"),
                                      selected = "identity"),


                                    sliderInput(
                                      "upset_width",
                                      label = "Plot width",
                                      value = 650,
                                      min = 400,
                                      max = 1200,
                                      ticks = FALSE,
                                      step = 10),

                                    sliderInput(
                                      "upset_height",
                                      label = "Plot height",
                                      value = 400,
                                      min = 300,
                                      max = 1000,
                                      ticks = FALSE,
                                      step = 10),

                                    sliderInput(
                                      "mbratio",
                                      label = "Bar matrix ratio",
                                      value = 0.30,
                                      min = 0.20,
                                      max = 0.80,
                                      ticks = FALSE,
                                      step = 0.01),

                                    checkboxInput('show_numbers', label = "Show numbers on bars", value = TRUE),

                                    sliderInput(
                                      "angle",
                                      label = "Angle of number on the bar",
                                      min = -90,
                                      max = 90,
                                      value = 0,
                                      step = 1,
                                      ticks = F),

                                    checkboxInput('empty', label = "Show empty intersections", value = FALSE),
                                    checkboxInput('keep.order', label = "Keep set order", value = FALSE),

                                    numericInput(
                                      "pointsize",
                                      label = "Connecting point size",
                                      value = 2.5,
                                      min = 1,
                                      max = 10),

                                    numericInput(
                                      "linesize",
                                      label = "Connecting line size",
                                      value = 0.8,
                                      min = 0.5,
                                      max = 10)
                           ),
                           tabPanel("Font & Colors",

                                    colourpicker::colourInput("mbcolor", "Select main bar colour", "#ea5d4e"),
                                    colourpicker::colourInput("sbcolor", "Select set bar colour", "#317eab"),

                                    numericInput(
                                      "intersection_title_scale",
                                      label = "Font size of intersection size label",
                                      value = 1.8,
                                      min = 0.5,
                                      max = 100),
                                    numericInput(
                                      "set_title_scale",
                                      label = "Set size label font",
                                      value = 1.8,
                                      min = 0.5,
                                      max = 100),
                                    numericInput(
                                      "intersection_ticks_scale",
                                      label = "Intersection size ticks font",
                                      value = 1.2,
                                      min = 0.5,
                                      max = 100),
                                    numericInput(
                                      "set_ticks_scale",
                                      label = "Set Size ticks font",
                                      value = 1.5,
                                      min = 0.5,
                                      max = 100),
                                    numericInput(
                                      "intersection_size_numbers_scale",
                                      label = "Intersection Size Numbers font size",
                                      value = 1.2,
                                      min = 0.5,
                                      max = 100),
                                    numericInput(
                                      "names_scale",
                                      label = "Set Names font size",
                                      value = 1.5,
                                      min = 0.5,
                                      max = 100
                                    )
                           )
                         )
                       ),
                       box(
                         status = "warning", width = 8, height = "100%",
                         tabBox(
                           #title = "First tabBox",
                           # The id lets us use input$tabset1 on the server to find the current tab
                           id = "upsetplottab", height = "100%", width = "100%",
                           tabPanel("UpSet Plot",
                                    htmlOutput('plot_text'),
                                    plotOutput('plot1', width = "100%", height = "100%"),
                                    box(
                                      width = NULL,  status = "warning",
                                      radioButtons(
                                        inputId = "filetype",
                                        label = "Choose file type to download:",
                                        inline = TRUE,
                                        choices = list("PDF", "PNG","SVG","TIFF")),

                                      downloadButton(outputId = "UpSetDown", label = "Download Plot")
                                    )
                           )
                         )
                       )
                     )
)

#====================================================#
## Pairwise module ####
#====================================================#
bodyPairwise <- tabItem(tabName = "pairwise",
                        h2("Pairwise intersection heatmap"),
                        fluidRow(
                          box(
                            title="Usage Instructions", width = 12, status = "primary",
                            div(style="font-size:14px",
                              tags$ol("1. Please upload TEXT (.txt), CSV, matrix file as input."),  
                              tags$ol(HTML("2. Each column and row represents pairwise fraction of overlap/count etc between different names/genomic region sets.")),
                              tags$ol(tags$a(href= "https://asntech.shinyapps.io/intervene/","3. Examples are taken from Intervene shiny app.", target="_blank")),
                              tags$ol(tags$a(href= "https://methylr.netlify.app/intro.html", "4. Please check the manual for more details.", target = "_blank"))
                            ),
                            h5("R packages used"),
                            div(style = "font-size:14px",
                              tags$ol(tags$a(href= "https://cran.r-project.org/web/packages/corrplot/vignettes/corrplot-intro.html", "1. Corrplot", taget= "_blank")),
                              tags$ol(tags$a(href= "https://github.com/talgalili/d3heatmap", "2. d3heatmap", taget= "_blank"))
                              )
                          ),
                          box( title = "Data Upload & Parameters Setup & settings", width = 4, status = "warning",
                               tabBox(
                                 id = "pairwisetab", height = "100%", width = "100%",

                                 tabPanel("Upload",
                                          radioButtons('pairwise_input_type',
                                                       label ='Input type ',
                                                       choices = c(
                                                         "Matrix" = 'matrix',
                                                         "List of Genes/SNPs" = 'list'
                                                       ),
                                                       selected = 'matrix'
                                          ),
                                          numericInput("num_p",
                                            h4("Number of variables"),
                                            value = 100),
                                          fileInput(
                                            'file_p',
                                            label = "Upload file",
                                            accept = c(
                                              'text/csv',
                                              'text/comma-separated-values',
                                              'text/tab-separated-values',
                                              '.txt',
                                              '.csv',
                                              '.tsv'
                                            )
                                          ),
                                          checkboxInput('header_p', label = 'Header', TRUE),
                                          radioButtons(
                                            'sep_p',
                                            label = 'Separator',
                                            choices = c(
                                              Tab = "\t",
                                              Comma = ",",
                                              Semicolon = ";"
                                            ),
                                            selected = "\t"
                                          ),
                                          br(),
                                          #HTML("<hr>  <a href='frac_pairwise_matrix_Khan_et_al_2016.txt'> <i class='fa fa-download'> </i> Matrix example data</a> | "),

                                          #HTML("<a href='Whyte_et_al_2013_SEs_genes.csv'> <i class='fa fa-download'> </i> List example data</a> | ")
                                 ),
                                 tabPanel("Settings",
                                          selectInput(
                                            "plotType", label= "Plot type",
                                            choices = list("Heatmap.2" = "heatmap.2",
                                                           "Corrplot" = "corrplot"),
                                            selected = 'heatmap.2'),
                                          selectInput(
                                            "corp_cor",
                                            label = "Correlation Coefficient",
                                            choices = list("Non" = "non",
                                                           "Pearson" = "pearson",
                                                           "Kendall" = "kendall",
                                                           "Spearman" = "spearman"
                                            ),
                                            selected = "non"),

                                          conditionalPanel(condition = "input.plotType == 'corrplot'",
                                                           selectInput(
                                                             "corp_method",
                                                             label = "Heatmap method",
                                                             choices = list("Color" = "color",
                                                                            "Pie" = "pie",
                                                                            "Circle" = "circle",
                                                                            "Square" = "square",
                                                                            "Ellipse" = "ellipse",
                                                                            "Number" = "number",
                                                                            "Shade" = "shade"

                                                             ),
                                                             selected = "color"),
                                                           selectInput(
                                                             "corp_type",
                                                             label = "Heatmap type",
                                                             choices = list("Full" = "full",
                                                                            "Lower" = "lower",
                                                                            "Upper" = "upper"
                                                             ),
                                                             selected = "full"),

                                                           selectInput(
                                                             "corp_order",
                                                             label = "Heatmap order",
                                                             choices = list("Hierarchical clustering" = "hclust",
                                                                            "Eigenvectors" = "AOE",
                                                                            "Principal component" = "FPC",
                                                                            #"Alphabetical order" = "alphabet",
                                                                            "Original" = "original"
                                                             ),
                                                             selected = "hclust"),

                                                           selectInput(
                                                             "tl_pos",
                                                             label = "Position of text labels",
                                                             choices = list("Left and top" = "lt",
                                                                            #"Left and diagonal" = "ld",
                                                                            #"Top and diagonal" = "td",
                                                                            "Diagonal" = "d",
                                                                            "Do not show" = "n"
                                                             ),
                                                             selected = "lt"),
                                                           selectInput(
                                                             "cl.pos",
                                                             label = "Position of colorlabel",
                                                             choices = list("Right" = "r",
                                                                            "Bottom" = "b",
                                                                            "Don't show" = "n"
                                                             ),
                                                             selected = "r"),
                                                           checkboxInput('corp_diag', label = "Show diagonal", value = FALSE)
                                          ),
                                          selectInput(
                                            "hclust_method",
                                            label = "Agglomeration method for hclust",
                                            choices = list(
                                              "ward.D" = "ward.D",
                                              "ward.D2" = "ward.D2",
                                              "Single" = "single",
                                              "Complete" = "complete",
                                              "Average" = "average",
                                              "Mcquitty" = "mcquitty",
                                              "Median" = "median",
                                              "Centroid" = "centroid"
                                            ),
                                            selected = "complete"),
                                          numericInput(
                                            "addrect",
                                            label = "No. of clusters for hclust",
                                            value = 3,
                                            min = 1,
                                            max = 25
                                          ),
                                          conditionalPanel(condition = "input.plotType == 'heatmap.2'",
                                                           selectInput(
                                                             "distance",
                                                             label = "Distance Matrix Computation",
                                                             choices = list(
                                                               "None" = "none",
                                                               "Euclidean" = "euclidean",
                                                               "Manhattan" = "manhattan",
                                                               "Canberra" = "canberra",
                                                               "Minkowski" = "minkowski"
                                                             ),
                                                             selected = "euclidean"),
                                                           selectInput(
                                                             "dendrogram",
                                                             label = "Dendrogram",
                                                             choices = list(
                                                               "Both" = "both",
                                                               "Row" = "row",
                                                               "Column" = "column",
                                                               "None" = "none"
                                                             ),
                                                             selected = "both"),
                                                           checkboxInput('symm', label = "X is a symmetric matrix", value = FALSE),
                                                           checkboxInput('key', label = "Show/hide color-key", value = TRUE),
                                                           conditionalPanel(condition = "input.key == true",
                                                                            sliderInput("keysize",
                                                                                        label = h5("Size of the key"),
                                                                                        value = 1.2,
                                                                                        min = 1,
                                                                                        max = 10,
                                                                                        ticks = TRUE,
                                                                                        step = 0.1),
                                                                            textInput("key.title", "Key title: ", value="Color key"),
                                                                            textInput("key.xlab", "Key x-axis label: ", value="Value"),
                                                                            textInput("key.ylab", "Key y-axis label: ", value="Count")
                                                           )
                                          ),
                                          textInput("corp_title", "Title: ", value="Pairwise intersection"),

                                          sliderInput(
                                            "heatmap_size",
                                            label = h5("Zoom in & out Heatmap"),
                                            value = 500,
                                            min = 200,
                                            max = 1200,
                                            ticks = FALSE,
                                            step = 10)
                                 ),
                                 tabPanel("Font & Color",
                                          selectInput('color_type', label="Select theme",
                                                      choices = list(
                                                        RdYlBu = "RdYlBu",
                                                        YlOrRd = "YlOrRd",
                                                        Custom = "custom"
                                                      ),
                                                      selected = "RdYlBu"
                                          ),
                                          conditionalPanel(condition = "input.color_type=='custom'",
                                                           fluidRow(
                                                             column(4,colourpicker::colourInput("lower_colour", label = "Lower", value = "#6a011f")),
                                                             column(4, colourpicker::colourInput("middle_colour", label = "Middle", value = "#FFFFFF")),
                                                             column(4, colourpicker::colourInput("higher_colour", label = "Higher", value = "#08376a")))
                                          ),
                                          numericInput(
                                            "tl.cex",
                                            label = "Size of text label",
                                            value = 0.8,
                                            min = 0.3,
                                            step = 0.1,
                                            max = 50
                                          ),
                                          numericInput(
                                            "tl.srt",
                                            label = "Text label rotation in degrees",
                                            value = 90,
                                            min = 0,
                                            step = 5,
                                            max = 180
                                          ),
                                          numericInput(
                                            "cl.cex",
                                            label = "Size of colorlabel text",
                                            value = 0.8,
                                            min = 0.3,
                                            step = 0.1,
                                            max = 10
                                          ),
                                          colourpicker::colourInput("addgrid_col", "Select grid colour", "#FAF5F5"),
                                          colourpicker::colourInput("rect_col", "Color for rectangle border(s)", "#17110F"),
                                          colourpicker::colourInput("tl_col", "Select label colour", "grey23")

                                 )
                               )
                          ),
                          box(
                            title = "Analysis Result",status = "warning", width = 8,
                            tabBox(
                              #title = "First tabBox",
                              # The id lets us use input$tabset1 on the server to find the current tab
                              id = "tabset1", height = "100%", width = "100%",
                              tabPanel("Heatmap",
                                       htmlOutput('plot_text_p'),
                                       conditionalPanel(condition = "input.plotType == 'corrplot'",
                                                        plotOutput("corrplotHM", width = "100%", height = "100%")
                                       ),
                                       conditionalPanel(condition = "input.plotType == 'heatmap.2'",
                                                        plotOutput("heatmap2_plot_out", width = "100%", height = "100%")
                                       ),
                                       box(
                                         width = NULL,  status = "warning",
                                         radioButtons(
                                           inputId = "filetype_heatmap",
                                           label = "Choose file type to download:",
                                           inline = TRUE,
                                           choices = list("PDF", "PNG","SVG","TIFF")),
                                         conditionalPanel(condition = "input.plotType == 'heatmap.2'",
                                                          downloadButton(outputId = "Heatmap2PlotDown", label = "Download Plot"),
                                                          br()

                                         ),
                                         conditionalPanel(condition = "input.plotType == 'corrplot'",
                                                          downloadButton(outputId = "HeatmapDown", label = "Download Plot"),
                                                          br()
                                         )
                                       )
                              ),
                              tabPanel("Interactive heatmap",
                                       conditionalPanel(condition = "input.plotType == 'heatmap.2'",
                                                        d3heatmapOutput("d3HM"),
                                                        br(),
                                                        downloadButton(outputId = "HeatmapHTMLDown", label = "Download HTML")
                                       ),
                                       conditionalPanel(condition = "input.plotType == 'corrplot'",
                                                        h4("Note: Interactive heatmap is only available for Heatmap.2 plot type.")
                                       )
                              ),
                              tabPanel("Data table",
                                       div(style = 'overflow-x: scroll', DT::dataTableOutput("pairwiseTable", width = "100%")),
                                       br(),

                                       downloadButton(outputId = "HeatmapCSVDown", label = "Download CSV")
                              )
                            )
                          )
                        )
)

#========================================#
## Volcano plot
#========================================#
bodyVol <- tabItem(tabName = "volcano",
                   h2("Volcano plot"),

                   fluidRow(
                     box(
                       title = "Usage Instructions", width = 12, status = "primary",
                       tabBox(
                         id = "volcano_use", height = "100%", width = "100%",
                         div(style="font-size:14px",
                              tags$ol("1. Please upload TEXT (.txt) file as input."),  
                              tags$ol(HTML("2. The current version of <b><i>methylR</i></b> can handle the differentially methylated CpG (DMC) data file generated using ChAMP DNA methylation analysis package.")),
                              tags$ol("3. NOTE: To generate a Volcano Plot with the full dataset (where adjusted p-value = 1) requires long time and also may have slow response of the browser (due to big data size). It is advised to avoid full dataset."),
                              tags$ol(tags$a(href= "https://methylr.netlify.app/intro.html", "4. Please check the manual for more details.", target = "_blank"))
                            ),
                            h5(" R packages used"),
                            div(style = "font-size:14px",
                              tags$ol(tags$a(href= "https://cran.r-project.org/web/packages/plotly/index.html", "1. Plotly", taget= "_blank")))
                        #  p("Please upload TEXT (.txt) file as input.")
                       )
                     ),

                     box(title = "Data Upload", width = 4, status = "warning",
                         tabBox(
                           id = "volcanotab", height = "100%", width = "100%",

                           tabPanel("Upload",
                                    fileInput(
                                      'fileVol',
                                      label = "Upload file",
                                      accept = c(
                                        'text/csv',
                                        'text/comma-separated-values',
                                        'text/tab-separated-values',
                                        '.csv',
                                        '.tsv',
                                        '.txt')
                                    )),
                                    numericInput("volp", 
                                    h4("adjusted P-value cut-off"),
                                    value = 0.05),
                                    numericInput("volfc",
                                    h4("logFC cut-off"),
                                    value = 0.1)
                            ),
                         #actionButton("runvoldemo", "Use Demo Data"),
                         actionButton("runVol", "Run Analysis")
                     ),
                     box(
                       title = "Analysis Result",status = "warning", width = 8,
                       tabBox(
                         id = "volcano_tab", height = "100%", width = "100%",

                         tabPanel("Volcano Plot",
                                  plotlyOutput("volplot", width = "800px", height = "600px"),
                                  box(
                                    downloadButton(outputId = "downloadvolcano", lable = "Download Plot")
                                  )),

                         tabPanel("Volcano plot data",
                                  div(style = 'overflow-x: scroll', DT::dataTableOutput("tablevolcano", width = "80%")),
                         )
                       ))
                   ))

#========================================#
## Gene Ontology (GO) analysis
#========================================#
bodyGo <- tabItem(tabName = "go",
                  h2("Gene Ontology (GO) analysis"),

                  fluidRow(
                    box(
                      title = "Usage Instructions", width = 12, status = "primary",
                      tabBox(
                        id = "go_use", height = "100%", width = "100%",
                        div(style="font-size:14px",
                              tags$ol("1. Please upload TEXT (.txt) file as input."),  
                              tags$ol(HTML("2. The current version of <b><i>methylR</i></b> can handle the differentially methylated CpG (DMC) data file generated using ChAMP DNA methylation analysis package.")),
                              tags$ol("3. Data can be uploaded before/after parameter settings."),
                              tags$ol("4. The module will also generate the result as a table format. "),
                              tags$ol(tags$a(href= "https://methylr.netlify.app/intro.html", "5. Please check the manual for more details.", target = "_blank"))
                            ),
                            h5(" R packages used"),
                            div(style = "font-size:14px",
                              tags$ol(tags$a(href= "https://bioconductor.org/packages/release/bioc/html/clusterProfiler.html", "1. ClusterProfiler", taget= "_blank")))
                        #p("Please upload TEXT (.txt) file as input.")
                      )
                    ),
                    box(
                      title = "Data Upload & Parameters Setup", width = 4, status = "warning",
                      tabBox(
                        id = "go_plot", height = "100%", width = "100%",

                        tabPanel("Upload",
                                 selectInput(inputId = "goType",
                                             label = h3("Choose GO analysis type"),
                                             choices = list("Over representation analysis" = 1,
                                                            "Gene set enrichment analysis" = 2),
                                             selected = 1))),
                      numericInput("numpval",
                                   h4("Select the adjusted P-value"),
                                   value = 0.05),
                      numericInput("numqval",
                                   h4("Select the adjusted q-value"),
                                   value = 0.05),
                      numericInput("gonum",
                                   h4("Select number of ontology classes"),
                                   value = 20),
                      selectInput("pvaladj", h4(" Select P-value adjustment method"),
                                         choices = list("Benjamini-Hochberg" = "BH",
                                                        "Benjamini-Yeketuli" = "BY",
                                                        "Bonferroni" = "bonferroni",
                                                        "Holm" = "holm",
                                                        "Hommel" = "hommel",
                                                        "Hochberg" = "hochberg",
                                                        "FDR" = "fdr",
                                                        "None" = "none"),
                                         selected = "BH"),
                      selectInput("ontology", 
                                  h4("Select ontology class"),
                                  choices = list("Cellular component" = "CC",
                                                  "Molecular function" = "MF",
                                                  "Biological process" = "BP"),
                                  selected = "BP"),
                      fileInput('file6',
                                label = "Upload file",
                                accept = c(
                                  'text/csv',
                                  'text/comma-separated-values',
                                  'text/tab-separated-values',
                                  '.csv',
                                  '.tsv',
                                  '.txt'
                                )),
                      #actionButton("goDemo", "Use Demo Data"),
                      actionButton("goRun", "Run Analysis")
                    ),
                    box(
                      title= "Analysis Result", status = "warning", width = 8,
                      tabBox(
                        id = "go_tab", height = "100%", width = "100%",

                        tabPanel("Gene Ontology Plot",
                                 plotlyOutput("goplot", width = "1200px", height = "600px"),
                                 box(
                                   downloadButton(outputId = "downloadGO", lable = "Download Gene Ontology Plot")
                                 )),

                        tabPanel("Gene Ontology data",
                                 div(style = 'overflow-x: scroll', DT::dataTableOutput("tableGO", width = "80%")),
                                 #  br(),
                                 #  downloadButton('gotable', 'Download Gene Ontology data')
                        )))
                  ))

#========================================#
## Pathway enrichment analysis
#========================================#
bodyPathway <- tabItem(tabName = "pathway",
                       h2("Pathway Enrichment Analysis"),

                       fluidRow(
                         box(
                           title="Usage Instructions", width = 12, status = "primary",
                           tabBox(
                             id="path_use", height = "100%", width = "100%",
                             div(style="font-size:14px",
                              tags$ol("1. Please upload TEXT (.txt) file as input."),  
                              tags$ol(HTML("2. The current version of <b><i>methylR</i></b> can handle the differentially methylated CpG (DMC) data file generated using ChAMP DNA methylation analysis package.")),
                              tags$ol("3. Data can be uploaded before/after parameter settings."),
                              tags$ol("4. The module will also generate the result as a table format. "),
                              tags$ol(tags$a(href= "https://methylr.netlify.app/intro.html", "5. Please check the manual for more details.", target = "_blank"))
                            ),
                            h5(" R packages used"),
                            div(style = "font-size:14px",
                              tags$ol(tags$a(href= "https://bioconductor.org/packages/release/bioc/html/clusterProfiler.html", "1. ClusterProfiler", taget= "_blank"),
                              tags$ol(tags$a(href="https://bioconductor.org/packages/release/bioc/html/ReactomePA.html", "2. ReactomePA", target = "_blank"))))
                            #  p("The input TEXT (tab-separated) file should contains these following columns:"),
                            #  p("Gene.Ratio: ratio of input genes that are annotated in a term"),
                            #  p("Pathway: the pathway name"),
                            #  p("Gene.Count: number of genes present in a pathway"),
                            #  p("FDR: the adjusted p-value, level of significance")
                           )
                         ),
                         box(
                          tags$style(
                          HTML(".shiny-notification {
                            position:fixed;
                            top: calc(50%);
                            left: calc(50%);
                            background-color: black;
                            color: white;
                            font-size: 1.5em;
                            font-family: papyrus
                          }
                          "
                          )
                          ),
                           title="Data Upload & Parameters Setup", width =4, status = "warning",
                           tabBox(
                             id="path_plot", height = "100%", width = "100%",

                             tabPanel("Upload",
                                      fileInput("file7", label = "Upload TEXT File", accept = ".txt"),
                                      numericInput("numPath",
                                                   h4("Number of Pathways"),
                                                   value = 20)),
                             selectInput("pathDB", h4("Choose pathway database"),
                                         choices = list(
                                                        "ReactomeDB" = 1,
                                                        "KEGGdb" = 2,
                                                        "Wikipathways" = 3),
                                         selected = 1),
                             selectInput("pvaladj", h4(" Select P-value adjustment method"),
                                         choices = list("Benjamini-Hochberg" = "BH",
                                                        "Benjamini-Yeketuli" = "BY",
                                                        "Bonferroni" = "bonferroni",
                                                        "Holm" = "holm",
                                                        "Hommel" = "hommel",
                                                        "Hochberg" = "hochberg",
                                                        "FDR" = "fdr",
                                                        "None" = "none"),
                                         selected = "BH"),
                             numericInput("adjPvalue",
                                          h4("Select the adjusted P-value"),
                                          value = 0.05),
                             selectInput("pathType", h4("Choose pathway analysis type"),
                                         choices = list("Over representation analysis" = 1,
                                                        "Gene set enrichment analysis" = 2),
                                         selected = 1)
                           ),
                           #actionButton("rundemopath", "Use Demo Data"),
                           actionButton("Run", "Run Analysis")
                         ),

                         box(title = "Analysis Result",status="warning", width = 8,
                             tabBox(id="path_tab", height= "100%", width = "100%",

                                    tabPanel("Pathway Enrichment Plot",
                                             plotlyOutput("pathplot", width = "1400px", height = "1200px"),
                                             box(
                                               downloadButton('downloadpath','Download Pathway Enrichment Figure')
                                             )),
                                    tabPanel("Pathway Enrichment Table",
                                             h4("Pathway Enrichment Analysis Table"),
                                             DT::dataTableOutput("tablepath"))
                             ))
                       )
)




#========================================#
## Pathway enrichment analysis
#========================================#
bodyManual <- tabItem(tabName = "manual",
                      fluidRow(
                        box(
                          title = "Welcome to methylR", width = 12, status = "primary",
                          div(style = "font-size:20px; color:orange",
                              HTML("<b>For non-commercial Academic and Research purpose only!</b>")
                          )),
                        fluidRow(
                          box(width = 12, status = "success",
                              title = "Some references related to methylR (Complete reference list can be found on the manual).",
                              div(style = "font-size:20px;",
                                  # tags$ol(tags$a(href = "https://academic.oup.com/bioinformatics/article/30/10/1363/267584", "1. Martin J Aryee, Andrew E Jaffe, Hector Corrada-Bravo, Christine Ladd-Acosta, Andrew P Feinberg, Kasper D Hansen, and Rafael A Irizarry. Minfi: a flexible and comprehensive bioconductor package for the analysis of infinium dna methylation microarrays. Bioinformatics, 30(10):1363–1369, 2014.", target="_blank")),
                                  tags$ol(tags$a(href = "https://www.tandfonline.com/doi/epub/10.1080/15592294.2021.1969499?needAccess=true", "1. Jyotirmoy Das, Nina Idh, Liv Ingunn Bjoner Sikkeland, Jakob Paues, and Maria Lerm. DNA methylome-based validation of induced sputum as an effective protocol to study lung immunity: construction of a classifier of pulmonary cell types. Epigenetics, pages 1–12, 2021.", target="_blank")),
                                  tags$ol(tags$a(href= "https://www.tandfonline.com/doi/full/10.1080/15592294.2019.1603963","2. Jyotirmoy Das, Deepti Verma, Mika Gustafsson, and Maria Lerm. Identification of DNA methylation patterns predisposing for an efficient response to BCG vaccination in healthy BCG-naïve subjects. Epigenetics, pages 1–13, apr 2019.", target = "_blank" )),
                                  tags$ol(tags$a(href = "https://www.biorxiv.org/content/biorxiv/early/2022/03/09/2022.03.08.483264.full.pdf", "3. H Lundquist, H Andersson, MS Chew, J Das, MV Turkina, A Welin. The Olfm4-defined human neutrophil subsets differ in proteomic profile in septic shock. bioRxiv, 2022.", target="_blank")),
                                  tags$ol(tags$a(href = "https://www.medrxiv.org/content/10.1101/2022.02.21.22271286v1.full.pdf", "4. Malgorzata Lysiak, Jyotirmoy Das, Annika Malmstroem, Peter Soderkvist.Methylome analysis for prediction of long and short-term survival in glioblastoma patients from the Nordic trial. medRxiv, 2022.", target="_blank")),
                                  tags$ol(tags$a(href = "https://www.sciencedirect.com/science/article/pii/S2352396421005405", "5. Akul Singhania, Paige Dubelko, Rebecca Kuan, William D Chronister, Kaylin Muskat, Jyotirmoy Das, Elizabeth J Phillips, Simon A Mallal, Grégory Seumois, Pandurangan Vijayanand, Alessandro Sette, Maria Lerm, Bjoern Peters, Cecilia Lindestam Arlehamn. CD4+ CCR6+ T cells dominate the BCG-induced transcriptional signature. EBioMedicine 74 (2021): 103746.", target="_blank")),
                                  tags$ol(tags$a(href = "https://www.nature.com/articles/s41598-021-98542-3.pdf", "6..Lovisa Karlsson, Jyotirmoy Das, Moa Nilsson, Amanda Tyrén, Isabelle Pehrson, Nina Idh, Shumaila Sayyab, Jakob Paues, Cesar Ugarte-Gil, Melissa Méndez-Aranda, Maria Lerm. A differential DNA methylome signature of pulmonary immune cells from individuals converting to latent tuberculosis infection. Scientific reports,2021, 11(1), 1-13.", target="_blank")),
                                  tags$ol(tags$a(href = "https://www.medrxiv.org/content/10.1101/2021.09.01.21262945v1.full.pdf", "7. Pehrson, Isabelle, Clara Braian, Lovisa Karlsson, Nina Idh, Eva Kristin Danielsson, Blanka Andersson, Jakob Paues, Jyotirmoy Das, and Maria Lerm. DNA methylation profiling of immune cells from tuberculosis-exposed individuals overlaps with BCG-induced epigenetic changes and correlates with the emergence of anti-mycobacterial'corralling cells'. medRxiv (2021)", target="_blank")),
                              ))
                        ),
                        fluidRow(
                          box(width = 12, status = "success",
                              title = "User manual",
                              div(style = "font-size:20px; color: red",
                                  tags$a(href= "https://methylr.netlify.app/intro.html", "User Manual", target = "_blank")))
                        )))

ui <- shinyUI(dashboardPage(
  title = "methylR",
  skin = "yellow",
  dashboardHeader(
    title = "methylR",
    titleWidth = 200,
    tags$li(class = "dropdown",
      tags$img(
        height = "50px", src = "logo-final.png"
      )),
    dropdownMenu(type = "messages",
        messageItem(
          from = "Developer",
          message = "Follow Us on Twitter",
          icon = icon("fa-solid fa-twitter", lib = "font-awesome"),
          href= ""
          ),
        messageItem(
          from = "Developer",
          message = "Contact us for bug-fixing",
          icon = icon("fa-solid fa-bug", lib = "font-awesome"),
          href= "mailto: methylr@googlegroups.com"
          ),
        messageItem(
          from = "Support",
          message = "Contact the developer",
          href= "mailto: methylr@googlegroups.com",
          icon = icon("life-ring")
          ),
        messageItem(
          from = "Google groups",
          #icon = icon("fa-solid fa-user-group", lib = "font-awesome"),
          message = "Get support from google groups",
          href = "https://groups.google.com/g/methylr"
        )
      ),
    dropdownMenu(type = "notifications",
      notificationItem(
        text = "Create issue at Github",
        status = "warning",
        icon("fa-brands fa-github-square", lib = "font-awesome"),
        href= "https://github.com/JD2112/methylr/issues"
        ),
      notificationItem(
        text = "Check latest version",
        icon("fa-sold fa-microchip", lib = "font-awesome"),
        status = "info",
        href= "https://github.com/JD2112/methylr/releases"
        ),
      notificationItem(
        text = "Send custom feedback",
        icon = icon("fa-solid fa-barcode", lib = "font-awesome"),
        status = "info",
        href = "https://github.com/JD2112/methylr/blob/main/images/Feedback.png"
        )
      )
  ),
  sidebar,
  dashboardBody(
    "Logged In",
    verbatimTextOutput("dataInfo"),
    tags$style(HTML(".main-sidebar { font-size: 16px!important; }
                   .treeview-menu>li>a { font-size: 16px!important; }")),
    tabItems(
      bodyHome,
      bodyMethylysis,
      bodyMDA,
      bodyVol,
      bodyChrom,
      bodyFeatures,
      bodyPairwise,
      bodyGo,
      bodyPathway,
      bodyVenn,
      bodyUpSet,
      bodyManual
    ),
    dashboardFooter(
      left = tags$div(style = "font-size: 40px; 
                          font-family: Lucida Console; 
                          color: olive", 
                tags$h5("Created with R, Shiny. Developed and Maintained by: 2022, Massimiliano Volpe and Jyotirmoy Das"),
              ),
      right = tags$img(
        height = "30px", src = "logo-red.png")
    )
  )
)
)

#source("pairwise_intersect.R")
source("pairwise_intersect.R")
server <- function(input, output, session) {
  options(shiny.maxRequestSize=1000000*1024^2)

  session$onSessionEnded(function(){
    deleteAfterDownload <- list.files("results/", pattern = "\\.txt$", full.names = TRUE)
    file.remove(deleteAfterDownload)

    deleteAfterDownload1 <- list.files("results/", pattern = "\\.pdf$", full.names = TRUE)
    file.remove(deleteAfterDownload1)

    deleteAfterDownload2 <- list.files("www/", pattern = "\\.pdf$", full.names = TRUE)
    file.remove(deleteAfterDownload2)

  }
  )
# track_usage(storage_mode = store_json(path = "."))

#   output$res <- renderText({
#     paste("You've selected:", input$tabs)
#   })
#   values <- reactiveValues(authenticated = FALSE)

#   # Return the UI for a modal dialog with data selection input. If 'failed' 
#   # is TRUE, then display a message that the previous value was invalid.
#   dataModal <- function(failed = FALSE) {
#     modalDialog(
#       tags$script(HTML(js)),
#       textInput("username", "Username:"),
#       passwordInput("password", "Password:"),
#       footer = tagList(
#         # modalButton("Cancel"),
#         actionButton("ok", "OK")
#       )
#     )
#   }

#   # Show modal when button is clicked.  
#   # This `observe` is suspended only whith right user credential

#   obs1 <- observe({
#     showModal(dataModal(
#     ))
#   })

#   # When OK button is pressed, attempt to authenticate. If successful,
#   # remove the modal. 

#   obs2 <- observe({
#     req(input$ok)
#     isolate({
#       Username <- input$username
#       Password <- input$password
#     })
#     Id_username <- which(my_username == Username)
#     Id_password <- which(my_password == Password)
#     if (length(Id_username) > 0 & length(Id_password) > 0) {
#       if (Id_username == Id_password) {
#         Logged <<- TRUE
#         values$authenticated <- TRUE
#         obs1$suspend()
#         removeModal()

#       } else {
#         values$authenticated <- FALSE
#       }     
#     }
#   })


#   output$dataInfo <- renderPrint({
#     if(values$authenticated){
#       "You are authenticated"
#     } else {
#       "You are NOT authenticated"
#     }
#   })
  
  #====================================================#
  ## methylysis module ####
  #====================================================#
  # methylation analysis
  shinyDirChoose(
    input,
    'directory',
    roots = c(home = '~'),
    filetypes = c('', 'txt', 'bigWig', "tsv", "csv", "bw")
  )

  global <- reactiveValues(datapath = getwd())
  dir <- reactive(input$directory)
  output$directory <- renderText({
    global$datapath
  })

observeEvent(input$analysisType, {
  updateTabsetPanel(session, "methylysisType",
    selected = input$analysisType)
})

  observeEvent(ignoreNULL = TRUE,
               eventExpr = {
                 input$directory
               },
               handlerExpr = {
                 if (!"path" %in% names(dir())) return()
                 home <- normalizePath("~")
                 global$datapath <-
                   file.path(home, paste(unlist(dir()$path[-1]), collapse = .Platform$file.sep))

                 illuminaArray <- eventReactive(input$runMethylysis, {
                   switch(input$arrayType,
                          "Illumina HumanMethylation450K" = 2,
                          "Illumina HumanMethylationEPIC" = 3)
                 })
                if(input$analysisType == 1){
                  #disable("minfi")
                 if(input$arrayType == "3"){
                   methylysisEPIC <- function(){
                   suppressMessages(suppressWarnings(library(ChAMP)))
                   id_methylysis_epic <- showNotification("Computing methylysis, please wait...", duration = NULL, closeButton = FALSE)
                   on.exit(removeNotification(id_methylysis_epic), add = TRUE)

                     #myLoad_EPIC <- champ.load(global$datapath)
                     myLoad_EPIC <- champ.load(global$datapath, arraytype="EPIC")
                     # running quality control of the sample
                     champ.QC(beta = myLoad_EPIC$beta,
                              pheno = myLoad_EPIC$pd$Sample_Group,
                              mdsPlot = TRUE,
                              densityPlot = TRUE,
                              dendrogram = TRUE,
                              PDFplot = TRUE,
                              Rplot = TRUE,
                              Feature.sel = "None",
                              resultsDir = "./results/")
                     # running BMIQ normalization
                     myNorm_EPIC <- champ.norm(beta=myLoad_EPIC$beta, rgSet=myLoad_EPIC$rgSet,
                                               mset=myLoad$mset,
                                               resultsDir="./results/",
                                               method= input$normalization,
                                               #plotBMIQ=TRUE,
                                               arraytype="EPIC",
                                               cores= input$cores)
                     write.table(myNorm_EPIC, file = file.path(global$datapath,"myNorm_EPIC.txt"),
                                 sep = "\t", quote =FALSE)

                     write.table(myNorm_EPIC, file = "./results/myNorm_EPIC.txt",
                                 sep = "\t", quote =FALSE)                                 
                    
                    
                    if(input$batchEffect == TRUE){
                     # calculating the batch effects
                     myCombat_EPIC <- champ.runCombat(beta=myNorm_EPIC,
                                                      pd=myLoad_EPIC$pd,
                                                      batchname=c("Array"))

                     # Calculating the differentially methylated CpGs at BH ≤ 0.05
                     myDMC.EPIC <- champ.DMP(beta = myCombat_EPIC,
                                             pheno = myLoad_EPIC$pd$Sample_Group,
                                             #compare.group = NULL,
                                             adjPVal = input$adjpval,
                                             adjust.method = "BH",
                                             arraytype = "EPIC")
                     write.table(myDMC.EPIC[[1]], file = file.path(global$datapath,"myDMC_EPIC_BatchCorrected.txt"),
                                 sep = "\t", quote =FALSE)

                     write.table(myDMC.EPIC[[1]], file = "./results/myDMC_EPIC_BatchCorrected.txt",
                                 sep = "\t", quote =FALSE)                                 
                     #)
                    } else if(input$batchEffect == TRUE || input$cellTypeDecon == TRUE){
                    # calculating the batch effects
                    myCombat_EPIC <- champ.runCombat(beta=myNorm_EPIC,
                                                      pd=myLoad_EPIC$pd,
                                                      batchname=c("Array"))
                    
                    # Calculate the Cell Type Heterogeneity
                    myCTD_EPIC <- champ.refbase(beta = myCombat_EPIC, arraytype = "EPIC")
                    
                    write.table(myCTD_EPIC$CellFraction, 
                                file = file.path(global$datapath,"CellFraction_EPIC.txt"),
                                sep = "\t", 
                                quote =FALSE)

                    write.table(myCTD_EPIC$CellFraction, 
                                file = "./results/CellFraction_EPIC.txt",
                                sep = "\t", 
                                quote =FALSE)                                

                    myDMC.EPIC <- champ.DMP(beta = myCTD_EPIC$CorrectedBeta,
                                             pheno = myLoad_EPIC$pd$Sample_Group,
                                             #compare.group = NULL,
                                             adjPVal = input$adjpval,
                                             adjust.method = "BH",
                                             arraytype = "EPIC")
                     write.table(myDMC.EPIC[[1]], file = file.path(global$datapath,
                                      "myDMC_EPIC_BatchCorrected_CellTypeCalculated.txt"),
                                 sep = "\t", quote =FALSE)

                     write.table(myDMC.EPIC[[1]], file = 
                                      "./results/myDMC_EPIC_BatchCorrected_CellTypeCalculated.txt",
                                 sep = "\t", quote =FALSE)
                     #)
                    } else {
                    # Calculating the differentially methylated CpGs at BH ≤ 0.05
                    myDMC.EPIC <- champ.DMP(beta = myNorm_EPIC,
                                             pheno = myLoad_EPIC$pd$Sample_Group,
                                             #compare.group = NULL,
                                             adjPVal = input$adjpval,
                                             adjust.method = "BH",
                                             arraytype = "EPIC")
                     write.table(myDMC.EPIC[[1]], file = file.path(global$datapath,"myDMC_EPIC.txt"),
                                 sep = "\t", quote =FALSE)
                     
                     write.table(myDMC.EPIC[[1]], file = "./results/myDMC_EPIC.txt",
                                 sep = "\t", quote =FALSE)
                    } 

                   }

                   methylysisEPIC()                  
                 } else if (input$arrayType == "2"){
                   methylysis450K <- function(){
                     suppressMessages(suppressWarnings(library(ChAMP)))
                     id_methylysis_bead <- showNotification("Computing methylysis, please wait ...", duration = NULL, closeButton = FALSE)
                     on.exit(removeNotification(id_methylysis_bead), add = TRUE)

                     myLoad_450K <- champ.load(global$datapath, arraytype="450K")
                     # running quality control of the sample
                     champ.QC(beta = myLoad_450K$beta,
                              pheno = myLoad_450K$pd$Sample_Group,
                              mdsPlot = TRUE,
                              densityPlot = TRUE,
                              dendrogram = TRUE,
                              PDFplot = TRUE,
                              Rplot = TRUE,
                              Feature.sel = "None",
                              resultsDir = "./results/")
                     # running BMIQ normalization
                     myNorm_450K <- champ.norm(beta=myLoad_450K$beta, rgSet=myLoad_450K$rgSet,
                                               mset=myLoad_450K$mset,
                                               resultsDir="./results/", 
                                               method=input$normalization,
                                               #plotBMIQ=TRUE,
                                               arraytype="450K",
                                               cores=input$cores)
                     write.table(myNorm_450K, file = file.path(global$datapath,"myNorm_450K.txt"),
                                 sep = "\t", quote =FALSE)
                     write.table(myNorm_450K, file = "./results/myNorm_450K.txt",
                                 sep = "\t", quote =FALSE)

                    if(input$batchEffect == TRUE){
                     # calculating the batch effects
                     myCombat_450K <- champ.runCombat(beta=myNorm_450K,
                                                      pd=myNorm_450K$pd,
                                                      batchname=c("Array"))

                     # Calculating the differentially methylated CpGs at BH ≤ 0.05
                     myDMC.450K <- champ.DMP(beta = myCombat_450K,
                                             pheno = myLoad_450K$pd$Sample_Group,
                                             #compare.group = NULL,
                                             adjPVal = input$adjpval,
                                             adjust.method = "BH",
                                             arraytype = "450K")
                     write.table(myDMC.450K[[1]], file = file.path(global$datapath,"myDMC_450K_BatchCorrected.txt"),
                                 sep = "\t", quote =FALSE)
                     write.table(myNorm_450K, file = "./results/myDMC_450K_BatchCorrected.txt",
                                 sep = "\t", quote =FALSE)
                     #)
                    } else if(input$batchEffect == TRUE || input$cellTypeDecon == TRUE){
                    # calculating the batch effects
                    myCombat_450K <- champ.runCombat(beta=myNorm_450K,
                                                      pd=myLoad_450K$pd,
                                                      batchname=c("Array"))
                    
                    # Calculate the Cell Type Heterogeneity
                    myCTD_450K <- champ.refbase(beta = myCombat_450K, arraytype = "450K")
                    
                    write.table(myCTD_450K$CellFraction, 
                                file = file.path(global$datapath,"CellFraction_450K.txt"),
                                sep = "\t", 
                                quote =FALSE)

                    write.table(myCTD_450K$CellFraction, 
                                file = "./results/CellFraction_450K.txt",
                                sep = "\t", 
                                quote =FALSE)

                    myDMC.450K <- champ.DMP(beta = myCTD_450K$CorrectedBeta,
                                             pheno = myLoad_450K$pd$Sample_Group,
                                             #compare.group = NULL,
                                             adjPVal = input$adjpval,
                                             adjust.method = "BH",
                                             arraytype = "450K")
                     write.table(myDMC.450K[[1]], file = file.path(global$datapath,
                                      "myDMC_450K_BatchCorrected_CellTypeCalculated.txt"),
                                 sep = "\t", quote =FALSE)

                     write.table(myDMC.450K[[1]], file = "./results/myDMC_450K_BatchCorrected_CellTypeCalculated.txt",
                                 sep = "\t", quote =FALSE)                            
                     #)
                    } else {
                    # Calculating the differentially methylated CpGs at BH ≤ 0.05
                    myDMC.450K <- champ.DMP(beta = myNorm_450K,
                                             pheno = myLoad_450K$pd$Sample_Group,
                                             #compare.group = NULL,
                                             adjPVal = input$adjpval,
                                             adjust.method = "BH",
                                             arraytype = "450KC")
                     write.table(myDMC.450K[[1]], file = file.path(global$datapath,"myDMC_450K.txt"),
                                 sep = "\t", quote =FALSE)

                     write.table(myDMC.450K[[1]], file = "./results/myDMC_450K.txt",
                                 sep = "\t", quote =FALSE)
                    } 
                   }
                   methylysis450K()
                 } else {
                   methylysis27K <- function(){}
                   methylysis27K()
                 }
                } else {
                # read annotation files
                # setup the annotation file for EPIC data
                  minfi <- function(){
                  id_methylysis_minfi <- showNotification("Computing methylysis, please wait ...", duration = NULL, closeButton = FALSE)
                  on.exit(removeNotification(id_methylysis_minfi), add = TRUE)
                  suppressMessages(suppressWarnings(c(library(limma),
                                library(minfi), 
                                library(IlluminaHumanMethylation450kanno.ilmn12.hg19), 
                                library(IlluminaHumanMethylation450kmanifest), 
                                library(RColorBrewer),
                                library(missMethyl),
                                library(matrixStats),
                                library(minfiData),
                                library(Gviz),
                                library(DMRcate),
                                library(stringr),
                                library(RCurl),
                                library(IlluminaHumanMethylationEPICanno.ilm10b5.hg38))))
                  
                  
                    if(input$anno == "hg38"){
                    anno <- getAnnotation(IlluminaHumanMethylationEPICanno.ilm10b5.hg38)
                    annote <- as.data.frame(anno@listData)
                  } else {
                    anno <- getAnnotation(IlluminaHumanMethylation450kanno)
                    annote <- as.data.frame(anno@listData)
                  }
                  
                  #annota <- annot@listData
                  
                  pal = brewer.pal(8,"Dark2")

                # read sample file
                  dataDir <- setwd(global$datapath)
                  targets <- read.metharray.sheet(global$datapath, pattern="Sample_sheet.csv")
                  rgSet <- read.metharray.exp(targets=targets)
                  targets$ID <- paste(targets$Sample_Group,targets$Sample_Name,sep=".")
                  sampleNames(rgSet) <- targets$ID

                # Quality Control of the dataset
                  detP <- detectionP(rgSet)
                  qcReport(rgSet, sampNames=targets$ID, sampGroups=targets$Sample_Group,
                            pdf="qcReport_minfi.pdf")
                  keep <- colMeans(detP) < 0.05
                  rgSet <- rgSet[,keep]
                  targets <- targets[keep,]
                  detP <- detP[,keep]

                # data normalization
                # problem lies here --mSet cannot be function
                if(input$preprocess == "preprocessRaw"){
                  mSetSq <- preprocessRaw(rgSet)
                  detP <- detP[match(featureNames(mSetSq),rownames(detP)),]

                    # remove any probes that have failed in one or more samples
                  keep <- rowSums(detP < 0.01) == ncol(mSetSq) 
                  mSetFlt <- mSetSq[keep,]

                    # filteration
                # filtering the Y chromosome only from the sample
                if(input$dropxy == TRUE){
                  library(Biobase)
                  keep <- !(Biobase::featureNames(mSetFlt) %in% annot$Name[annot$chr %in% 
                                                          c("chrX","chrY")])
                  mSetFlt <- mSetFlt[keep,]
                } else if(input$dropsnps == TRUE){
                  # remove known snp data from the sample
                  mSetFlt <- dropLociWithSnps(mSetFlt)
                } else if (input$nsp){
                  library(Biobase)
                  # removing the non-specific probes from samples
                  ## first remove the 450K non-specific probes
                  nsp <- getURL("https://raw.githubusercontent.com/sirselim/illumina450k_filtering/master/48639-non-specific-probes-Illumina450k.csv")
                  xReactiveProbes <- read.csv(text = nsp)
                  keep <- !(Biobase::featureNames(mSetFlt) %in% xReactiveProbes$TargetID)
                  mSetFlt <- mSetFlt[keep,]
                  
                  # then remove the non-specific probes for EPIC
                  #nspEPIC <- getURL("https://raw.githubusercontent.com/sirselim/illumina450k_filtering/master/EPIC/13059_2016_1066_MOESM5_ESM.csv")
                  #xReactiveProbesEPIC <- read.csv(text = nspEPIC)
                  #keep <- !(featureNames(mSetSqFlt) %in% xReactiveProbesEPIC$TargetID)
                  #mSetSqFlt <- mSetSqFlt[keep,]
                }

                # calculate the methylation and beta values
                mVals <- getM(mSetFlt)
                write.table(mVals, file= file.path(global$datapath,"mVals_minfi.txt"), 
                            sep="\t", quote = FALSE)

                bVals <- getBeta(mSetFlt)
                write.table(bVals, file= file.path(gloabl$datapath,"bVals_minfi.txt"), 
                            sep="\t", quote = FALSE)

                # this is the factor of interest
                group <- factor(targets$Sample_Group)
                 # this is the individual effect that we need to account for
                slide <- factor(targets$Slide) 

                # use the above to create a design matrix
                 design <- model.matrix(~0+group, data=targets)
                #colnames(design) <- c(levels(group),levels(slide)[-1])
                colnames(design) <- c(levels(group))
                # fit the linear model 
                fit <- lmFit(mVals, design)
                # create a contrast matrix for specific comparisons
                contMatrix <- makeContrasts(group1vsgroup2 = input$group1 - input$group2, levels = design)
                fit2 <- contrasts.fit(fit, contMatrix)
                fit2 <- eBayes(fit2)
               # look at the numbers of DM CpGs at FDR < 0.05
                summary(decideTests(fit2))
                topTable(fit2, adjust.method = "BH")
    
    
                #annoEPIC <- as.data.frame(annEPIC)
                annotSub <- annot[match(rownames(bVals),annot$Name),
                        c(1:4,12:19,24:ncol(annot))]
                DMCs.groups.ann <- topTable(fit2, 
                            num = Inf, 
                            coef = 1, 
                            genelist = annotSub)
                            
                write.table(DMCs.groups.ann, file= file.path(global$datapath,"DMCtable_minfi.txt"),
                            sep = "\t",
                            quote = FALSE)
                  } else if (input$preprocess == "preprocessSWAN"){
                    mSetSq <- preprocessSWAN(rgSet)
                    mSetSq <- preprocessRaw(rgSet)
                  detP <- detP[match(featureNames(mSetSq),rownames(detP)),]

                    # remove any probes that have failed in one or more samples
                  keep <- rowSums(detP < 0.01) == ncol(mSetSq) 
                  mSetFlt <- mSetSq[keep,]

                    # filteration
                # filtering the Y chromosome only from the sample
                if(input$dropxy == TRUE){
                  library(Biobase)
                  keep <- !(Biobase::featureNames(mSetFlt) %in% annot$Name[annot$chr %in% 
                                                          c("chrX","chrY")])
                  mSetFlt <- mSetFlt[keep,]
                } else if(input$dropsnps == TRUE){
                  # remove known snp data from the sample
                  mSetFlt <- dropLociWithSnps(mSetFlt)
                } else if (input$nsp){
                  library(Biobase)
                  # removing the non-specific probes from samples
                  ## first remove the 450K non-specific probes
                  nsp <- getURL("https://raw.githubusercontent.com/sirselim/illumina450k_filtering/master/48639-non-specific-probes-Illumina450k.csv")
                  xReactiveProbes <- read.csv(text = nsp)
                  keep <- !(Biobase::featureNames(mSetFlt) %in% xReactiveProbes$TargetID)
                  mSetFlt <- mSetFlt[keep,]
                  
                  # then remove the non-specific probes for EPIC
                  #nspEPIC <- getURL("https://raw.githubusercontent.com/sirselim/illumina450k_filtering/master/EPIC/13059_2016_1066_MOESM5_ESM.csv")
                  #xReactiveProbesEPIC <- read.csv(text = nspEPIC)
                  #keep <- !(featureNames(mSetSqFlt) %in% xReactiveProbesEPIC$TargetID)
                  #mSetSqFlt <- mSetSqFlt[keep,]
                }

                # calculate the methylation and beta values
                mVals <- getM(mSetFlt)
                write.table(mVals, file= file.path(global$datapath,"mVals_minfi.txt"), 
                            sep="\t", quote = FALSE)

                bVals <- getBeta(mSetFlt)
                write.table(bVals, file= file.path(gloabl$datapath,"bVals_minfi.txt"), 
                            sep="\t", quote = FALSE)

                # this is the factor of interest
                group <- factor(targets$Sample_Group)
                 # this is the individual effect that we need to account for
                slide <- factor(targets$Slide) 

                # use the above to create a design matrix
                 design <- model.matrix(~0+group, data=targets)
                #colnames(design) <- c(levels(group),levels(slide)[-1])
                colnames(design) <- c(levels(group))
                # fit the linear model 
                fit <- lmFit(mVals, design)
                # create a contrast matrix for specific comparisons
                contMatrix <- makeContrasts(group1vsgroup2 = input$group1 - input$group2, levels = design)
                fit2 <- contrasts.fit(fit, contMatrix)
                fit2 <- eBayes(fit2)
               # look at the numbers of DM CpGs at FDR < 0.05
                summary(decideTests(fit2))
                topTable(fit2, adjust.method = "BH")
    
    
                #annoEPIC <- as.data.frame(annEPIC)
                annotSub <- annot[match(rownames(bVals),annot$Name),
                        c(1:4,12:19,24:ncol(annot))]
                DMCs.groups.ann <- topTable(fit2, 
                            num = Inf, 
                            coef = 1, 
                            genelist = annotSub)
                            
                write.table(DMCs.groups.ann, file= file.path(global$datapath,"DMCtable_minfi.txt"),
                            sep = "\t",
                            quote = FALSE)
                  } else if(input$preprocess == "preprocessQuantile"){
                    mSeqSq <- preprocessQuantile(rgSet)
                    mSetSq <- preprocessRaw(rgSet)
                  detP <- detP[match(featureNames(mSetSq),rownames(detP)),]

                    # remove any probes that have failed in one or more samples
                  keep <- rowSums(detP < 0.01) == ncol(mSetSq) 
                  mSetFlt <- mSetSq[keep,]

                    # filteration
                # filtering the Y chromosome only from the sample
                if(input$dropxy == TRUE){
                  library(Biobase)
                  keep <- !(Biobase::featureNames(mSetFlt) %in% annot$Name[annot$chr %in% 
                                                          c("chrX","chrY")])
                  mSetFlt <- mSetFlt[keep,]
                } else if(input$dropsnps == TRUE){
                  # remove known snp data from the sample
                  mSetFlt <- dropLociWithSnps(mSetFlt)
                } else if (input$nsp){
                  library(Biobase)
                  # removing the non-specific probes from samples
                  ## first remove the 450K non-specific probes
                  nsp <- getURL("https://raw.githubusercontent.com/sirselim/illumina450k_filtering/master/48639-non-specific-probes-Illumina450k.csv")
                  xReactiveProbes <- read.csv(text = nsp)
                  keep <- !(Biobase::featureNames(mSetFlt) %in% xReactiveProbes$TargetID)
                  mSetFlt <- mSetFlt[keep,]
                  
                  # then remove the non-specific probes for EPIC
                  #nspEPIC <- getURL("https://raw.githubusercontent.com/sirselim/illumina450k_filtering/master/EPIC/13059_2016_1066_MOESM5_ESM.csv")
                  #xReactiveProbesEPIC <- read.csv(text = nspEPIC)
                  #keep <- !(featureNames(mSetSqFlt) %in% xReactiveProbesEPIC$TargetID)
                  #mSetSqFlt <- mSetSqFlt[keep,]
                }

                # calculate the methylation and beta values
                mVals <- getM(mSetFlt)
                write.table(mVals, file= file.path(global$datapath,"mVals_minfi.txt"), 
                            sep="\t", quote = FALSE)

                bVals <- getBeta(mSetFlt)
                write.table(bVals, file= file.path(gloabl$datapath,"bVals_minfi.txt"), 
                            sep="\t", quote = FALSE)

                # this is the factor of interest
                group <- factor(targets$Sample_Group)
                 # this is the individual effect that we need to account for
                slide <- factor(targets$Slide) 

                # use the above to create a design matrix
                 design <- model.matrix(~0+group, data=targets)
                #colnames(design) <- c(levels(group),levels(slide)[-1])
                colnames(design) <- c(levels(group))
                # fit the linear model 
                fit <- lmFit(mVals, design)
                # create a contrast matrix for specific comparisons
                contMatrix <- makeContrasts(group1vsgroup2 = input$group1 - input$group2, levels = design)
                fit2 <- contrasts.fit(fit, contMatrix)
                fit2 <- eBayes(fit2)
               # look at the numbers of DM CpGs at FDR < 0.05
                summary(decideTests(fit2))
                topTable(fit2, adjust.method = "BH")
    
    
                #annoEPIC <- as.data.frame(annEPIC)
                annotSub <- annot[match(rownames(bVals),annot$Name),
                        c(1:4,12:19,24:ncol(annot))]
                DMCs.groups.ann <- topTable(fit2, 
                            num = Inf, 
                            coef = 1, 
                            genelist = annotSub)
                            
                write.table(DMCs.groups.ann, file= file.path(global$datapath,"DMCtable_minfi.txt"),
                            sep = "\t",
                            quote = FALSE)
                  } else if (input$preprocess == "preprocessNoob"){
                    mSetSq <- preprocessNoob(rgSet)
                    mSetSq <- preprocessRaw(rgSet)
                  detP <- detP[match(featureNames(mSetSq),rownames(detP)),]

                    # remove any probes that have failed in one or more samples
                  keep <- rowSums(detP < 0.01) == ncol(mSetSq) 
                  mSetFlt <- mSetSq[keep,]

                    # filteration
                # filtering the Y chromosome only from the sample
                if(input$dropxy == TRUE){
                  library(Biobase)
                  keep <- !(Biobase::featureNames(mSetFlt) %in% annot$Name[annot$chr %in% 
                                                          c("chrX","chrY")])
                  mSetFlt <- mSetFlt[keep,]
                } else if(input$dropsnps == TRUE){
                  # remove known snp data from the sample
                  mSetFlt <- dropLociWithSnps(mSetFlt)
                } else if (input$nsp){
                  library(Biobase)
                  # removing the non-specific probes from samples
                  ## first remove the 450K non-specific probes
                  nsp <- getURL("https://raw.githubusercontent.com/sirselim/illumina450k_filtering/master/48639-non-specific-probes-Illumina450k.csv")
                  xReactiveProbes <- read.csv(text = nsp)
                  keep <- !(Biobase::featureNames(mSetFlt) %in% xReactiveProbes$TargetID)
                  mSetFlt <- mSetFlt[keep,]
                  
                  # then remove the non-specific probes for EPIC
                  #nspEPIC <- getURL("https://raw.githubusercontent.com/sirselim/illumina450k_filtering/master/EPIC/13059_2016_1066_MOESM5_ESM.csv")
                  #xReactiveProbesEPIC <- read.csv(text = nspEPIC)
                  #keep <- !(featureNames(mSetSqFlt) %in% xReactiveProbesEPIC$TargetID)
                  #mSetSqFlt <- mSetSqFlt[keep,]
                }

                # calculate the methylation and beta values
                mVals <- getM(mSetFlt)
                write.table(mVals, file= file.path(global$datapath,"mVals_minfi.txt"), 
                            sep="\t", quote = FALSE)

                bVals <- getBeta(mSetFlt)
                write.table(bVals, file= file.path(gloabl$datapath,"bVals_minfi.txt"), 
                            sep="\t", quote = FALSE)

                # this is the factor of interest
                group <- factor(targets$Sample_Group)
                 # this is the individual effect that we need to account for
                slide <- factor(targets$Slide) 

                # use the above to create a design matrix
                 design <- model.matrix(~0+group, data=targets)
                #colnames(design) <- c(levels(group),levels(slide)[-1])
                colnames(design) <- c(levels(group))
                # fit the linear model 
                fit <- lmFit(mVals, design)
                # create a contrast matrix for specific comparisons
                contMatrix <- makeContrasts(group1vsgroup2 = input$group1 - input$group2, levels = design)
                fit2 <- contrasts.fit(fit, contMatrix)
                fit2 <- eBayes(fit2)
               # look at the numbers of DM CpGs at FDR < 0.05
                summary(decideTests(fit2))
                topTable(fit2, adjust.method = "BH")
    
    
                #annoEPIC <- as.data.frame(annEPIC)
                annotSub <- annot[match(rownames(bVals),annot$Name),
                        c(1:4,12:19,24:ncol(annot))]
                DMCs.groups.ann <- topTable(fit2, 
                            num = Inf, 
                            coef = 1, 
                            genelist = annotSub)
                            
                write.table(DMCs.groups.ann, file= file.path(global$datapath,"DMCtable_minfi.txt"),
                            sep = "\t",
                            quote = FALSE)
                  } else if (input$preprocess == "preprocessIllumina"){
                    mSetSq <- preprocessIllumina(rgSet)
                    mSetSq <- preprocessRaw(rgSet)
                  detP <- detP[match(featureNames(mSetSq),rownames(detP)),]

                    # remove any probes that have failed in one or more samples
                  keep <- rowSums(detP < 0.01) == ncol(mSetSq) 
                  mSetFlt <- mSetSq[keep,]

                    # filteration
                # filtering the Y chromosome only from the sample
                if(input$dropxy == TRUE){
                  library(Biobase)
                  keep <- !(Biobase::featureNames(mSetFlt) %in% annot$Name[annot$chr %in% 
                                                          c("chrX","chrY")])
                  mSetFlt <- mSetFlt[keep,]
                } else if(input$dropsnps == TRUE){
                  # remove known snp data from the sample
                  mSetFlt <- dropLociWithSnps(mSetFlt)
                } else if (input$nsp){
                  library(Biobase)
                  # removing the non-specific probes from samples
                  ## first remove the 450K non-specific probes
                  nsp <- getURL("https://raw.githubusercontent.com/sirselim/illumina450k_filtering/master/48639-non-specific-probes-Illumina450k.csv")
                  xReactiveProbes <- read.csv(text = nsp)
                  keep <- !(Biobase::featureNames(mSetFlt) %in% xReactiveProbes$TargetID)
                  mSetFlt <- mSetFlt[keep,]
                  
                  # then remove the non-specific probes for EPIC
                  #nspEPIC <- getURL("https://raw.githubusercontent.com/sirselim/illumina450k_filtering/master/EPIC/13059_2016_1066_MOESM5_ESM.csv")
                  #xReactiveProbesEPIC <- read.csv(text = nspEPIC)
                  #keep <- !(featureNames(mSetSqFlt) %in% xReactiveProbesEPIC$TargetID)
                  #mSetSqFlt <- mSetSqFlt[keep,]
                }

                # calculate the methylation and beta values
                mVals <- getM(mSetFlt)
                write.table(mVals, file= file.path(global$datapath,"mVals_minfi.txt"), 
                            sep="\t", quote = FALSE)

                bVals <- getBeta(mSetFlt)
                write.table(bVals, file= file.path(gloabl$datapath,"bVals_minfi.txt"), 
                            sep="\t", quote = FALSE)

                # this is the factor of interest
                group <- factor(targets$Sample_Group)
                 # this is the individual effect that we need to account for
                slide <- factor(targets$Slide) 

                # use the above to create a design matrix
                 design <- model.matrix(~0+group, data=targets)
                #colnames(design) <- c(levels(group),levels(slide)[-1])
                colnames(design) <- c(levels(group))
                # fit the linear model 
                fit <- lmFit(mVals, design)
                # create a contrast matrix for specific comparisons
                contMatrix <- makeContrasts(group1vsgroup2 = input$group1 - input$group2, levels = design)
                fit2 <- contrasts.fit(fit, contMatrix)
                fit2 <- eBayes(fit2)
               # look at the numbers of DM CpGs at FDR < 0.05
                summary(decideTests(fit2))
                topTable(fit2, adjust.method = "BH")
    
    
                #annoEPIC <- as.data.frame(annEPIC)
                annotSub <- annot[match(rownames(bVals),annot$Name),
                        c(1:4,12:19,24:ncol(annot))]
                DMCs.groups.ann <- topTable(fit2, 
                            num = Inf, 
                            coef = 1, 
                            genelist = annotSub)
                            
                write.table(DMCs.groups.ann, file= file.path(global$datapath,"DMCtable_minfi.txt"),
                            sep = "\t",
                            quote = FALSE)
                  } else {
                    mSetSq <- preprocessFunnorm(rgSet)
                    mSetSq <- preprocessRaw(rgSet)
                  detP <- detP[match(featureNames(mSetSq),rownames(detP)),]

                    # remove any probes that have failed in one or more samples
                  keep <- rowSums(detP < 0.01) == ncol(mSetSq) 
                  mSetFlt <- mSetSq[keep,]

                    # filteration
                # filtering the Y chromosome only from the sample
                if(input$dropxy == TRUE){
                  library(Biobase)
                  keep <- !(Biobase::featureNames(mSetFlt) %in% annot$Name[annot$chr %in% 
                                                          c("chrX","chrY")])
                  mSetFlt <- mSetFlt[keep,]
                } else if(input$dropsnps == TRUE){
                  # remove known snp data from the sample
                  mSetFlt <- dropLociWithSnps(mSetFlt)
                } else if (input$nsp){
                  library(Biobase)
                  # removing the non-specific probes from samples
                  ## first remove the 450K non-specific probes
                  nsp <- getURL("https://raw.githubusercontent.com/sirselim/illumina450k_filtering/master/48639-non-specific-probes-Illumina450k.csv")
                  xReactiveProbes <- read.csv(text = nsp)
                  keep <- !(Biobase::featureNames(mSetFlt) %in% xReactiveProbes$TargetID)
                  mSetFlt <- mSetFlt[keep,]
                  
                  # then remove the non-specific probes for EPIC
                  #nspEPIC <- getURL("https://raw.githubusercontent.com/sirselim/illumina450k_filtering/master/EPIC/13059_2016_1066_MOESM5_ESM.csv")
                  #xReactiveProbesEPIC <- read.csv(text = nspEPIC)
                  #keep <- !(featureNames(mSetSqFlt) %in% xReactiveProbesEPIC$TargetID)
                  #mSetSqFlt <- mSetSqFlt[keep,]
                }

                # calculate the methylation and beta values
                mVals <- getM(mSetFlt)
                write.table(mVals, file= file.path(global$datapath,"mVals_minfi.txt"), 
                            sep="\t", quote = FALSE)

                bVals <- getBeta(mSetFlt)
                write.table(bVals, file= file.path(gloabl$datapath,"bVals_minfi.txt"), 
                            sep="\t", quote = FALSE)

                # this is the factor of interest
                group <- factor(targets$Sample_Group)
                 # this is the individual effect that we need to account for
                slide <- factor(targets$Slide) 

                # use the above to create a design matrix
                 design <- model.matrix(~0+group, data=targets)
                #colnames(design) <- c(levels(group),levels(slide)[-1])
                colnames(design) <- c(levels(group))
                # fit the linear model 
                fit <- lmFit(mVals, design)
                # create a contrast matrix for specific comparisons
                contMatrix <- makeContrasts(group1vsgroup2 = input$group1 - input$group2, levels = design)
                fit2 <- contrasts.fit(fit, contMatrix)
                fit2 <- eBayes(fit2)
               # look at the numbers of DM CpGs at FDR < 0.05
                summary(decideTests(fit2))
                topTable(fit2, adjust.method = "BH")
    
    
                #annoEPIC <- as.data.frame(annEPIC)
                annotSub <- annot[match(rownames(bVals),annot$Name),
                        c(1:4,12:19,24:ncol(annot))]
                DMCs.groups.ann <- topTable(fit2, 
                            num = Inf, 
                            coef = 1, 
                            genelist = annotSub)
                            
                write.table(DMCs.groups.ann, file= file.path(global$datapath,"DMCtable_minfi.txt"),
                            sep = "\t",
                            quote = FALSE)
                  }
                
                
              }
              minfi()
            }

# ## auto reload session, if error occurs
# datModal <- function(failed = FALSE) {
#   modalDialog(
#     textInput("Run Failed! Please select different parameters"),
#     footer = tagList(
#       modalButton("Reload App"),
#       actionButton(session$reload(), "OK")
#     )
#   )
# }   

#   observeEvent(input$directory, {
#     withCallingHandlers(
#       methylysisEPIC(),
#       messsage = function(m) {
#         shinyjs::html("console", m$message, TRUE)
#       }
#     )
#   })


##=========================##
# QC result ouput
##=========================##

              observeEvent(input$qcgenerate, {
                illuminaArray <- reactive({
                     switch(input$arrayType,
                            "Illumina HumanMethylation450K" = 2,
                            "Illumina HumanMethylationEPIC" = 3)
                   })

                if(input$arrayType == "3"){
                qpdf::pdf_combine(input = c("./results/raw_densityPlot.pdf", 
                                            "./results/raw_mdsPlot.pdf",
                                            "./results/raw_SampleCluster.pdf"),
                                  #output = "app/www/qc_results.pdf") ##Check if required for Docker container
                                  output = "www/qc_results.pdf")

                output$qcview <- renderUI({
                  tags$iframe(style="height:600px; width:100%", src="qc_results.pdf")
                  })
                } else {
                qpdf::pdf_combine(input = c("./results/raw_densityPlot.pdf", 
                                            "./results/raw_mdsPlot.pdf",
                                            "./results/raw_SampleCluster.pdf"),
                                  output = "www/qc_results.pdf")

                output$qcview <- renderUI({
                  tags$iframe(style="height:600px; width:100%", src="qc_results.pdf")
                  })
                }
                })
                
##====================================##
# CellType Deconvolution result ouput
##====================================##
                decon_size <- reactive({
                  return(input$decon_size)
                })


                figure_cell_EPIC <- eventReactive(input$decongenerate,{
                file.copy(file.path(global$datapath,"CellFraction_EPIC.txt"), "app/www/CellFraction_EPIC.txt")

                celltypedecon <- read.delim("app/www/CellFraction_EPIC.txt", sep = "\t", header = TRUE)

              
                figure_cell_EPIC <- boxplot(celltypedecon,
                                col = c("#1F968BFF", "#1F968BFF", "#55C667FF", "#440154FF", "#FDE725FF", "#2FE89447"),
                                #notch = TRUE
                                main = "Cell Type Deconvolution Plot",
                                xlab = "Different PBMC cells",
                                ylab = "Cell type proportion")

                figure_cell_EPIC
                })

                figure_cell_450K <- eventReactive(input$decongenerate,{
                file.copy(file.path(global$datapath,"CellFraction_450K.txt"), "app/www/CellFraction_450K.txt")

                celltypedecon <- read.delim("app/www/CellFraction_450K.txt", sep = "\t", header = TRUE)

              
                figure_cell_450K <- boxplot(celltypedecon,
                                col = c("#1F968BFF", "#1F968BFF", "#55C667FF", "#440154FF", "#FDE725FF", "#2FE89447"),
                                #notch = TRUE
                                main = "Cell Type Deconvolution Plot",
                                xlab = "Different PBMC cells",
                                ylab = "Cell type proportion")

                figure_cell_450K
                })
                
                output$deconvPlot <- renderPlot({
                  graphics.off()
                  par("mar")
                  par(mar=c(1, 1, 1, 1))
                  if(input$arrayType == "3"){
                    figure_cell_EPIC()
                  } else {}
                  figure_cell_450K()
                },
                  width = decon_size,
                  height = decon_size,
                  outputArgs = list()
                )
                # })

##=========================##
# normalized table output
##=========================##

#normfile <- reactive()
output$normTable <- downloadHandler(
  filename = function(){
    paste("NormalizedFile", Sys.Date(), ".txt", sep = "\t")
  },
  content = function(file){
    if(input$arrayType == "3"){
    myNormlist.EPIC <- read.delim(file = file.path(global$datapath,"myNorm_EPIC.txt"), sep = "\t", header = T)
    normData <- data.frame(myNormlist.EPIC)
    write.table(normData, file, sep = "\t", quote = F)
    } else {
    myNormlist.450K <- read.delim(file = file.path(global$datapath,"myNorm_450K.txt"), sep = "\t", header = T)
    normData <- data.frame(myNormlist.450K)
    write.table(normData, file, sep = "\t", quote = F)
    }
  }
)
                 output$tabnorm <- DT::renderDataTable(server = FALSE,{

                   illuminaArray <- reactive({
                     switch(input$arrayType,
                            "Illumina HumanMethylation450K" = 2,
                            "Illumina HumanMethylationEPIC" = 3)
                   })

                   if(input$arrayType == "3"){
                     myNormlist.EPIC <- read.delim(file = file.path(global$datapath,"myNorm_EPIC.txt"), sep = "\t", header = T)
                     tableNorm <- data.frame(myNormlist.EPIC[1:100,])
                     #tableNorm <- data.frame(myNormlist.EPIC)

                     DT::datatable(
                       tableNorm,
                       extensions = 'Buttons',
                       options = list(
                         paging = TRUE,
                         searching = TRUE,
                         fixedColumns = TRUE,
                         autowidth = TRUE,
                         ordering = TRUE,
                         dom = 'Bfrtip',
                         scrollX = TRUE,
                         buttons = list(
                           list(extend = "excel", text = "Download current page", filename = "page",
                                exportOptions = list(
                                  modifier = list(page = "current")
                                )
                           ),
                           list(extend = "excel", text = "Download full result", filename = "data",
                                exportOptions = list(
                                  modifier = list(page="all")
                                ))
                         )
                       ), class = "display"
                     )} else if (input$arrayType == "2"){
                     myNormlist.450K <- read.delim(file = file.path(global$datapath,"myNorm_450K.txt"), sep = "\t", header = T)
                     tableNorm <- data.frame(myNormlist.450K[1:100,])

                     DT::datatable(
                       tableNorm,
                       extensions = 'Buttons',
                       options = list(
                         paging = TRUE,
                         searching = TRUE,
                         fixedColumns = TRUE,
                         autowidth = TRUE,
                         ordering = TRUE,
                         dom = 'Bfrtip',
                         scrollX = TRUE,
                         buttons = list(
                           list(extend = "excel", text = "Download current page", filename = "page",
                                exportOptions = list(
                                  modifier = list(page = "current")
                                )
                           ),
                           list(extend = "excel", text = "Download full result", filename = "data",
                                exportOptions = list(
                                  modifier = list(page="all")
                                ))
                         )
                       ), class = "display"
                     )} else {

                   }
                 })

##=======================================##
# differentially methylated table output
##=======================================##
output$dmcTable <- downloadHandler(
  filename = function(){
    paste("DMCFile", Sys.Date(), ".txt", sep = "\t")
  },
  content = function(file){
    if(input$arrayType == "3"){
    myDMClist.EPIC <- read.delim(file = file.path(global$datapath,"myDMC_EPIC.txt"), sep = "\t", header = T)
    dmcData <- data.frame(myDMClist.EPIC)
    write.table(dmcData, file, sep = "\t", quote = F)
    } else {
    myDMClist.450K <- read.delim(file = file.path(global$datapath,"myDMC_450K.txt"), sep = "\t", header = T)
    dmcData <- data.frame(myDMClist.450K)
    write.table(dmcData, file, sep = "\t", quote = F)
    }
  }
)
                 output$tabdmc <- DT::renderDataTable(server = FALSE,{

                   illuminaArray <- reactive({
                     switch(input$arrayType,
                            "Illumina HumanMethylation450K" = 2,
                            "Illumina HumanMethylationEPIC" = 3)
                   })

                   if(input$arrayType == "3"){
                     myDMClist.EPIC <- read.delim(file = file.path(global$datapath,"myDMC_EPIC.txt"), sep = "\t", header = T)
                     tableDMC <- myDMClist.EPIC[1:100,]

                     DT::datatable(
                       tableDMC,
                       extensions = 'Buttons',
                       options = list(
                         paging = TRUE,
                         searching = TRUE,
                         fixedColumns = TRUE,
                         autowidth = TRUE,
                         ordering = TRUE,
                         dom = 'Bfrtip',
                         scrollX = TRUE,
                         buttons = list(
                           list(extend = "excel", text = "Download current page", filename = "page",
                                exportOptions = list(
                                  modifier = list(page = "current")
                                )
                           ),
                           list(extend = "excel", text = "Download full result", filename = "data",
                                exportOptions = list(
                                  modifier = list(page="all")
                                ))
                         )
                       ), class = "display"
                     )} else if(input$arrayType == "3" || input$batchEffect == TRUE){
                     myDMClist.EPIC <- read.delim(file = file.path(global$datapath,"myDMC_EPIC_BatchCorrected.txt"), sep = "\t", header = T)
                     tableDMC <- myDMClist.EPIC[1:100,]

                     DT::datatable(
                       tableDMC,
                       extensions = 'Buttons',
                       options = list(
                         paging = TRUE,
                         searching = TRUE,
                         fixedColumns = TRUE,
                         autowidth = TRUE,
                         ordering = TRUE,
                         dom = 'Bfrtip',
                         scrollX = TRUE,
                         buttons = list(
                           list(extend = "excel", text = "Download current page", filename = "page",
                                exportOptions = list(
                                  modifier = list(page = "current")
                                )
                           ),
                           list(extend = "excel", text = "Download full result", filename = "data",
                                exportOptions = list(
                                  modifier = list(page="all")
                                ))
                         )
                       ), class = "display"
                     )} else if(input$arrayType == "3" || input$batchEffect == TRUE || input$cellTypeDecon){
                     myDMClist.EPIC <- read.delim(file = file.path(global$datapath,"myDMC_EPIC_BatchCorrected_CellTypeCalculated.txt"), sep = "\t", header = T)
                     tableDMC <- myDMClist.EPIC[1:100,]

                     DT::datatable(
                       tableDMC,
                       extensions = 'Buttons',
                       options = list(
                         paging = TRUE,
                         searching = TRUE,
                         fixedColumns = TRUE,
                         autowidth = TRUE,
                         ordering = TRUE,
                         dom = 'Bfrtip',
                         scrollX = TRUE,
                         buttons = list(
                           list(extend = "excel", text = "Download current page", filename = "page",
                                exportOptions = list(
                                  modifier = list(page = "current")
                                )
                           ),
                           list(extend = "excel", text = "Download full result", filename = "data",
                                exportOptions = list(
                                  modifier = list(page="all")
                                ))
                         )
                       ), class = "display"
                     )} else if (input$arrayType == "2"){
                     myDMClist.450K <- read.delim(file = file.path(global$datapath,"myNorm_450K.txt"), sep = "\t", header = T)
                     tableDMC <- data.frame(myDMClist.450K[1:100,])

                     DT::datatable(
                       tableDMC,
                       extensions = 'Buttons',
                       options = list(
                         paging = TRUE,
                         searching = TRUE,
                         fixedColumns = TRUE,
                         autowidth = TRUE,
                         ordering = TRUE,
                         dom = 'Bfrtip',
                         scrollX = TRUE,
                         buttons = list(
                           list(extend = "excel", text = "Download current page", filename = "page",
                                exportOptions = list(
                                  modifier = list(page = "current")
                                )
                           ),
                           list(extend = "excel", text = "Download full result", filename = "data",
                                exportOptions = list(
                                  modifier = list(page="all")
                                ))
                         )
                       ), class = "display"
                     )} else if(input$arrayType == "2" || input$batchEffect == TRUE){
                     myDMClist.450K <- read.delim(file = file.path(global$datapath,"myDMC_450K_BatchCorrected.txt"), sep = "\t", header = T)
                     tableDMC <- myDMClist.450K[1:100,]

                     DT::datatable(
                       tableDMC,
                       extensions = 'Buttons',
                       options = list(
                         paging = TRUE,
                         searching = TRUE,
                         fixedColumns = TRUE,
                         autowidth = TRUE,
                         ordering = TRUE,
                         dom = 'Bfrtip',
                         scrollX = TRUE,
                         buttons = list(
                           list(extend = "excel", text = "Download current page", filename = "page",
                                exportOptions = list(
                                  modifier = list(page = "current")
                                )
                           ),
                           list(extend = "excel", text = "Download full result", filename = "data",
                                exportOptions = list(
                                  modifier = list(page="all")
                                ))
                         )
                       ), class = "display"
                     )} else if (input$arrayType == "2" || input$batchEffect == TRUE || input$cellTypeDecon == TRUE) {
                     myDMClist.450K <- read.delim(file = file.path(global$datapath,"myDMC_450K_BatchCorrected_CellTypeCalculated.txt"), sep = "\t", header = T)
                     tableDMC <- myDMClist.450K[1:100,]

                     DT::datatable(
                       tableDMC,
                       extensions = 'Buttons',
                       options = list(
                         paging = TRUE,
                         searching = TRUE,
                         fixedColumns = TRUE,
                         autowidth = TRUE,
                         ordering = TRUE,
                         dom = 'Bfrtip',
                         scrollX = TRUE,
                         buttons = list(
                           list(extend = "excel", text = "Download current page", filename = "page",
                                exportOptions = list(
                                  modifier = list(page = "current")
                                )
                           ),
                           list(extend = "excel", text = "Download full result", filename = "data",
                                exportOptions = list(
                                  modifier = list(page="all")
                                ))
                         )
                       ), class = "display"
                       )} else {}

                 })
  }
)


#====================================================#
  ## Download all methylysis result as zip ###
#====================================================#

observeEvent(input$download_btn, {
  showModal(modalDialog(
    title = HTML('<span style="color:SteelBlue; font-size: 26px; font-weight:bold; font-family:sans-serif ">Proceed to download results<span>
              <button type = "button" class="close" data-dismiss="modal" ">
               </button> '),
    HTML('<span style="color:LightCoral; font-size: 20px; font-weight:bold; font-family:sans-serif ">NOTE: Your data will be deleted from the server once you close the browser<span>
              <button type = "button" class="close" data-dismiss="modal" ">
               </button> '),
    footer = actionButton("Confirm", "Confirm"),

    easyClose = FALSE
  ))
})

observeEvent(input$Confirm, {
    showModal(
        modalDialog(
            HTML('<span style="color:LightSeaGreen; font-size: 26px; font-weight:bold; font-family:sans-serif ">Are you sure?<span>
              <button type = "button" class="close" data-dismiss="modal" ">
               </button> '),
            footer = tagList(
                downloadButton(outputId = "download_data", "Yes"),
                modalButton("No")
            ),
            easyClose = FALSE
        )
    )
})

output$download_data <- downloadHandler(  
    filename = function(){
      paste("methylR_methylysis_result", Sys.Date(), ".zip", sep = "")
    },
    content = function(file){   
    showNotification("zipping results, please wait...", 
                      duration = 20,
                      type = "message", 
                      closeButton = TRUE)
    removeModal()

       qc_dir_450k <- "450K_QCimages"
       qc_dir_epic <- "EPIC_QCimages"

       results <- "results"

       if(file.exists(qc_dir_450k)){
         filesToSave <- c(list.files(qc_dir_450k, full.names= TRUE),
                          list.files(results, full.names = TRUE))
       } else {
         filesToSave <- c(list.files(qc_dir_epic, full.names= TRUE),
                          list.files(results, full.names = TRUE))
  
      system2("zip", args=(paste(file,filesToSave,sep=" ")))
              }
    },
      contentType = "application/zip"    
  )


#====================================================#
  ## Multi-Dimensional analysis ###
#====================================================#

  mds_size <- reactive({
    return(input$mds_size)
  })


  mdsPlot1 <- eventReactive(input$runmda, {
    id_mds <- showNotification("generating plot, please wait...", duration = NULL, closeButton = FALSE)
    on.exit(removeNotification(id_mds), add = TRUE)

    fileMDS <- input$file_mds
    ext <- tools::file_ext(fileMDS$datapath)
    req(fileMDS)

    MDSdata <- read.delim(fileMDS$datapath, sep = "\t", row.names = 1)

    #MDSdata1 <- MDSdata[1:1000,]
    MDSdata2 <- as.matrix(MDSdata)
    #return(MDSdata)
    figureMDS <- mdsPlot(MDSdata2,
                         numPositions = input$numdms,
                         sampNames = NULL,
                         sampGroups = NULL,
                         pch = 19,
                         pal = brewer.pal(8, "Dark2"),
                         legendPos = "bottomleft",
                         #legendNCol,
                         main = NULL)

    figureMDS
  })

  output$mdsPlot <- renderPlot({
    mdsPlot1()
  },
    width = mds_size,
    height = mds_size,
    outputArgs = list()
  )


  output$mdsDownload <- downloadHandler(
    filename = function(){
      paste("MDSplot", tolower(input$filetype_mds), sep =".")
    },
    content = function(file)
    {
      width  <- mds_size()
      height <- mds_size()
      #width  <- session$clientData$output_plot_width
      #height <- ((session$clientData$output_plot_height)*1)
      #pixelratio <- session$clientData$pixelratio
      pixelratio <- 2

      if(input$filetype_mds == "PNG")
        png(file, width=4, height=4, units = "in", res=300)
      else if(input$filetype_mds == "SVG")
        svg(file, width=8, height=8)
      else if(input$filetype_mds == "TIFF")
        tiff(file, width=4, height=4, units = "in", res=300)
      else
        pdf(file, width = 8, height = 8)



      fileMDS <- input$file_mds
      ext <- tools::file_ext(fileMDS$datapath)
      req(fileMDS)

      MDSdata <- read.delim(fileMDS$datapath, sep = "\t", row.names = 1)

      #MDSdata1 <- MDSdata[1:1000,]
      MDSdata2 <- as.matrix(MDSdata)
      mdsPlot(MDSdata2,
              numPositions = input$numdms,
              sampNames = NULL,
              sampGroups = NULL,
              pch = 19,
              pal = brewer.pal(8, "Dark2"),
              legendPos = "bottomleft",
              #legendNCol,
              main = NULL)

      dev.off()
    }
  )

  pcaPlot1 <- eventReactive(input$runpca,
  {
    #library(explor)
    id_pca <- showNotification("generating plot, please wait...", duration = NULL, closeButton = FALSE)
    on.exit(removeNotification(id_pca), add = TRUE)

    fileMDS <- input$file_mds
    ext <- tools::file_ext(fileMDS$datapath)
    req(fileMDS)

    MDSdata <- read.delim(fileMDS$datapath, sep = "\t", row.names = 1)

    MDSdata1 <- MDSdata[1:input$numdms,]
    data.pca <- PCA(t(MDSdata1), graph = FALSE)
    eig.val <- get_eigenvalue(data.pca)
    ind <- fviz_pca_ind(data.pca)
    var <- fviz_pca_var(data.pca)

    fileGroup <- input$group_pca
    ext <- tools::file_ext(fileGroup$datapath)
    req(fileGroup)

    groupData <- read.delim(fileGroup$datapath, sep = "\t",header = T) 
    group <- colnames(groupData)
    
    fviz_pca_ind(data.pca,
                 fill.ind = groupData$group,
                 pch = 21, pointsize = 5,
                 palette = "jco",
                 title = "Principal Component Analysis",
                 xlab = "PC1", ylab = "PC2",
                 legend.title = "Groups",
                 mean.point = FALSE,
                 repel = TRUE)

  }
  )

  output$pcaplot <- renderPlotly({
    pcaPlot1()
  })


  #=====================================================#
  #  Chromosome map analysis
  #=====================================================#
    observeEvent(input$plot, {
    chromdata <- input$chromfile
    ext <- tools::file_ext(chromdata$datapath)
    req(chromdata)
    
    chromInfile <- read.delim(chromdata$datapath, sep = "\t")
    
    chromInput <- chromInfile[abs(chromInfile['logFC']) > input$fc,]
    
    # Annotate file with CpG map information

    cpgChromoData <- cbind(chromInput$CHR,chromInput$MAPINFO,chromInput$MAPINFO +1, rownames(chromInput))
    colnames(cpgChromoData) <- c("Chrom", "Start", "End", "cpgID")
    cpgChromoData1 <- data.frame(cpgChromoData)
    cpgChromoData1$Chrom <- as.numeric(cpgChromoData1$Chrom)
    cpgChromoData1$Start <- as.numeric(cpgChromoData1$Start)
    cpgChromoData1$End <- as.numeric(cpgChromoData1$End)
    cpgChromoData1$ID <- as.character(cpgChromoData1$cpgID)
    
    # Annotate file with Gene map information
    
    geneChromoData <- cbind(chromInput$CHR,chromInput$MAPINFO,chromInput$MAPINFO +1, chromInput$gene)
    colnames(geneChromoData) <- c("Chrom", "Start", "End", "geneID")
    geneChromoData1 <- data.frame(geneChromoData)
    geneChromoData1$Chrom <- as.numeric(geneChromoData1$Chrom)
    geneChromoData1$Start <- as.numeric(geneChromoData1$Start)
    geneChromoData1$End <- as.numeric(geneChromoData1$End)
    geneChromoData1$ID <- as.character(geneChromoData1$geneID)
    
    output$myChromoMap <- renderPlot({
      #chromPlot(gaps = chromTable)
      
      chromPlot(gaps=hg_gap, 
                bands=hg_cytoBandIdeo, 
                stat=geneChromoData1,
                stat2 = cpgChromoData1,
                statCol="Value",
                statName="Value", 
                statCol2 = "Value",
                statName2 = "Value",
                noHist=FALSE, 
                figCols=4, 
                cex=input$cex, 
                chr=input$chr, 
                statTyp="n",
                chrSide=c(1,1,1,1,1,1,-1,1),
                colSegments = c("orange", "darkolivegreen"),
                bin = input$bin
                )
    })
  })

  output$chromoplotDownload <- downloadHandler(
    filename = function(){
      paste("ChromosomeMap", tolower(input$filetype_chromoplot), sep=".")
    },
    content = function(filechrom)
    {
      if(input$filetype_chromoplot == "PNG")
        png(filechrom, width = 12, height = 12, units ="in", res=300)
      else if(input$filetype_chromoplot == "SVG")
        svg(filechrom, width=12, height= 12)
      else if(input$filetype_chromoplot == "TIFF")
        tiff(filechrom, width=12, height=12, units = "in", res=300)
      else
        pdf(filechrom, width=12, height=12)
    
    chromdata <- input$chromfile
    ext <- tools::file_ext(chromdata$datapath)
    req(chromdata)
    
    chromInfile <- read.delim(chromdata$datapath, sep = "\t")
    
    chromInput <- chromInfile[abs(chromInfile['logFC']) > input$fc,]
    
    # Annotate file with CpG map information

    cpgChromoData <- cbind(chromInput$CHR,chromInput$MAPINFO,chromInput$MAPINFO +1, rownames(chromInput))
    colnames(cpgChromoData) <- c("Chrom", "Start", "End", "cpgID")
    cpgChromoData1 <- data.frame(cpgChromoData)
    cpgChromoData1$Chrom <- as.numeric(cpgChromoData1$Chrom)
    cpgChromoData1$Start <- as.numeric(cpgChromoData1$Start)
    cpgChromoData1$End <- as.numeric(cpgChromoData1$End)
    cpgChromoData1$ID <- as.character(cpgChromoData1$cpgID)
    
    # Annotate file with Gene map information
    
    geneChromoData <- cbind(chromInput$CHR,chromInput$MAPINFO,chromInput$MAPINFO +1, chromInput$gene)
    colnames(geneChromoData) <- c("Chrom", "Start", "End", "geneID")
    geneChromoData1 <- data.frame(geneChromoData)
    geneChromoData1$Chrom <- as.numeric(geneChromoData1$Chrom)
    geneChromoData1$Start <- as.numeric(geneChromoData1$Start)
    geneChromoData1$End <- as.numeric(geneChromoData1$End)
    geneChromoData1$ID <- as.character(geneChromoData1$geneID)
    
      
      chromPlot(gaps=hg_gap, 
                bands=hg_cytoBandIdeo, 
                stat=geneChromoData1,
                stat2 = cpgChromoData1,
                statCol="Value",
                statName="Value", 
                statCol2 = "Value",
                statName2 = "Value",
                noHist=FALSE, 
                figCols=4, 
                cex=input$cex, 
                chr=input$chr, 
                statTyp="n",
                chrSide=c(1,1,1,1,1,1,-1,1),
                colSegments = c("orange", "darkolivegreen"),
                bin = input$bin
                )
      dev.off()

    }
  )

  #====================================================#
  ## Genomic Features module ####
  #====================================================#

  ### Genome feature analysis
  genFeaPlot <- eventReactive(input$rungenfea, {
    id_genfea <- showNotification("generating plot, please wait...", duration = NULL, closeButton = FALSE)
    on.exit(removeNotification(id_genfea), add = TRUE)

    file3 <- input$file_genfea
    ext <- tools::file_ext(file3$datapath)
    req(file3)

    genFeaData <- read.delim(file3$datapath, sep = "\t", row.names = 1)

    Exon1st <- genFeaData[which(genFeaData$feature == "1stExon"),]
    UTR3 <- genFeaData[which(genFeaData$feature == "3'UTR"),]
    UTR5 <- genFeaData[which(genFeaData$feature == "5'UTR"),]
    Body <- genFeaData[which(genFeaData$feature == "Body"),]
    ExonBnd <- genFeaData[which(genFeaData$feature == "ExonBnd"),]
    IGR <- genFeaData[which(genFeaData$feature == "IGR"),]
    TSS1500 <- genFeaData[which(genFeaData$feature == "TSS1500"),]
    TSS200 <- genFeaData[which(genFeaData$feature == "TSS200"),]

    pieData = data.frame(
      genomicFeature = c("1stExon","3'UTR","5'UTR","Body","ExonBnd","IGR","TSS1500","TSS200"),
      values = c(nrow(Exon1st), nrow(UTR3), nrow(UTR5), nrow(Body),
                 nrow(ExonBnd), nrow(IGR), nrow(TSS1500), nrow(TSS200)))

    colors <- c('rgb(211,94,96)', 'rgb(128,133,133)', 'rgb(144,103,167)',
                'rgb(171,104,87)', 'rgb(114,147,203)', 'rgb(144,143,160)',
                'rgb(191,104,187)', 'rgb(144,174,23)')

    figure3 <- plot_ly(data = pieData,
                       labels = ~genomicFeature,
                       values = ~values,
                       type = 'pie',
                       textposition = 'inside',
                       textinfo = 'label+percent',
                       insidetextfont = list(color = '#FFFFFF'),
                       hoverinfo = 'text',
                       text = ~paste(values),
                       marker = list(colors = colors,
                                     line = list(color = '#FFFFFF', width = 1.5)),
                       showlegend = FALSE)
    figure3 <- figure3 %>% layout(title = 'Genomic Features',
                                  xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                                  yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))

    figure3
  })


  genFeaPlot1 <- eventReactive(input$demogenfea,
  {
    id_genfea1 <- showNotification("generating plot, please wait...", duration = NULL, closeButton = FALSE)
    on.exit(removeNotification(id_genfea1), add = TRUE)
    
    file3 <- read.delim('data/demodata.txt', sep = "\t", row.names = 1)
    #ext <- tools::file_ext(file3$datapath)
    req(file3)

    genFeaData <- file3

    Exon1st <- genFeaData[which(genFeaData$feature == "1stExon"),]
    UTR3 <- genFeaData[which(genFeaData$feature == "3'UTR"),]
    UTR5 <- genFeaData[which(genFeaData$feature == "5'UTR"),]
    Body <- genFeaData[which(genFeaData$feature == "Body"),]
    ExonBnd <- genFeaData[which(genFeaData$feature == "ExonBnd"),]
    IGR <- genFeaData[which(genFeaData$feature == "IGR"),]
    TSS1500 <- genFeaData[which(genFeaData$feature == "TSS1500"),]
    TSS200 <- genFeaData[which(genFeaData$feature == "TSS200"),]

    pieData = data.frame(
      genomicFeature = c("1stExon","3'UTR","5'UTR","Body","ExonBnd","IGR","TSS1500","TSS200"),
      values = c(nrow(Exon1st), nrow(UTR3), nrow(UTR5), nrow(Body),
                 nrow(ExonBnd), nrow(IGR), nrow(TSS1500), nrow(TSS200)))

    colors <- c('rgb(211,94,96)', 'rgb(128,133,133)', 'rgb(144,103,167)',
                'rgb(171,104,87)', 'rgb(114,147,203)', 'rgb(144,143,160)',
                'rgb(191,104,187)', 'rgb(144,174,23)')

    figure3 <- plot_ly(data = pieData,
                       labels = ~genomicFeature,
                       values = ~values,
                       type = 'pie',
                       textposition = 'inside',
                       textinfo = 'label+percent',
                       insidetextfont = list(color = '#FFFFFF'),
                       hoverinfo = 'text',
                       text = ~paste(values),
                       marker = list(colors = colors,
                                     line = list(color = '#FFFFFF', width = 1.5)),
                       showlegend = FALSE)
    figure3 <- figure3 %>% layout(title = 'Genomic Features',
                                  xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                                  yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))

    figure3
  })


  output$piechart <- renderPlotly({
    if(input$rungenfea) {genFeaPlot()}
    else {genFeaPlot1()}
  })


  output$downloadpie <- downloadHandler(
    filename = function() { paste0("Figure: Genomic Features", Sys.time(),".html", sep='') },
    content = function(figure3) {
      htmlwidgets::saveWidget(as_widget(genFeaPlot()), figure3, selfcontained = TRUE)
    })


  ##3.3 Generate an HTML table view of genomic features
  output$tablegf <- DT::renderDataTable(server=FALSE,{
    file3 <- input$file_genfea
    ext <- tools::file_ext(file3$datapath)
    req(file3)
    genFeaData <- read.delim(file3$datapath, sep = "\t", row.names = 1)

    Exon1st <- genFeaData[which(genFeaData$feature == "1stExon"),]
    UTR3 <- genFeaData[which(genFeaData$feature == "3'UTR"),]
    UTR5 <- genFeaData[which(genFeaData$feature == "5'UTR"),]
    Body <- genFeaData[which(genFeaData$feature == "Body"),]
    ExonBnd <- genFeaData[which(genFeaData$feature == "ExonBnd"),]
    IGR <- genFeaData[which(genFeaData$feature == "IGR"),]
    TSS1500 <- genFeaData[which(genFeaData$feature == "TSS1500"),]
    TSS200 <- genFeaData[which(genFeaData$feature == "TSS200"),]

    pieData = data.frame(
      genomicFeature = c("1stExon","3'UTR","5'UTR","Body","ExonBnd","IGR","TSS1500","TSS200"),
      values = c(nrow(Exon1st), nrow(UTR3), nrow(UTR5), nrow(Body),
                 nrow(ExonBnd), nrow(IGR), nrow(TSS1500), nrow(TSS200)))

    DT::datatable(
      pieData,
      extensions = 'Buttons',
      options = list(
        paging = TRUE,
        searching = TRUE,
        fixedColumns = TRUE,
        autowidth = TRUE,
        ordering = TRUE,
        dom = 'Bfrtip',
        scrollX = TRUE,
        buttons = list(
          list(extend = "excel", text = "Download current page", filename = "page",
               exportOptions = list(
                 modifier = list(page = "current")
               )
          ),
          list(extend = "excel", text = "Download full results", filename = "data",
               exportOptions = list(
                 modifier = list(page="all")
               ))
        )
      ), class = "display"
    )
  })

  suppressPackageStartupMessages(library(RColorBrewer))
  suppressPackageStartupMessages(library(htmlwidgets))
  suppressPackageStartupMessages(library(gplots))
  suppressPackageStartupMessages(library(dendextend))


  #====================================================#
  ## Venn module ####
  #====================================================#
  venn_type <- reactive({
    return(input$venn_type)
  })

  doWeights <- reactive({
    return(input$doWeights)
  })

  doEuler <- reactive({
    return(input$doEuler)
  })

  venn_size <- reactive({
    return(input$venn_size)
  })

  venn_lwd <- reactive({
    return(as.numeric(input$venn_lwd))
  })

  venn_labelsize <- reactive({
    return(as.numeric(input$venn_labelsize))
  })

  venn_color_type <- reactive({
    return(input$venn_color_type)
  })


  venn_cex <- reactive({
    return(as.numeric(input$venn_cex))
  })

  venn_lty <- reactive({
    return(as.numeric(input$venn_lty))
  })

  set1_color <- reactive({
    return(input$set1_color)
  })
  set2_color <- reactive({
    return(input$set2_color)
  })
  set3_color <- reactive({
    return(input$set3_color)
  })
  set4_color <- reactive({
    return(input$set4_color)
  })
  set5_color <- reactive({
    return(input$set5_color)
  })
  set6_color <- reactive({
    return(input$set6_color)
  })



  venn_data <- reactive({
    inFile <- input$file_venn
    #string <- input$venn_comb
    string <- ""

    if(is.null(inFile) == F)
    {
      #data <- read.csv(input$file_venn$datapath, header = input$header_venn, sep = input$sep_venn)
      data <- read_delim(input$file_venn$datapath, input$sep_venn , escape_double = FALSE, trim_ws = TRUE, col_names = input$header_venn)
      data <- lapply(data, function(x) x[!is.na(x)])
      return(data)
    }else{
      if (string != "")
      {
        string <- gsub("\n", "", string)
        if(string != ""){
          string <- as.list(unlist(strsplit(string, ",")))
          names <- lapply(string, function(x){x <- unlist(strsplit(x, "=")); x <- x[1]})
          names <- unlist(lapply(names, function(x){x <- gsub(" ", "", x)}))
          vennData <- as.numeric(unlist(lapply(string, function(x){x <- unlist(strsplit(x,"=")); x <- x[2]})))
          names(vennData) <- names
          return(vennData)
        }else{
          return(NULL)
        }
      }
      else{
        #data <- read.csv('data/Whyte_et_al_2013_SEs_genes.csv', header = TRUE, sep = ',')
        data <- read_delim('www/Whyte_et_al_2013_SEs_genes.csv', ",", escape_double = FALSE, trim_ws = TRUE, col_names = TRUE)
        return(lapply(data, function(x) x[!is.na(x)]))
      }
    }
  })

  set_names <- reactive({
    #names <- colnames(venn_data())
    names <- names(venn_data())
    #names <- sort(names)
    return(names)
  })

  output$venn_sets <- renderUI({
    venn_sets <- selectInput('venn_sets', label = "Select sets",
                             choices = as.character(set_names()),
                             multiple = T, selectize = T, selected = as.character(set_names()[1:5]))
    return(venn_sets)
  })

  venn_selected_names <- reactive({
    venn_selected_names <- as.character(c(input$venn_sets))
  })

  venn_data_filtered <- reactive({

    data <- venn_data()
    if(is.null(input$venn_sets)){

    }else{
      data <- data[c(venn_selected_names())]
      return(data)
    }
    return(data)
  })

  venn_combinations <- reactive({
    #string <- input$venn_comb
    string <- ""
    data <- venn_data_filtered()
    if (string !=""){
      return(data)
    }else
    {
      return(Venn(data))
    }
  })

  get_venn_gp <- reactive({
    venn_gp <- VennThemes(compute.Venn(venn_combinations()))
    venn_gp$SetText <- lapply(venn_gp$SetText,function(x) {x$fontsize<-venn_labelsize(); return(x)})
    venn_gp$FaceText <- lapply(venn_gp$FaceText,function(x) {x$cex<-venn_cex(); return(x)})
    venn_gp$Set <- lapply(venn_gp$Set,function(x) {x$lwd<-venn_lwd(); return(x)})
    venn_gp$Set <- lapply(venn_gp$Set,function(x) {x$lty<-venn_lty(); return(x)})

    if (venn_color_type () == 'custom'){
      venn_gp$Set$Set1$col <- set1_color()
      venn_gp$Set$Set2$col <- set2_color()
      venn_gp$Set$Set3$col <- set3_color()
      venn_gp$Set$Set4$col <- set4_color()
      venn_gp$Set$Set5$col <- set5_color()
      venn_gp$Set$Set6$col <- set6_color()

      venn_gp$SetText$Set1$col <- set1_color()
      venn_gp$SetText$Set2$col <- set2_color()
      venn_gp$SetText$Set3$col <- set3_color()
      venn_gp$SetText$Set4$col <- set4_color()
      venn_gp$SetText$Set5$col <- set5_color()
      venn_gp$SetText$Set6$col <- set6_color()

    }

    return(venn_gp)
  })

  data_size <- reactive({
    return(length(venn_data_filtered()))
  })

  get_venn_type <- reactive({
    if (venn_type() == 'Classical'){
      if(data_size() < 4)
        return("circles")
      else
        return("ellipses")
    }else if (venn_type() == 'ChowRuskey' && data_size() < 3){
      return("circles")
    }
    else{
      return(venn_type())
    }
  })

  output$vennPlot <- renderPlot({
    plot(compute.Venn(venn_combinations(), doWeights = doWeights(), doEuler = doEuler(), type = get_venn_type()),
         gp = get_venn_gp(),
         show = list(Universe = FALSE)
    )
  },
    width = venn_size,
    height = venn_size,
    outputArgs = list()
  )

  output$VennDown <- downloadHandler(
    filename = function(){
      paste("Venn_diagram", tolower(input$filetype_venn), sep =".")
    },
    content = function(file){
      width  <- venn_size()
      height <- venn_size()
      #width  <- session$clientData$output_plot_width
      #height <- ((session$clientData$output_plot_height)*1)
      #pixelratio <- session$clientData$pixelratio
      pixelratio <- 2

      if(input$filetype_venn == "PNG")
        png(file, width=width*pixelratio, height=height*pixelratio, units = "px", res=72*pixelratio)
      else if(input$filetype_venn == "SVG")
        svg(file, width=8, height=8)
      else if(input$filetype_venn == "TIFF")
        tiff(file, width=width*pixelratio, height=height*pixelratio, units = "px")
      else
        pdf(file, width = 8, height = 8)

      plot(venn_combinations(),
           doWeights = doWeights(),
           type = get_venn_type(),
           doEuler = doEuler(),
           show = list(Universe = FALSE)
           #venn_type()
      )
      dev.off()
    }
  )

  #====================================================#
  ## UpSet module ####
  #====================================================#
  #Some of the code for upset module is taken from
  #https://github.com/hms-dbmi/UpSetR-shiny

  output$plot_text <- renderUI({
    if(is.null(My_data()) == T){
      h5("There is no data entered. Please upload your data to draw UpSet plot here!")
    }
    else{
      HTML(" ")
    }
  })

  My_dat <- reactive({
    inFile <- input$file1
    input_type = input$upset_input_type
    if (is.null(inFile) == T){

      My_dat<- fromExpression(c('H3K4me2&H3K4me3'=16321,'H3K4me2&H3K4me3&H3K27me3'=5756,'H3K27me3'=25174,'H3K4me3&H3K27me3'=15539,'H3K4me3'=32964,'H3K4me2&H3K27me3'=19039,'H3K4me2'=60299,'H3K27ac&H3K4me2&H3K4me3&H3K27me3'=7235,'H3K27ac&H3K4me2&H3K4me3'=17505,'H3K27ac&H3K4me2'=21347,'H3K27ac&H3K4me2&H3K27me3'=1698,'H3K27ac&H3K4me3'=8134,'H3K27ac&H3K4me3&H3K27me3'=295,'H3K27ac&H3K27me3'=7605,'H3K27ac'=42164))
      #read.csv("data/ENCODE_hESC_HMs.txt", header = TRUE, sep = '\t')
      return(My_dat)
    }
    else if(is.null(inFile) == F && input_type == 'binary'){
      read.csv(inFile$datapath, header = input$header,
               sep = input$sep, quote = input$quote)
    }else if (is.null(inFile) == F && input_type == 'list'){
      #My_dat <- fromList(convertColsToList(read.csv(inFile$datapath, header = input$header, sep = input$sep, quote = input$quote)))
      #removed NAs
      #My_dat <- fromList(lapply(as.list(read.csv(inFile$datapath, header = input$header, sep = input$sep, quote = input$quote)), function(x) x[!is.na(x)]))
      My_dat <- read_delim(inFile$datapath, input$sep , escape_double = FALSE, trim_ws = TRUE, col_names = input$header)
      My_dat <- fromList(lapply(as.list(My_dat), function(x) x[!is.na(x)]))

      return(My_dat)
    }else{
      return(NULL)
    }
  })

  venneulerData <- reactive({
    string <- input$upset_comb
    string <- gsub("\n", "", string)
    if(string != ""){
      string <- as.list(unlist(strsplit(string, ",")))
      names <- lapply(string, function(x){x <- unlist(strsplit(x, "=")); x <- x[1]})
      names <- unlist(lapply(names, function(x){x <- gsub(" ", "", x)}))
      values <- as.numeric(unlist(lapply(string, function(x){x <- unlist(strsplit(x,"=")); x <- x[2]})))
      names(values) <- names
      venneuler <- fromExpression(values)
      return(venneuler)
    }
  })

  My_data <- reactive({
    string <- input$upset_comb
    if(string != ""){
      My_data <- venneulerData()
    }
    else {
      My_data <- My_dat()
    }
    return(My_data)
  })

  FindStartEnd <- function(data){
    startend <- c()
    for(i in 1:ncol(data)){
      column <- data[, i]
      column <- (levels(factor(column)))
      if((column[1] == "0") && (column[2] == "1" && (length(column) == 2))){
        startend[1] <- i
        break
      }
      else{
        next
      }
    }
    for(i in ncol(data):1){
      column <- data[ ,i]
      column <- (levels(factor(column)))
      if((column[1] == "0") && (column[2] == "1") && (length(column) == 2)){
        startend[2] <- i
        break
      }
      else{
        next
      }
    }
    return(startend)
  }

  startEnd <- reactive({
    startEnd <- FindStartEnd(My_data())
  })

  setSizes <- reactive({
    if(is.null(My_data()) != T){
      sizes <- colSums(My_data()[startEnd()[1]:startEnd()[2]])
      sizes <- sizes[order(sizes, decreasing = T)]

      names <- names(sizes); sizes <- as.numeric(sizes);
      maxchar <- max(nchar(names))
      total <- list()
      for(i in 1:length(names)){
        spaces <- as.integer((maxchar - nchar(names[i]))+1)
        spaces <- paste(rep(" ", each=spaces), collapse = "")
        total[[i]] <- paste(paste(names[i], ":", sep=""), spaces, sizes[i], "\n", sep="")
      }
      total <- unlist(total)
      total <- paste(total, collapse = " ")
      return(total)
    }
    else{
      return(NULL)
    }
  })

  output$setsizes <- renderText({
    if(is.null(setSizes()) != T){
      paste("---Set Sizes---\n", setSizes())
    }
    else{
      paste("---Set Sizes---\n", "\n No Data Entered")
    }
  })

  Specific_sets <- reactive({
    Specific_sets <- as.character(c(input$upset_sets))
  })

  output$sets <- renderUI({
    if(is.null(My_data()) == T){
      sets <-  selectInput('upset_sets', label="Select at least two sets ",
                           choices = NULL,
                           multiple=TRUE, selectize=TRUE, selected = Specific_sets())
    }
    else{
      data <- My_data()[startEnd()[1]:startEnd()[2]]
      topfive <- colSums(data)
      topfive <- as.character(head(names(topfive[order(topfive, decreasing = T)]), 5))
      sets <- selectInput('upset_sets', label="Select sets ",
                          choices = as.character(colnames(My_data()[ , startEnd()[1]:startEnd()[2]])),
                          multiple=TRUE, selectize=TRUE, selected = topfive)
    }
    return(sets)
  })


  mat_prop <- reactive({
    mat_prop <- input$mbratio
  })
  upset_width <- reactive({
    return(input$upset_width)
  })
  upset_height <- reactive({
    return(input$upset_height)
  })

  bar_prop <- reactive({
    bar_prop <- (1 - input$mbratio)
  })

  orderdat <- reactive({
    orderdat <- as.character(input$order)
    if(orderdat == "degree"){
      orderdat <- c("degree")
    }
    else if(orderdat == "freq"){
      orderdat <- "freq"
    }
    return(orderdat)
  })

  show_numbers <- reactive({
    show_numbers <- input$show_numbers
    if(show_numbers){
      show_numbers <- "yes"
      return(show_numbers)
    }
    else{
      show_numbers <- FALSE
      return(show_numbers)
    }

  })

  main_bar_color <- reactive({
    mbcolor <- input$mbcolor
    return(mbcolor)
  })
  sets_bar_color <- reactive({
    sbcolor <- input$sbcolor
    return(sbcolor)
  })


  decrease <- reactive({
    decrease <- as.character(input$decreasing)
    if(decrease == "inc"){
      decrease <- FALSE
    }
    else if(decrease == "dec"){
      decrease <- TRUE
    }
    return(decrease)
  })

  number_angle <- reactive({
    angle <- input$angle
    return(angle)
  })

  line_size <- reactive({
    line_size <- input$linesize
    return(line_size)
  })

  emptyIntersects <- reactive({
    if(isTRUE(input$empty)){choice <- "on"
      return(choice)
    }
    else{
      return(NULL)
    }
  })

  scale.intersections <- reactive({
    return(input$scale.intersections)
  })

  scale.sets <- reactive({
    return(input$scale.sets)
  })

  keep.order <- reactive({
    return(input$keep.order)
  })

  # A plot of fixed size
  output$plot1 <- renderPlot({

    if(length(My_data()) == 0){stop()}
    if(length(Specific_sets()) == 1){
      stop()
    }
    upset(data = My_data(),
          nintersects = input$nintersections,
          point.size = input$pointsize,
          line.size = line_size(),
          sets = Specific_sets(),
          order.by = orderdat(),
          main.bar.color= main_bar_color(),
          sets.bar.color= sets_bar_color(),
          decreasing = c(decrease()),
          show.numbers = show_numbers(),
          number.angles = number_angle(),
          scale.intersections = scale.intersections(),
          scale.sets = scale.sets(),
          keep.order = keep.order(),
          mb.ratio = c(as.double(bar_prop()), as.double(mat_prop())),
          empty.intersections = emptyIntersects(),
          text.scale = c(input$intersection_title_scale, input$intersection_ticks_scale,
                         input$set_title_scale, input$set_ticks_scale, input$names_scale,
                         input$intersection_size_numbers_scale))},
    #width  <- session$clientData$output_plot_width
    #height <- ((session$clientData$output_plot_height)*1.7)
    width = upset_width,
    height = upset_height
  )

  #outputOptions(output, "plot", suspendWhenHidden = FALSE)

  # observe({
  #   if(pushed$B != 0 && length(pushed$B) == 1){
  #     updateTabsetPanel(session, "main_panel", "upset_plot")
  #   }
  # })

  output$UpSetDown <- downloadHandler(

    filename = function(){
      paste("UpSet_plot", tolower(input$filetype), sep =".")
    },
    content = function(file){
      width <- upset_width()
      height <- upset_height()
      pixelratio <- 2

      #width  <- session$clientData$output_plot_width
      #height <- ((session$clientData$output_plot_height)*2)
      #pixelratio <- session$clientData$pixelratio
      if(input$filetype == "PNG")
        png(file, width=width*pixelratio, height=height*pixelratio,
            res=72*pixelratio, units = "px")
      else if(input$filetype == "SVG")
        svg(file, width = width/100, height = height/100)
      else if(input$filetype == "TIFF")
        tiff(file, width=width*pixelratio, height=height*pixelratio, units = "px")
      else
        pdf(file, width = width/100, height = height/100, onefile=FALSE)

      upset(data = My_data(),
            nintersects = input$nintersections,
            point.size = input$pointsize,
            line.size = line_size(),

            sets = Specific_sets(),
            order.by = orderdat(),
            main.bar.color= main_bar_color(),
            sets.bar.color= sets_bar_color(),
            decreasing = c(decrease()),
            number.angles = number_angle(),
            show.numbers = show_numbers(),
            scale.intersections = scale.intersections(),
            scale.sets = scale.sets(),
            keep.order = keep.order(),
            mb.ratio = c(as.double(bar_prop()), as.double(mat_prop())),
            empty.intersections = emptyIntersects(),
            text.scale = c(input$intersection_title_scale, input$intersection_ticks_scale,
                           input$set_title_scale, input$set_ticks_scale, input$names_scale,
                           input$intersection_size_numbers_scale))

      dev.off()
    }
  )

  #====================================================#
  ## Pairwise module ####
  #====================================================#
  output$plot_text_p <- renderUI({
    if(is.null(pairwiseMatrix()) == T){
      h5("There is no data entered. Please upload your data to draw pairwise heatmap here!")
    }
    else{
      HTML(" ")
    }
  })

  corplot_method <- reactive({
    return(input$corp_method)
  })

  corplot_type <- reactive({
    return(input$corp_type)
  })

  corplot_order <- reactive({
    return(input$corp_order)
  })

  corplot_diag <- reactive({
    return(input$corp_diag)
  })

  corplot_tl.col <- reactive({
    return(input$tl_col)
  })

  corplot_title <- reactive({
    return(input$corp_title)
  })

  heatmap_size <- reactive({
    return(input$heatmap_size)
  })

  addrect <- reactive({
    return(input$addrect)
  })

  rect_col <- reactive({
    return(input$rect_col)
  })

  hclust_method <- reactive({
    return(input$hclust_method)
  })


  tl_pos <- reactive({
    if (corplot_type() =="lower" && input$tl_pos != 'n')
    {
      return('ld')

    }else if(corplot_type() =="upper" && input$tl_pos != 'n'){
      return('td')
    }else{
      return(input$tl_pos)
    }
  })

  cl_pos <- reactive({
    if (corplot_type() =="lower" && input$cl.pos != 'n')
    {
      return('b')

    }else if(corplot_type() =="upper" && input$cl.pos != 'n'){
      return('r')
    }else{
      return(input$cl.pos)
    }
  })

  addgrid_col <- reactive({
    return(input$addgrid_col)
  })

  tl_srt <- reactive({
    return(input$tl.srt)
  })

  tl_cex <- reactive({
    return(input$tl.cex)
  })

  cl_cex <- reactive({
    return(input$cl.cex)
  })

  lower_colour <- reactive({
    return(input$lower_colour)
  })
  middle_colour <- reactive({
    return(input$middle_colour)
  })
  higher_colour <- reactive({
    return(input$higher_colour)
  })

  heamap_colors <- reactive({
    if(input$color_type == 'custom'){
      colors = colorRampPalette(c(lower_colour(), middle_colour(), higher_colour()))(100)
    }else{
      colors = colorRampPalette(brewer.pal(9,input$color_type))(100)
    }
    return(colors)
  })



  dendrogram <- reactive({
    return(input$dendrogram)
  })
  symm <- reactive({
    return(input$symm)
  })
  key <- reactive({
    return(input$key)
  })
  keysize <- reactive({
    return(input$keysize)
  })
  key.title <- reactive({
    return(input$key.title)
  })
  key.xlab <- reactive({
    return(input$key.xlab)
  })
  key.ylab <- reactive({
    return(input$key.ylab)
  })

  distance <- reactive({
    if(input$distance == 'none'){
      distance= as.dist(pairwiseMatrix())
    }else{
      distance= dist(pairwiseMatrix(), method =input$distance)
    }
    return(distance)
  })

  is_correlation<- reactive({
    isCor <- input$corp_cor
    if(isCor == 'non'){
      return(FALSE)
    }else
    {
      return(TRUE)
    }
  })

  pairwiseMatrix <- reactive({
    inFile <- input$file_p
    isCor <- input$corp_cor
    input_type <- input$pairwise_input_type
    if (is.null(inFile)){

      myMatrix <- as.matrix(read.table("www/frac_pairwise_matrix.txt"))
      if(isCor != 'non'){
        myMatrix <- cor(myMatrix, method=isCor)
      }
      return (myMatrix)
    }else{
      if(input_type == 'matrix'){

        mydata <- read.table(inFile$datapath)
        mydatap <- mydata[1:input$num_p,]
        
        myMatrix <- as.matrix(mydatap)

      }else{
        #myMatrix <- as.matrix(pairwise_intersect(read.csv(inFile$datapath, header = input$header_p, sep=input$sep_p)))
        myMatrix <- as.matrix(pairwise_intersect(lapply(as.list(read_delim(inFile$datapath, input$sep_p , escape_double = FALSE, trim_ws = TRUE, col_names = input$header_p)), function(x) x[!is.na(x)])))
        #myMatrix <- as.matrix(pairwise_intersect(lapply(as.list(read.csv(inFile$datapath, header = input$header_p, sep=input$sep_p)), function(x) x[!is.na(x)])))
      }

      if(isCor != 'non'){
        myMatrix <- cor(myMatrix, method=isCor)
      }
      return(myMatrix)
    }
  })

  min_limit <- reactive({
    isCor <- input$corp_cor
    if(isCor == 'non'){
      return(0)
    }else
    {
      return(-1)
    }
  })

  max_limit <- reactive({
    isCor <- input$corp_cor
    input_type <- input$pairwise_input_type

    if(isCor == 'non' && input_type == 'list'){
      return(as.integer(max(pairwiseMatrix())))
    }else
    {
      return(1)
    }
  })

  output$pairwiseTable = DT::renderDataTable(
    round(pairwiseMatrix(),2), options = list(
      lengthChange = TRUE
    )
  )

  heatmap2_plot <- reactive({
    hcluster <- hclust(distance(), method =hclust_method())
    dend1 <- as.dendrogram(hcluster)
    # get some colors
    dend1 <- color_branches(dend1, k = addrect())
    col_labels <- get_leaves_branches_col(dend1)
    # order of the data!
    col_labels <- col_labels[order(order.dendrogram(dend1))]

    plt <- heatmap.2(pairwiseMatrix(),
                     scale = "none",
                     #dendrogram = "both",
                     col = heamap_colors(),
                     cexRow = tl_cex(),
                     cexCol = tl_cex(),
                     #srtRow = tl_srt(),
                     srtCol = tl_srt(),
                     Rowv = dend1,
                     Colv = dend1,
                     main = corplot_title(),
                     dendrogram = dendrogram(),
                     symm = symm(),
                     #revC = TRUE,
                     key = key(),
                     keysize = keysize(),
                     key.title = key.title(),
                     key.xlab =  key.xlab(),
                     key.ylab = key.ylab(),
                     key.par = list(cex=cl_cex()),
                     sepwidth = c(0.05, 0.05),  # width of the borders
                     mar=c(6,6),
                     sepcolor = addgrid_col(),
                     colsep =1:ncol(pairwiseMatrix()),
                     rowsep =1:nrow(pairwiseMatrix()),
                     #offsetRow = 0.1,
                     #offsetCol = 0.1,
                     trace="none",
                     #RowSideColors = col_labels, #colored strips
                     colRow = col_labels,
                     ColSideColors = col_labels, #colored strips
                     colCol = col_labels
    )
    return(plt)
  })

  output$heatmap2_plot_out <- renderPlot(
    heatmap2_plot(),

    width= heatmap_size,
    height= heatmap_size
  )

  output$Heatmap2PlotDown <- downloadHandler(
    filename = function(){
      paste("Pairwise_heatmap2", tolower(input$filetype_heatmap), sep =".")
    },
    content = function(file){
      width  <- heatmap_size()
      height <- heatmap_size()
      #width  <- session$clientData$output_plot_width
      #height <- ((session$clientData$output_plot_height)*2)
      pixelratio <- 2
      if(input$filetype_heatmap == "PNG")
        png(file, width=width*pixelratio, height=height*pixelratio,
            res=72*pixelratio, units = "px")
      else if(input$filetype_heatmap == "SVG")
        svg(file, width=12, height=12)
      else if(input$filetype_heatmap == "TIFF")
        tiff(file, width=width*pixelratio, height=height*pixelratio, units = "px")
      else
        pdf(file, width = 12, height = 12)

      hcluster <- hclust(distance(), method =hclust_method())
      dend1 <- as.dendrogram(hcluster)
      # get some colors
      dend1 <- color_branches(dend1, k = addrect())
      col_labels <- get_leaves_branches_col(dend1)
      # order of the data!
      col_labels <- col_labels[order(order.dendrogram(dend1))]

      heatmap.2(pairwiseMatrix(),
                scale = "none",
                #dendrogram = "both",
                col = heamap_colors(),
                cexRow = tl_cex(),
                cexCol = tl_cex(),
                #srtRow = tl_srt(),
                srtCol = tl_srt(),
                Rowv = dend1,
                Colv = dend1,
                main = corplot_title(),
                dendrogram = dendrogram(),
                symm = symm(),
                #revC = TRUE,
                key = key(),
                keysize = keysize(),
                key.title = key.title(),
                key.xlab =  key.xlab(),
                key.ylab = key.ylab(),
                key.par = list(cex=cl_cex()),
                sepwidth = c(0.05, 0.05),  # width of the borders
                mar=c(6,6),
                sepcolor = addgrid_col(),
                colsep =1:ncol(pairwiseMatrix()),
                rowsep =1:nrow(pairwiseMatrix()),
                #offsetRow = 0.1,
                #offsetCol = 0.1,
                trace="none",
                #RowSideColors = col_labels, #colored strips
                colRow = col_labels,
                ColSideColors = col_labels, #colored strips
                colCol = col_labels
      )
      dev.off()
    }
  )

  d3HM_plot <- reactive({
    hcluster = hclust(distance(), method =hclust_method())
    dend1 <- as.dendrogram(hcluster)

    # get some colors
    #cols_branches <- c("darkred", "forestgreen", "orange", "blue")
    #cols_branches <- brewer.pal(addrect(), "Set1")

    # Set the colors of 4 branches
    #dend1 <- color_branches(dend1, k = addrect(), col = cols_branches[1:addrect()])
    dend1 <- color_branches(dend1, k = addrect())

    col_labels <- get_leaves_branches_col(dend1)
    # But due to the way heatmap.2 works - we need to fix it to be in the
    # order of the data!
    col_labels <- col_labels[order(order.dendrogram(dend1))]
    d3heatmap(pairwiseMatrix(),
              show_grid = TRUE,
              scale = "none",
              dendrogram = dendrogram(),
              anim_duration = 0,
              k_row = addrect(),
              k_col = addrect(),
              Rowv = dend1,
              Colv = dend1,
              symm = symm(),
              #revC = FALSE,
              #hclustfun = function(x) hclust(x,method = hclust_method()),
              #distfun = function(x) dist(x,method = hclust_method()),
              colors = heamap_colors(),
              xaxis_font_size = "12px",
              yaxis_font_size = "12px"
              #xaxis_height = 8,
              #yaxis_width = 8
    )
  })

  output$d3HM <- renderD3heatmap(d3HM_plot())

  output$HeatmapHTMLDown <- downloadHandler(
    filename = function(){
      paste("Interactive_pairwise_heatmap", "html", sep =".")
    },
    content = function(file){
      saveWidget(d3HM_plot(), file)
    }
  )

  output$corrplotHM <- renderPlot({
    corrplot(pairwiseMatrix(),
             method = corplot_method(),
             title = corplot_title(),
             tl.col= corplot_tl.col(),
             cl.lim=c(min_limit(),max_limit()),
             is.corr = is_correlation(),
             diag = corplot_diag(),
             order = corplot_order(),
             hclust.method = hclust_method(),
             type = corplot_type(),
             addrect = addrect(),
             tl.pos = tl_pos(),
             cl.pos = cl_pos(),
             rect.col = rect_col(),
             addgrid.col= addgrid_col(),
             tl.cex = tl_cex(),
             cl.cex = cl_cex(),
             tl.srt = tl_srt(),
             mar=c(0,0,2,2),
             col = heamap_colors()

    )},
    width= heatmap_size,
    height= heatmap_size
  )

  output$HeatmapCSVDown <- downloadHandler(
    filename = function(){
      paste("Pairwise_matrix", "csv", sep =".")
    },
    content = function(file){
      write.csv(pairwiseMatrix(), file)
    }
  )


  output$HeatmapDown <- downloadHandler(
    filename = function(){
      paste("Pairwise_heatmap", tolower(input$filetype_heatmap), sep =".")
    },
    content = function(file){
      width  <- heatmap_size()
      height <- heatmap_size()
      #width  <- session$clientData$output_plot_width
      #height <- ((session$clientData$output_plot_height)*2)
      pixelratio <- 2
      if(input$filetype_heatmap == "PNG")
        png(file, width=width*pixelratio, height=height*pixelratio,
            res=72*pixelratio, units = "px")
      else if(input$filetype_heatmap == "SVG")
        svg(file, width=12, height=12)
      else if(input$filetype_heatmap == "TIFF")
        tiff(file, width=width*pixelratio, height=height*pixelratio, units = "px")
      else
        pdf(file, width = 12, height = 12)

      corrplot(pairwiseMatrix(),
               method = corplot_method(),
               title = corplot_title(),
               tl.col= corplot_tl.col(),
               cl.lim=c(min_limit(),max_limit()),
               is.corr = is_correlation(),
               diag = corplot_diag(),
               order = corplot_order(),
               hclust.method = hclust_method(),
               type = corplot_type(),
               addrect = addrect(),
               tl.pos = tl_pos(),
               cl.pos = cl_pos(),
               rect.col = rect_col(),
               addgrid.col= addgrid_col(),
               tl.cex = tl_cex(),
               cl.cex = cl_cex(),
               tl.srt = tl_srt(),
               mar=c(0,0,2,1),
               #addCoef.col = "red",
               col = heamap_colors()
               #col = col3(100)
      )
      dev.off()
    }
  )


  ####==================================
  ### Pathway analysis module
  ####==================================

  pathPlot1 <- eventReactive(input$Run, {
    id_pathplot1 <- showNotification("generating plot, please wait...", duration = NULL, closeButton = FALSE)
    on.exit(removeNotification(id_pathplot1), add = TRUE)

    filepath <- input$file7
    ext <- tools::file_ext(filepath$datapath)

    req(filepath)
    #validate(need(ext == "csv", "Please upload a csv file"))

    pathdata <- read.delim(filepath$datapath, sep = "\t", row.names = 1)

    suppressMessages(suppressWarnings(library(ReactomePA)))
    suppressMessages(suppressWarnings(library(clusterProfiler)))
    suppressMessages(suppressWarnings(library(dplyr)))
    suppressMessages(suppressWarnings(library(org.Hs.eg.db)))

    # prepare the input gene list for pathway analysis
    pathdata1 <- c(data.frame(pathdata$gene), data.frame(pathdata$logFC))
    geneIDconv <- bitr(pathdata1$pathdata.gene, fromType="SYMBOL", toType="ENTREZID", OrgDb="org.Hs.eg.db")
    names(pathdata1)[1] <- "SYMBOL"
    pathdata2 <- merge(pathdata1, geneIDconv, by = "SYMBOL")
    geneList <- pathdata2[,2]
    names(geneList) <- as.character(pathdata2[,3])
    geneList = sort(geneList, decreasing = TRUE)
    gene <- names(geneList)[abs(geneList) > 0]


    datatype <- reactive({
      switch(input$pathType,
             "Over representation analysis" = 1,
             "Gene set enrichment analysis" = 2)
    })

    if(input$pathType == "1") {
      if(input$pathDB == "1") {
      pathdata.reactome.ora.run <- enrichPathway(gene = gene,
                                                 pvalueCutoff=input$adjPvalue,
                                                 pAdjustMethod = input$pvaladj,
                                                 readable = T)

      pathdata.reactome.ora.tmp <- as.data.frame(pathdata.reactome.ora.run)

      tmp1 <- pathdata.reactome.ora.tmp %>%
        separate(GeneRatio, c("GeneR1", "GeneR2"), "/")
      tmp1$GeneRatio <- as.numeric(tmp1$GeneR1)/as.numeric(tmp1$GeneR2)
      pathdata.reactome.ora.tmp$GeneRatio <- tmp1$GeneRatio
      tmp2 <- pathdata.reactome.ora.tmp %>%
        separate(BgRatio, c("bg1", "bg2"), "/")
      tmp2$BgRatio <- as.numeric(tmp2$bg1)/as.numeric(tmp2$bg2)
      pathdata.reactome.ora.tmp$BgRatio <- tmp2$BgRatio

      # visualization of the pathway analysis result
      pathdata.reactome.ora1 <- pathdata.reactome.ora.tmp[1:input$numPath,]

      reactomeORAFigure <- plot_ly() %>%
        add_trace(data = pathdata.reactome.ora1,
                  x = ~GeneRatio,
                  y = ~Description,
                  size = ~Count,
                  type = "scatter",
                  color = ~p.adjust,
                  colors = c("red", "white", "blue"),
                  alpha = 1,
                  text = ~paste('</br> Pathway = ', Description,
                                '</br> GeneRatio = ', GeneRatio,
                                '</br> Count = ', Count,
                                '</br> FDR = ', p.adjust),
                  name = "",
                  hoverinfo = 'text',
                  texttemplate = '%{y: .3s}', textposition = 'outside',
                  mode = "markers",
                  marker = list(sizeref = 0.3, color = ~factor(p.adjust))) %>%
        layout(title = "Reactome Over-representation Pathways",
               xaxis = list(title = "GeneRatio"), #showgrid = F
               yaxis = list(title = ""),#showgrid = F
               showlegend = TRUE,
               legend=list(title = list(text='p.adjust')))

      reactomeORAFigure
      } else if (input$pathDB == "2") {
        pathdata.kegg.ora.run <- enrichKEGG(gene = gene,
                                            organism = "hsa",
                                            pvalueCutoff = input$adjPvalue,
                                            pAdjustMethod = input$pvaladj
                                            )
        pathdata.kegg.ora.tmp <- as.data.frame(pathdata.kegg.ora.run)

        tmp1 <- pathdata.kegg.ora.tmp %>%
        separate(GeneRatio, c("GeneR1", "GeneR2"), "/")
        tmp1$GeneRatio <- as.numeric(tmp1$GeneR1)/as.numeric(tmp1$GeneR2)
        pathdata.kegg.ora.tmp$GeneRatio <- tmp1$GeneRatio
        tmp2 <- pathdata.kegg.ora.tmp %>%
          separate(BgRatio, c("bg1", "bg2"), "/")
        tmp2$BgRatio <- as.numeric(tmp2$bg1)/as.numeric(tmp2$bg2)
        pathdata.kegg.ora.tmp$BgRatio <- tmp2$BgRatio

        pathdata.kegg.ora1 <- pathdata.kegg.ora.tmp[1:input$numPath,]

        keggORAFigure <- plot_ly() %>%
        add_trace(data = pathdata.kegg.ora1,
                  x = ~GeneRatio,
                  y = ~Description,
                  size = ~Count,
                  type = "scatter",
                  color = ~p.adjust,
                  colors = c("red", "white", "blue"),
                  alpha = 1,
                  text = ~paste('</br> Pathway = ', Description,
                                '</br> GeneRatio = ', GeneRatio,
                                '</br> Count = ', Count,
                                '</br> FDR = ', p.adjust),
                  name = "",
                  hoverinfo = 'text',
                  texttemplate = '%{y: .3s}', textposition = 'outside',
                  mode = "markers",
                  marker = list(sizeref = 0.3, color = ~factor(p.adjust))) %>%
        layout(title = "KEGG Over-representation Pathways",
               xaxis = list(title = "GeneRatio"), #showgrid = F
               yaxis = list(title = ""),#showgrid = F
               showlegend = TRUE,
               legend=list(title = list(text='p.adjust')))

      keggORAFigure
      } else {
        pathdata.wiki.ora.run <- enrichWP(gene = gene,
                                            organism = "Homo sapiens",
                                            pvalueCutoff = input$adjPvalue,
                                            pAdjustMethod = input$pvaladj
                                            )
        pathdata.wiki.ora.tmp <- as.data.frame(pathdata.wiki.ora.run)

        tmp1 <- pathdata.wiki.ora.tmp %>%
        separate(GeneRatio, c("GeneR1", "GeneR2"), "/")
        tmp1$GeneRatio <- as.numeric(tmp1$GeneR1)/as.numeric(tmp1$GeneR2)
        pathdata.wiki.ora.tmp$GeneRatio <- tmp1$GeneRatio
        tmp2 <- pathdata.wiki.ora.tmp %>%
          separate(BgRatio, c("bg1", "bg2"), "/")
        tmp2$BgRatio <- as.numeric(tmp2$bg1)/as.numeric(tmp2$bg2)
        pathdata.wiki.ora.tmp$BgRatio <- tmp2$BgRatio

        pathdata.wiki.ora1 <- pathdata.wiki.ora.tmp[1:input$numPath,]

        wikiORAFigure <- plot_ly() %>%
        add_trace(data = pathdata.wiki.ora1,
                  x = ~GeneRatio,
                  y = ~Description,
                  size = ~Count,
                  type = "scatter",
                  color = ~p.adjust,
                  colors = c("red", "white", "blue"),
                  alpha = 1,
                  text = ~paste('</br> Pathway = ', Description,
                                '</br> GeneRatio = ', GeneRatio,
                                '</br> Count = ', Count,
                                '</br> FDR = ', p.adjust),
                  name = "",
                  hoverinfo = 'text',
                  texttemplate = '%{y: .3s}', textposition = 'outside',
                  mode = "markers",
                  marker = list(sizeref = 0.3, color = ~factor(p.adjust))) %>%
        layout(title = "Wikipathways Over-representation Pathways",
               xaxis = list(title = "GeneRatio"), #showgrid = F
               yaxis = list(title = ""),#showgrid = F
               showlegend = TRUE,
               legend=list(title = list(text='p.adjust')))

      wikiORAFigure
      }
    } else {
      if(input$pathDB == "1") {
      pathdata.reactome.gsea.run <- gsePathway(geneList,
                                               pvalueCutoff = input$adjPvalue,
                                               organism = "human",
                                               exponent = 1,
                                               minGSSize = 10,
                                               maxGSSize = 500,
                                               eps = 0,
                                               pAdjustMethod = input$pvaladj,
                                               verbose = FALSE,
                                               by = "fgsea")
      # GSEA figure
      pathdata.reactome.gsea.tmp <- as.data.frame(pathdata.reactome.gsea.run)
      # visualization of the pathway analysis result
      pathdata.reactome.gsea1 <- pathdata.reactome.gsea.tmp[1:input$numPath,]

      reactomeGSEAFigure <- plot_ly() %>%
        add_trace(data = pathdata.reactome.gsea1,
                  x = ~enrichmentScore,
                  y = ~Description,
                  size = ~setSize,
                  type = "scatter",
                  color = ~p.adjust,
                  colors = c("red", "white", "blue"),
                  alpha = 1,
                  text = ~paste('</br> Pathway = ', Description,
                                '</br> enrichmentScore = ', enrichmentScore,
                                '</br> Count = ', setSize,
                                '</br> FDR = ', p.adjust),
                  name = "",
                  hoverinfo = 'text',
                  texttemplate = '%{y: .3s}', textposition = 'outside',
                  mode = "markers",
                  marker = list(sizeref = 0.3, color = ~factor(p.adjust))) %>%
        layout(title = "Reactome Gene Set Enrichment Analysis Pathways",
               xaxis = list(title = "enrichmentScore"), #showgrid = F
               yaxis = list(title = ""),#showgrid = F
               showlegend = TRUE,
               legend=list(title = list(text='p.adjust')))

      reactomeGSEAFigure
      } else if (input$pathDB == "2") {
      pathdata.kegg.gsea.run <- gseKEGG(geneList,
                                               pvalueCutoff = input$adjPvalue,
                                               organism = "hsa",
                                               exponent = 1,
                                               minGSSize = 10,
                                               maxGSSize = 500,
                                               eps = 0,
                                               pAdjustMethod = input$pvaladj,
                                               verbose = FALSE,
                                               by = "fgsea")
      # GSEA figure
      pathdata.kegg.gsea.tmp <- as.data.frame(pathdata.kegg.gsea.run)
      # visualization of the pathway analysis result
      pathdata.kegg.gsea1 <- pathdata.kegg.gsea.tmp[1:input$numPath,]

      keggGSEAFigure <- plot_ly() %>%
        add_trace(data = pathdata.kegg.gsea1,
                  x = ~enrichmentScore,
                  y = ~Description,
                  size = ~setSize,
                  type = "scatter",
                  color = ~p.adjust,
                  colors = c("red", "white", "blue"),
                  alpha = 1,
                  text = ~paste('</br> Pathway = ', Description,
                                '</br> enrichmentScore = ', enrichmentScore,
                                '</br> Count = ', setSize,
                                '</br> FDR = ', p.adjust),
                  name = "",
                  hoverinfo = 'text',
                  texttemplate = '%{y: .3s}', textposition = 'outside',
                  mode = "markers",
                  marker = list(sizeref = 0.3, color = ~factor(p.adjust))) %>%
        layout(title = "KEGG Gene Set Enrichment Analysis Pathways",
               xaxis = list(title = "enrichmentScore"), #showgrid = F
               yaxis = list(title = ""),#showgrid = F
               showlegend = TRUE,
               legend=list(title = list(text='p.adjust')))

      keggGSEAFigure
      } else {
      pathdata.wiki.gsea.run <- gseWP(geneList,
                                               pvalueCutoff = input$adjPvalue,
                                               organism = "Homo sapiens",
                                               #exponent = 1,
                                               minGSSize = 10,
                                               maxGSSize = 500,
                                               #eps = 0,
                                               pAdjustMethod = input$pvaladj,
                                               #verbose = FALSE,
                                               #by = "fgsea"
                                               )
      # GSEA figure
      pathdata.wiki.gsea.tmp <- as.data.frame(pathdata.wiki.gsea.run)
      #write.table(pathdata.wiki.gsea.run, 
      #              file = file.path(global$datapath,"pathdatawikigsea.txt"), 
      #              sep = "\t",
      #              quote = FALSE)
      # visualization of the pathway analysis result
      pathdata.wiki.gsea1 <- pathdata.wiki.gsea.tmp[1:input$numPath,]

      wikiGSEAFigure <- plot_ly() %>%
        add_trace(data = pathdata.wiki.gsea1,
                  x = ~enrichmentScore,
                  y = ~Description,
                  size = ~setSize,
                  type = "scatter",
                  color = ~p.adjust,
                  colors = c("red", "white", "blue"),
                  alpha = 1,
                  text = ~paste('</br> Pathway = ', Description,
                                '</br> enrichmentScore = ', enrichmentScore,
                                '</br> Count = ', setSize,
                                '</br> FDR = ', p.adjust),
                  name = "",
                  hoverinfo = 'text',
                  texttemplate = '%{y: .3s}', textposition = 'outside',
                  mode = "markers",
                  marker = list(sizeref = 0.3, color = ~factor(p.adjust))) %>%
        layout(title = "Wikipathways Gene Set Enrichment Analysis Pathways",
               xaxis = list(title = "enrichmentScore"), #showgrid = F
               yaxis = list(title = ""),#showgrid = F
               showlegend = TRUE,
               legend=list(title = list(text='p.adjust')))

      wikiGSEAFigure
      }
    }
  })

  pathPlot2 <- eventReactive(input$rundemopath, {
    id_pathplot2 <- showNotification("generating plot, please wait...", duration = NULL, closeButton = FALSE)
    on.exit(removeNotification(id_pathplot2), add = TRUE)

    #filepath <- input$file7
    #ext <- tools::file_ext(filepath$datapath)

    #req(filepath)
    #validate(need(ext == "csv", "Please upload a csv file"))

    pathdata <- read.delim('data/demodata.txt', sep = "\t", row.names = 1)

    suppressMessages(suppressWarnings(library(ReactomePA)))
    suppressMessages(suppressWarnings(library(clusterProfiler)))
    suppressMessages(suppressWarnings(library(dplyr)))
    suppressMessages(suppressWarnings(library(org.Hs.eg.db)))

    # prepare the input gene list for pathway analysis
    pathdata1 <- c(data.frame(pathdata$gene), data.frame(pathdata$logFC))
    geneIDconv <- bitr(pathdata1$pathdata.gene, fromType="SYMBOL", toType="ENTREZID", OrgDb="org.Hs.eg.db")
    names(pathdata1)[1] <- "SYMBOL"
    pathdata2 <- merge(pathdata1, geneIDconv, by = "SYMBOL")
    geneList <- pathdata2[,2]
    names(geneList) <- as.character(pathdata2[,3])
    geneList = sort(geneList, decreasing = TRUE)
    gene <- names(geneList)[abs(geneList) > 0]


    datatype <- reactive({
      switch(input$pathType,
             "Over representation analysis" = 1,
             "Gene set enrichment analysis" = 2)
    })

    if(input$pathType == "1") {
      pathdata.reactome.ora.run <- enrichPathway(gene = gene,
                                                 pvalueCutoff=input$adjPvalue,
                                                 pAdjustMethod = input$pvaladj,
                                                 readable = T)

      pathdata.reactome.ora.tmp <- as.data.frame(pathdata.reactome.ora.run)

      tmp1 <- pathdata.reactome.ora.tmp %>%
        separate(GeneRatio, c("GeneR1", "GeneR2"), "/")
      tmp1$GeneRatio <- as.numeric(tmp1$GeneR1)/as.numeric(tmp1$GeneR2)
      pathdata.reactome.ora.tmp$GeneRatio <- tmp1$GeneRatio
      tmp2 <- pathdata.reactome.ora.tmp %>%
        separate(BgRatio, c("bg1", "bg2"), "/")
      tmp2$BgRatio <- as.numeric(tmp2$bg1)/as.numeric(tmp2$bg2)
      pathdata.reactome.ora.tmp$BgRatio <- tmp2$BgRatio

      # visualization of the pathway analysis result
      pathdata.reactome.ora1 <- pathdata.reactome.ora.tmp[1:input$numPath,]

      reactomeORAFigure <- plot_ly() %>%
        add_trace(data = pathdata.reactome.ora1,
                  x = ~GeneRatio,
                  y = ~Description,
                  size = ~Count,
                  type = "scatter",
                  color = ~p.adjust,
                  colors = c("red", "white", "blue"),
                  alpha = 1,
                  text = ~paste('</br> Pathway = ', Description,
                                '</br> GeneRatio = ', GeneRatio,
                                '</br> Count = ', Count,
                                '</br> FDR = ', p.adjust),
                  name = "",
                  hoverinfo = 'text',
                  texttemplate = '%{y: .3s}', textposition = 'outside',
                  mode = "markers",
                  marker = list(sizeref = 0.3, color = ~factor(p.adjust))) %>%
        layout(title = "Reactome Over-representation Pathways",
               xaxis = list(title = "GeneRatio"), #showgrid = F
               yaxis = list(title = ""),#showgrid = F
               showlegend = TRUE,
               legend=list(title = list(text='p.adjust')))

      reactomeORAFigure

    } else {
      pathdata.reactome.gsea.run <- gsePathway(geneList,
                                               pvalueCutoff = input$adjPvalue,
                                               organism = "human",
                                               exponent = 1,
                                               minGSSize = 10,
                                               maxGSSize = 500,
                                               eps = 0,
                                               pAdjustMethod = input$pvaladj,
                                               verbose = FALSE,
                                               by = "fgsea")
      # GSEA figure
      pathdata.reactome.gsea.tmp <- as.data.frame(pathdata.reactome.gsea.run)
      # visualization of the pathway analysis result
      pathdata.reactome.gsea1 <- pathdata.reactome.gsea.tmp[1:input$numPath,]

      reactomeGSEAFigure <- plot_ly() %>%
        add_trace(data = pathdata.reactome.gsea1,
                  x = ~enrichmentScore,
                  y = ~Description,
                  size = ~setSize,
                  type = "scatter",
                  color = ~p.adjust,
                  colors = c("red", "white", "blue"),
                  alpha = 1,
                  text = ~paste('</br> Pathway = ', Description,
                                '</br> enrichmentScore = ', enrichmentScore,
                                '</br> Count = ', setSize,
                                '</br> FDR = ', p.adjust),
                  name = "",
                  hoverinfo = 'text',
                  texttemplate = '%{y: .3s}', textposition = 'outside',
                  mode = "markers",
                  marker = list(sizeref = 0.3, color = ~factor(p.adjust))) %>%
        layout(title = "Reactome Gene Set Enrichment Analysis Pathways",
               xaxis = list(title = "enrichmentScore"), #showgrid = F
               yaxis = list(title = ""),#showgrid = F
               showlegend = TRUE,
               legend=list(title = list(text='p.adjust')))

      reactomeGSEAFigure
    }

  })

  output$pathplot <- renderPlotly({
    # print(pathPlot1())
    if(input$Run) {pathPlot1()}
    else {pathPlot2()}
  })

  output$downloadpath <- downloadHandler(
    filename = function() { paste0("Figure: Pathway Enrichment Analysis", Sys.time(), ".html", sep='') },
    content = function(figure) {
      #Cairo::png(figure, height = 11, width = 8, res = 300, units = "in")
      #ggsave(figure, p1, width = 8, height = 11, units = "in")
      htmlwidgets::saveWidget(as_widget(pathPlot1()), figure, selfcontained = TRUE)
      #dev.off()
    })

  ##1.2 Generate an HTML table view of the data
  #data1 <- reactive({


  output$tablepath <- DT::renderDataTable(server=FALSE,{
    id_pathtab1 <- showNotification("generating table, please wait...", duration = NULL, closeButton = FALSE)
    on.exit(removeNotification(id_pathtab1), add = TRUE)

    datatype <- eventReactive(input$Run, {
      switch(input$pathType,
             "Over representation analysis" = 1,
             "Gene set enrichment analysis" = 2)
    })
    pathwaydata <- input$file7
    ext <- tools::file_ext(pathwaydata$datapath)

    req(pathwaydata)
    #validate(need(ext == "csv", "Please upload a csv file"))

    pathdata <- read.delim(pathwaydata$datapath, sep = "\t", row.names = 1)
    pathdata1 <- c(data.frame(pathdata$gene), data.frame(pathdata$logFC))
    geneIDconv <- bitr(pathdata1$pathdata.gene, fromType="SYMBOL", toType="ENTREZID", OrgDb="org.Hs.eg.db")
    names(pathdata1)[1] <- "SYMBOL"
    pathdata2 <- merge(pathdata1, geneIDconv, by = "SYMBOL")
    geneList <- pathdata2[,2]
    names(geneList) <- as.character(pathdata2[,3])
    geneList = sort(geneList, decreasing = TRUE)
    gene <- names(geneList)[abs(geneList) > 0]


    if(input$pathType == "1") {
      if(input$pathDB == "1") {
      pathdata.reactome.ora.run <- enrichPathway(gene = gene,
                                                 pvalueCutoff=input$adjPvalue,
                                                 pAdjustMethod = input$pvaladj,
                                                 readable = T)
      pathdata.reactome.ora1 <- as.data.frame(pathdata.reactome.ora.run)

      tmp1 <- pathdata.reactome.ora1 %>%
        separate(GeneRatio, c("GeneR1", "GeneR2"), "/")
      tmp1$GeneRatio <- as.numeric(tmp1$GeneR1)/as.numeric(tmp1$GeneR2)
      pathdata.reactome.ora1$GeneRatio <- tmp1$GeneRatio
      tmp2 <- pathdata.reactome.ora1 %>%
        separate(BgRatio, c("bg1", "bg2"), "/")
      tmp2$BgRatio <- as.numeric(tmp2$bg1)/as.numeric(tmp2$bg2)
      pathdata.reactome.ora1$BgRatio <- tmp2$BgRatio

      tableReactomeORA  = data.frame(
        ReactomeID = pathdata.reactome.ora1$ID,
        ReactomePathway = pathdata.reactome.ora1$Description,
        GeneRatio = pathdata.reactome.ora1$GeneRatio,
        BgRatio = pathdata.reactome.ora1$BgRatio,
        pvalue = pathdata.reactome.ora1$pvalue,
        p.adjust = pathdata.reactome.ora1$p.adjust,
        qval = pathdata.reactome.ora1$qvalue,
        geneID = pathdata.reactome.ora1$geneID,
        GeneCount = pathdata.reactome.ora1$Count)

      DT::datatable(
        tableReactomeORA,
        extensions = 'Buttons',
        options = list(
          paging = TRUE,
          searching = TRUE,
          fixedColumns = TRUE,
          autowidth = TRUE,
          ordering = TRUE,
          dom = 'Bfrtip',
          scrollX = TRUE,
          buttons = list(
            list(extend = "excel", text = "Download current page", filename = "page",
                 exportOptions = list(
                   modifier = list(page = "current")
                 )
            ),
            list(extend = "excel", text = "Download full result", filename = "data",
                 exportOptions = list(
                   modifier = list(page="all")
                 ))
          )
        ), class = "display"
      )
      } else if(input$pathDB == "2"){
        pathdata.kegg.ora.run <- enrichKEGG(gene = gene,
                                            organism = "hsa",
                                            pvalueCutoff=input$adjPvalue,
                                            pAdjustMethod = input$pvaladj
                                            #     readable = T
                                            )
        pathdata.kegg.ora1 <- as.data.frame(pathdata.kegg.ora.run)

        tmp1 <- pathdata.kegg.ora1 %>%
          separate(GeneRatio, c("GeneR1", "GeneR2"), "/")
        tmp1$GeneRatio <- as.numeric(tmp1$GeneR1)/as.numeric(tmp1$GeneR2)
        pathdata.kegg.ora1$GeneRatio <- tmp1$GeneRatio
        tmp2 <- pathdata.kegg.ora1 %>%
          separate(BgRatio, c("bg1", "bg2"), "/")
        tmp2$BgRatio <- as.numeric(tmp2$bg1)/as.numeric(tmp2$bg2)
        pathdata.kegg.ora1$BgRatio <- tmp2$BgRatio

        tablekeggORA  = data.frame(
          KEGGID = pathdata.kegg.ora1$ID,
          KEGGPathway = pathdata.kegg.ora1$Description,
          GeneRatio = pathdata.kegg.ora1$GeneRatio,
          BgRatio = pathdata.kegg.ora1$BgRatio,
          pvalue = pathdata.kegg.ora1$pvalue,
          p.adjust = pathdata.kegg.ora1$p.adjust,
          qval = pathdata.kegg.ora1$qvalue,
          geneID = pathdata.kegg.ora1$geneID,
          GeneCount = pathdata.kegg.ora1$Count)

        DT::datatable(
          tablekeggORA,
          extensions = 'Buttons',
          options = list(
            paging = TRUE,
            searching = TRUE,
            fixedColumns = TRUE,
            autowidth = TRUE,
            ordering = TRUE,
            dom = 'Bfrtip',
            scrollX = TRUE,
            buttons = list(
              list(extend = "excel", text = "Download current page", filename = "page",
                 exportOptions = list(
                   modifier = list(page = "current")
                 )
            ),
              list(extend = "excel", text = "Download full result", filename = "data",
                 exportOptions = list(
                   modifier = list(page="all")
                 ))
          )
        ), class = "display"
      )
      } else {
        pathdata.wiki.ora.run <- enrichWP(gene = gene,
                                            organism = "Homo sapiens",
                                            pvalueCutoff = input$adjPvalue,
                                            pAdjustMethod = input$pvaladj
                                            )
        pathdata.wiki.ora1 <- as.data.frame(pathdata.wiki.ora.run)

        tmp1 <- pathdata.wiki.ora1 %>%
          separate(GeneRatio, c("GeneR1", "GeneR2"), "/")
        tmp1$GeneRatio <- as.numeric(tmp1$GeneR1)/as.numeric(tmp1$GeneR2)
        pathdata.wiki.ora1$GeneRatio <- tmp1$GeneRatio
        tmp2 <- pathdata.wiki.ora1 %>%
          separate(BgRatio, c("bg1", "bg2"), "/")
        tmp2$BgRatio <- as.numeric(tmp2$bg1)/as.numeric(tmp2$bg2)
        pathdata.wiki.ora1$BgRatio <- tmp2$BgRatio

        tablewikiORA  = data.frame(
          WikiID = pathdata.wiki.ora1$ID,
          WikiPathway = pathdata.wiki.ora1$Description,
          GeneRatio = pathdata.wiki.ora1$GeneRatio,
          BgRatio = pathdata.wiki.ora1$BgRatio,
          pvalue = pathdata.wiki.ora1$pvalue,
          p.adjust = pathdata.wiki.ora1$p.adjust,
          qval = pathdata.wiki.ora1$qvalue,
          geneID = pathdata.wiki.ora1$geneID,
          GeneCount = pathdata.wiki.ora1$Count)

        DT::datatable(
          tablewikiORA,
          extensions = 'Buttons',
          options = list(
            paging = TRUE,
            searching = TRUE,
            fixedColumns = TRUE,
            autowidth = TRUE,
            ordering = TRUE,
            dom = 'Bfrtip',
            scrollX = TRUE,
            buttons = list(
              list(extend = "excel", text = "Download current page", filename = "page",
                 exportOptions = list(
                   modifier = list(page = "current")
                 )
            ),
              list(extend = "excel", text = "Download full result", filename = "data",
                 exportOptions = list(
                   modifier = list(page="all")
                 ))
          )
        ), class = "display"
      )
      }
    } else {
      if(input$pathDB == "1") {
        pathdata.reactome.gsea.run <- gsePathway(geneList,
                                               pvalueCutoff = input$adjPvalue,
                                               organism = "human",
                                               exponent = 1,
                                               minGSSize = 10,
                                               maxGSSize = 500,
                                               eps = 0,
                                               pAdjustMethod = input$pvaladj,
                                               verbose = FALSE,
                                               by = "fgsea")
      # GSEA table
      pathdata.reactome.gsea.tmp <- as.data.frame(pathdata.reactome.gsea.run)

      tableReactomeGSEA  = data.frame(
        ReactomeID = pathdata.reactome.gsea.tmp$ID,
        ReactomePathway = pathdata.reactome.gsea.tmp$Description,
        setSize = pathdata.reactome.gsea.tmp$setSize,
        enrichmentScore = pathdata.reactome.gsea.tmp$enrichmentScore,
        pvalue = pathdata.reactome.gsea.tmp$pvalue,
        p.adjust = pathdata.reactome.gsea.tmp$p.adjust,
        qval = pathdata.reactome.gsea.tmp$qvalues,
        rank = pathdata.reactome.gsea.tmp$rank,
        leading_edge = pathdata.reactome.gsea.tmp$leading_edge,
        core_enrichment = pathdata.reactome.gsea.tmp$core_enrichment
      )

      DT::datatable(
        tableReactomeGSEA,
        extensions = 'Buttons',
        options = list(
          paging = TRUE,
          searching = TRUE,
          fixedColumns = TRUE,
          autowidth = TRUE,
          ordering = TRUE,
          dom = 'Bfrtip',
          scrollX = TRUE,
          buttons = list(
            list(extend = "excel", text = "Download current page", filename = "page",
                 exportOptions = list(
                   modifier = list(page = "current")
                 )
            ),
            list(extend = "excel", text = "Download full results", filename = "data",
                 exportOptions = list(
                   modifier = list(page="all")
                 ))
          )
        ), class = "display"
      )
      } else if(input$pathDB == "2"){
        pathdata.kegg.gsea.run <- gseKEGG(geneList,
                                               pvalueCutoff = input$adjPvalue,
                                               organism = "hsa",
                                               exponent = 1,
                                               minGSSize = 10,
                                               maxGSSize = 500,
                                               eps = 0,
                                               pAdjustMethod = input$pvaladj,
                                               verbose = FALSE,
                                               by = "fgsea")
      # GSEA table
      pathdata.kegg.gsea.tmp <- as.data.frame(pathdata.kegg.gsea.run)

      tablekeggGSEA  = data.frame(
        KEGGID = pathdata.kegg.gsea.tmp$ID,
        KEGGPathway = pathdata.kegg.gsea.tmp$Description,
        setSize = pathdata.kegg.gsea.tmp$setSize,
        enrichmentScore = pathdata.kegg.gsea.tmp$enrichmentScore,
        NES = pathdata.kegg.gsea.tmp$NES,
        pvalue = pathdata.kegg.gsea.tmp$pvalue,
        p.adjust = pathdata.kegg.gsea.tmp$p.adjust,
        qval = pathdata.kegg.gsea.tmp$qvalues,
        rank = pathdata.kegg.gsea.tmp$rank,
        leading_edge = pathdata.kegg.gsea.tmp$leading_edge,
        core_enrichment = pathdata.kegg.gsea.tmp$core_enrichment
      )

      DT::datatable(
        tablekeggGSEA,
        extensions = 'Buttons',
        options = list(
          paging = TRUE,
          searching = TRUE,
          fixedColumns = TRUE,
          autowidth = TRUE,
          ordering = TRUE,
          dom = 'Bfrtip',
          scrollX = TRUE,
          buttons = list(
            list(extend = "excel", text = "Download current page", filename = "page",
                 exportOptions = list(
                   modifier = list(page = "current")
                 )
            ),
            list(extend = "excel", text = "Download full results", filename = "data",
                 exportOptions = list(
                   modifier = list(page="all")
                 ))
          )
        ), class = "display"
      )
      } else {
        pathdata.wiki.gsea.run <- gseWP(geneList,
                                               pvalueCutoff = input$adjPvalue,
                                               organism = "Homo sapiens",
                                               #exponent = 1,
                                               minGSSize = 10,
                                               maxGSSize = 500,
                                               #eps = 0,
                                               pAdjustMethod = input$pvaladj,
                                               #verbose = FALSE,
                                               #by = "fgsea"
                                               )
      # GSEA figure
      pathdata.wiki.gsea.tmp <- as.data.frame(pathdata.wiki.gsea.run)
      
      tablewikiGSEA  = data.frame(
        WikiID = pathdata.wiki.gsea.tmp$ID,
        WikiPathway = pathdata.wiki.gsea.tmp$Description,
        setSize = pathdata.wiki.gsea.tmp$setSize,
        enrichmentScore = pathdata.wiki.gsea.tmp$enrichmentScore,
        NES = pathdata.wiki.gsea.tmp$NES,
        pvalue = pathdata.wiki.gsea.tmp$pvalue,
        p.adjust = pathdata.wiki.gsea.tmp$p.adjust,
        qval = pathdata.wiki.gsea.tmp$qvalues,
        rank = pathdata.wiki.gsea.tmp$rank,
        leading_edge = pathdata.wiki.gsea.tmp$leading_edge,
        core_enrichment = pathdata.wiki.gsea.tmp$core_enrichment
      )

      DT::datatable(
        tablewikiGSEA,
        extensions = 'Buttons',
        options = list(
          paging = TRUE,
          searching = TRUE,
          fixedColumns = TRUE,
          autowidth = TRUE,
          ordering = TRUE,
          dom = 'Bfrtip',
          scrollX = TRUE,
          buttons = list(
            list(extend = "excel", text = "Download current page", filename = "page",
                 exportOptions = list(
                   modifier = list(page = "current")
                 )
            ),
            list(extend = "excel", text = "Download full results", filename = "data",
                 exportOptions = list(
                   modifier = list(page="all")
                 ))
          )
        ), class = "display"
      )
      }
    }
    #}

  })

#=================================#
  #2.1 Generate the Volcano plot
#=================================#
  volplot1 <- eventReactive(input$runVol, {
    id_vol1 <- showNotification("generating plot, please wait...", duration = NULL, closeButton = FALSE)
    on.exit(removeNotification(id_vol1), add = TRUE)

    #volplot1 <- reactive({
    fileVol <- input$fileVol
    ext <- tools::file_ext(fileVol$datapath)
    req(fileVol)
    voldata <- read.delim(fileVol$datapath, sep = "\t", row.names = 1)
    voldata1 <- voldata
    voldata1$CpGID <- rownames(voldata)
    voldata1["group"] <- "NotSignificant"
    voldata1[which(voldata1['adj.P.Val'] > input$volp & abs(voldata1['logFC']) < input$volfc), "group"] <- "Significant"
    voldata1[which(voldata1['adj.P.Val'] > input$volp & abs(voldata1['logFC']) > input$volfc), "group"] <- "FoldChange"
    voldata1[which(voldata1['adj.P.Val'] < input$volp & abs(voldata1['logFC']) > input$volfc), "group"] <- "Significant&FoldChange"
    sfc <- grep("Significant&FoldChange", voldata1$group)
    top_peaks <- voldata1[with(voldata1, sfc),]

    a <- list()
    for(i in seq_len(nrow(top_peaks))){
      m <- top_peaks[i, ]
      a[[i]] <- list(
        x = m[["logFC"]],
        y = -log10(m[["adj.P.Val"]]),
        text = m[["CpGID"]],
        xref = "x",
        yref = "y",
        showarrow = TRUE,
        arrowhead = 0.5,
        ax = 20,
        ay = -40
      )
    }

    volpl <- plot_ly(data = voldata1,
                     x = voldata1$logFC,
                     y = -log10(voldata1$adj.P.Val),
                     text = voldata1$CpGID,
                     mode = "markers",
                     color = voldata1$group) %>%
      layout(title = "Volcano plot") %>%
      layout(annotation = a)

    volpl
  })

  volplot2 <- eventReactive(input$runvoldemo, {
    id_vol2 <- showNotification("generating plot, please wait...", duration = NULL, closeButton = FALSE)
    on.exit(removeNotification(id_vol2), add = TRUE)

    #volplot1 <- reactive({
    #fileVol <- input$fileVol
    #ext <- tools::file_ext(fileVol$datapath)
    #req(fileVol)
    voldata <- read.delim('data/demodata.txt', sep = "\t", row.names = 1)
    voldata1 <- voldata
    voldata1$CpGID <- rownames(voldata)
    voldata1["group"] <- "NotSignificant"
    voldata1[which(voldata1['adj.P.Val'] > input$volp & abs(voldata1['logFC']) < input$volfc), "group"] <- "Significant"
    voldata1[which(voldata1['adj.P.Val'] > input$volp & abs(voldata1['logFC']) > input$volfc), "group"] <- "FoldChange"
    voldata1[which(voldata1['adj.P.Val'] < input$volp & abs(voldata1['logFC']) > input$volfc), "group"] <- "Significant&FoldChange"
    sfc <- grep("Significant&FoldChange", voldata1$group)
    top_peaks <- voldata1[with(voldata1, sfc),]

    a <- list()
    for(i in seq_len(nrow(top_peaks))){
      m <- top_peaks[i, ]
      a[[i]] <- list(
        x = m[["logFC"]],
        y = -log10(m[["adj.P.Val"]]),
        text = m[["CpGID"]],
        xref = "x",
        yref = "y",
        showarrow = TRUE,
        arrowhead = 0.5,
        ax = 20,
        ay = -40
      )
    }

    volpl <- plot_ly(data = voldata1,
                     x = voldata1$logFC,
                     y = -log10(voldata1$adj.P.Val),
                     text = voldata1$CpGID,
                     mode = "markers",
                     color = voldata1$group) %>%
      layout(title = "Volcano plot") %>%
      layout(annotation = a)

    volpl
  })

  output$volplot <- renderPlotly({
    # print(pathPlot1())
    if(input$runVol) {volplot1()}
    else {volplot2()}
  })

  output$downloadvolcano <- downloadHandler(
    filename = function() { paste0("Volcano_Plot", ".html", sep='') },
    content = function(figure2) {
      htmlwidgets::saveWidget(as_widget(volplot1()), figure2, selfcontained = TRUE)
    })


  ##2.2 Generate an HTML table view of Volcano data
  output$tablevolcano <- DT::renderDataTable(server=FALSE,{
    fileVol <- input$fileVol
    ext <- tools::file_ext(fileVol$datapath)
    req(fileVol)
    voldata <- read.delim(fileVol$datapath, sep = "\t", row.names = 1)

    voldata1 <- voldata

    voldata1$CpGID <- rownames(voldata)
    voldata1["group"] <- "NotSignificant"
    voldata1[which(voldata1['adj.P.Val'] > 0.05 & abs(voldata1['logFC']) < 0.3), "group"] <- "Significant"
    voldata1[which(voldata1['adj.P.Val'] > 0.05 & abs(voldata1['logFC']) > 0.3), "group"] <- "FoldChange"
    voldata1[which(voldata1['adj.P.Val'] < 0.05 & abs(voldata1['logFC']) > 0.3), "group"] <- "Significant&FoldChange"

    volcdata = data.frame(
      CpGID = voldata1$CpGID,
      logFC = voldata1$logFC,
      adj.P.Val = voldata1$adj.P.Val,
      group = voldata1$group
    )

    DT::datatable(
      volcdata,
      extensions = 'Buttons',
      options = list(
        paging = TRUE,
        searching = TRUE,
        fixedColumns = TRUE,
        autowidth = TRUE,
        ordering = TRUE,
        dom = 'Bfrtip',
        scrollX = TRUE,
        buttons = list(
          list(extend = "excel", text = "Download current page", filename = "page",
               exportOptions = list(
                 modifier = list(page = "current")
               )
          ),
          list(extend = "excel", text = "Download full results", filename = "data",
               exportOptions = list(
                 modifier = list(page="all")
               ))
        )
      ), class = "display"
    )
  })


  ##========================================####
  #6. Gene Ontology analysis
  ##========================================####

  #6.1 GO enrichment plot
  goPlot1 <- eventReactive(input$goRun, {
    id_go1 <- showNotification("generating plot, please wait...", duration = NULL, closeButton = FALSE)
    on.exit(removeNotification(id_go1), add = TRUE)

    file6 <- input$file6
    ext <- tools::file_ext(file6$datapath)

    req(file6)

    godata <- read.delim(file6$datapath, sep = "\t", row.names = 1)

    # prepare the input gene list for pathway analysis
    godata1 <- cbind(data.frame(godata$gene), data.frame(godata$logFC))
    geneIDconv <- bitr(godata1$godata.gene, fromType="SYMBOL", toType="ENTREZID", OrgDb="org.Hs.eg.db")
    names(godata1)[1] <- "SYMBOL"
    godata2 <- merge(godata1, geneIDconv, by = "SYMBOL")
    geneList <- godata2[,2]
    names(geneList) <- as.character(godata2[,3])
    geneList = sort(geneList, decreasing = TRUE)
    gene <- names(geneList)[abs(geneList) > 0]

    datatype <- reactive({
      switch(input$goType,
             "Over representation analysis" = 1,
             "Gene set enrichment analysis" = 2)
    })

    if(input$goType == "1") {
      godata.ora.run <- enrichGO(gene = gene,
                                 #universe= names(geneList),
                                 OrgDb = org.Hs.eg.db,
                                 ont= "ALL",
                                 pAdjustMethod = input$pvaladj,
                                 pvalueCutoff  = input$numpval,
                                 qvalueCutoff  = input$numqval,
                                 #eps = 0,
                                 readable = TRUE)

      godata.ora.tmp <- data.frame(godata.ora.run@result)

      tmp1 <- godata.ora.tmp %>%
        separate(GeneRatio, c("GeneR1", "GeneR2"), "/")
      tmp1$GeneRatio <- as.numeric(tmp1$GeneR1)/as.numeric(tmp1$GeneR2)
      godata.ora.tmp$GeneRatio <- tmp1$GeneRatio
      tmp2 <- godata.ora.tmp %>%
        separate(BgRatio, c("bg1", "bg2"), "/")
      tmp2$BgRatio <- as.numeric(tmp2$bg1)/as.numeric(tmp2$bg2)
      #godata.ora.tmp$BgRatio <- tmp2$BgRatio

      # visualization of the pathway analysis result
      godata.ora1 <- godata.ora.tmp#[1:input$num,]

      data <- data.frame(godata.ora1$ONTOLOGY, godata.ora1$p.adjust, godata.ora1$Description, stringsAsFactors = FALSE)
      data$godata.ora1.ONTOLOGY <- sort(data$godata.ora1.ONTOLOGY, decreasing = TRUE)

      if(input$ontology == "BP") {
        data.bp <- data[data$godata.ora1.ONTOLOGY == "BP",]
        data.bp.num <- data.bp[1:input$gonum,]
        #figure_ont <- plot_ly(data.bp.num, x = ~godata.ora1.p.adjust,y = ~godata.ora1.Description, type = 'bar', name = "GO Biological processes",
        #              marker = list(color = 'rgb(255,118,16'))
       figure_bp <- plot_ly(data.bp.num, x= ~godata.ora1.p.adjust, y = ~godata.ora1.Description, 
                            type = "bar", marker = list(color = 'rgb(0,73,83')) %>%
                            layout(xaxis=list(title = 'adjusted p-value',type='category', 
                                          nticks = 10),
                                  yaxis = list(title = 'Gene Ontology: Biological Process'))

        figure_bp
      } else if (input$ontology == "CC"){
        data.cc <- data[data$godata.ora1.ONTOLOGY == "CC",]
        data.cc.num <- data.cc[1:input$gonum,]
        figure_cc <- plot_ly(data.cc.num, x= ~godata.ora1.p.adjust, y = ~godata.ora1.Description, 
                            type = "bar", marker = list(color = 'rgb(36,33,36')) %>%
                            layout(xaxis=list(title = 'adjusted p-value',type='category', 
                                          nticks = 10),
                                  yaxis = list(title = 'Gene Ontology: Cellular Component'))
        figure_cc
      } else {
        data.mf <- data[data$godata.ora1.ONTOLOGY == "MF",]
        data.mf.num <- data.mf[1:input$gonum,]
        figure_mf <- plot_ly(data.mf.num, x= ~godata.ora1.p.adjust, y = ~godata.ora1.Description, 
                            type = "bar", marker = list(color = 'rgb(54,69,79')) %>%
                            layout(xaxis=list(title = 'adjusted p-value',type='category', 
                                          nticks = 10),
                                  yaxis = list(title = 'Gene Ontology: Molecular Function'))
        figure_mf
      }
    } else {
      godata.gsea.run <- gseGO(geneList = geneList,
                               OrgDb = org.Hs.eg.db,
                               ont = "ALL",
                               minGSSize = 10,
                               maxGSSize = 500,
                               eps = 0,
                               pvalueCutoff = input$numpval,
                               verbose = FALSE)
      # GSEA figure
      godata.gsea.tmp <- as.data.frame(godata.gsea.run@result)
      # visualization of the pathway analysis result
      godata.gsea1 <- godata.gsea.tmp#[1:input$num,]

      data.gsea <- data.frame(godata.gsea1$ONTOLOGY, godata.gsea1$p.adjust, godata.gsea1$Description)
      data.gsea$godata.gsea1.result.ONTOLOGY <- sort(data.gsea$godata.gsea1.result.ONTOLOGY, decreasing = TRUE)

      if(input$ontology == "BP") {
        data.gsea.bp <- data.gsea[data.gsea$godata.gsea1.ONTOLOGY == "BP",]
        data.gsea.bp.num <- data.gsea.bp[1:input$gonum,]
        figure_bp_gsea <- plot_ly(data.gsea.bp.num, x= ~godata.gsea1.p.adjust, y = ~godata.gsea1.Description, 
                            type = "bar", marker = list(color = 'rgb(0,73,83')) %>%
                            layout(xaxis=list(title = 'adjusted p-value',type='category', 
                                          nticks = 10),
                                  yaxis = list(title = 'Gene Ontology: Biological Process'))
        figure_bp_gsea
      } else if (input$ontology == "CC"){
        data.gsea.cc <- data.gsea[data.gsea$godata.gsea1.ONTOLOGY == "CC",]
        data.gsea.cc.num <- data.gsea.cc[1:input$gonum,]
        figure_cc_gsea <- plot_ly(data.gsea.cc.num, x= ~godata.gsea1.p.adjust, y = ~godata.gsea1.Description, 
                            type = "bar", marker = list(color = 'rgb(36,33,36')) %>%
                            layout(xaxis=list(title = 'adjusted p-value',type='category', 
                                          nticks = 10),
                                  yaxis = list(title = 'Gene Ontology: Cellular Component'))
        figure_cc_gsea
      } else {
        data.gsea.mf <- data.gsea[data.gsea$godata.gsea1.ONTOLOGY == "MF",]
        data.gsea.mf.num <- data.gsea.mf[1:input$gonum,]
        figure_mf_gsea <- plot_ly(data.gsea.mf.num, x= ~godata.gsea1.p.adjust, y = ~godata.gsea1.Description, 
                            type = "bar", marker = list(color = 'rgb(54,69,79')) %>%
                            layout(xaxis=list(title = 'adjusted p-value',type='category', 
                                          nticks = 10),
                                  yaxis = list(title = 'Gene Ontology: Molecular Function'))
        figure_mf_gsea
      }
    }
  })


  goPlot2 <- eventReactive(input$goDemo, {
    id_go2 <- showNotification("generating plot, please wait...", duration = NULL, closeButton = FALSE)
    on.exit(removeNotification(id_go2), add = TRUE)

    #file6 <- input$file6
    #ext <- tools::file_ext(file6$datapath)

    #req(file6)

    godata <- read.delim('data/demodata.txt', sep = "\t", row.names = 1)

    # prepare the input gene list for pathway analysis
    godata1 <- cbind(data.frame(godata$gene), data.frame(godata$logFC))
    geneIDconv <- bitr(godata1$godata.gene, fromType="SYMBOL", toType="ENTREZID", OrgDb="org.Hs.eg.db")
    names(godata1)[1] <- "SYMBOL"
    godata2 <- merge(godata1, geneIDconv, by = "SYMBOL")
    geneList <- godata2[,2]
    names(geneList) <- as.character(godata2[,3])
    geneList = sort(geneList, decreasing = TRUE)
    gene <- names(geneList)[abs(geneList) > 0]

    datatype <- reactive({
      switch(input$goType,
             "Over representation analysis" = 1,
             "Gene set enrichment analysis" = 2)
    })

    if(input$goType == "1") {
      godata.ora.run <- enrichGO(gene = gene,
                                 universe= names(geneList),
                                 OrgDb = org.Hs.eg.db,
                                 ont= "ALL",
                                 pAdjustMethod = "BH",
                                 pvalueCutoff  = input$numpval,
                                 qvalueCutoff  = input$numqval,
                                 #eps = 0,
                                 readable = TRUE)

      godata.ora.tmp <- data.frame(godata.ora.run@result)

      tmp1 <- godata.ora.tmp %>%
        separate(GeneRatio, c("GeneR1", "GeneR2"), "/")
      tmp1$GeneRatio <- as.numeric(tmp1$GeneR1)/as.numeric(tmp1$GeneR2)
      godata.ora.tmp$GeneRatio <- tmp1$GeneRatio
      tmp2 <- godata.ora.tmp %>%
        separate(BgRatio, c("bg1", "bg2"), "/")
      tmp2$BgRatio <- as.numeric(tmp2$bg1)/as.numeric(tmp2$bg2)
      #godata.ora.tmp$BgRatio <- tmp2$BgRatio

      # visualization of the pathway analysis result
      godata.ora1 <- godata.ora.tmp#[1:input$num,]


      # showing only 100 GO classifications
      data <- data.frame(godata.ora1$ONTOLOGY, godata.ora1$pvalue, godata.ora1$Description)
      #data1 <- data[1:100,]
      data$godata.ora1.ONTOLOGY <- sort(data$godata.ora1.ONTOLOGY, decreasing = TRUE)

      data.bp <- data[data$godata.ora1.ONTOLOGY == "BP",]
      data.cc <- data[data$godata.ora1.ONTOLOGY == "CC",]
      data.mf <- data[data$godata.ora1.ONTOLOGY == "MF",]

      data_sort.bp <- data.bp[order(godata.ora1.pvalue),]
      data_sort.cc <- data.cc[order(godata.ora1.pvalue),]
      data_sort.mf <- data.mf[order(godata.ora1.pvalue),]


      fig1 <- plot_ly(data_sort.bp, x = ~godata.ora1.pvalue,y = ~godata.ora1.Description, name = "GO Biological processes",
                      marker = list(color = 'rgb(255,118,16'))
      fig2 <- plot_ly(data_sort.cc, x = ~godata.ora1.pvalue,y = ~godata.ora1.Description, name = "GO Cellular components",
                      marker = list(color = 'rgb(16,255,16'))
      fig3 <- plot_ly(data_sort.mf, x = ~godata.ora1.pvalue,y = ~godata.ora1.Description, name = "GO Molecular functions",
                      marker = list(color = 'rgb(25,118,255'))

      fig.go.ora = subplot(list(fig1, fig2, fig3), nrows = 3, margin = 0.06) %>%
        layout(title = "GO classifications")

      fig.go.ora
    } else {
      godata.gsea.run <- gseGO(geneList = geneList,
                               OrgDb = org.Hs.eg.db,
                               ont = "ALL",
                               minGSSize = 10,
                               maxGSSize = 500,
                               eps = 0,
                               pvalueCutoff = input$numpval,
                               verbose = FALSE)
      # GSEA figure
      godata.gsea.tmp <- as.data.frame(godata.gsea.run@result)
      # visualization of the pathway analysis result
      godata.gsea1 <- godata.gsea.tmp#[1:input$num,]

      data.gsea <- data.frame(godata.gsea1$ONTOLOGY, godata.gsea1$pvalue, godata.gsea1$Description)
      data.gsea$godata.gsea1.result.ONTOLOGY <- sort(data.gsea$godata.gsea1.result.ONTOLOGY, decreasing = TRUE)

      data.gsea.bp <- data.gsea[data.gsea$godata.gsea1.ONTOLOGY == "BP",]
      data.gsea.cc <- data.gsea[data.gsea$godata.gsea1.ONTOLOGY == "CC",]
      data.gsea.mf <- data.gsea[data.gsea$godata.gsea1.ONTOLOGY == "MF",]

      data.gsea.bp20 <- data.gsea.bp[1:20,]
      data.gsea.cc20 <- data.gsea.cc[1:20,]
      data.gsea.mf20 <- data.gsea.mf[1:20,]

      fig1.go.gsea <- plot_ly(data.gsea.bp20, x = ~godata.gsea1.pvalue,y = ~godata.gsea1.Description, name = "GO Biological processes",
                              marker = list(color = 'rgb(255,118,16'))
      fig2.go.gsea <- plot_ly(data.gsea.cc20, x = ~godata.gsea1.pvalue,y = ~godata.gsea1.Description, name = "GO Cellular components",
                              marker = list(color = 'rgb(16,255,16'))
      fig3.go.gsea <- plot_ly(data.gsea.mf20, x = ~godata.gsea1.pvalue,y = ~godata.gsea1.Description, name = "GO Molecular functions",
                              marker = list(color = 'rgb(25,118,255'))

      fig.go.gsea = subplot(list(fig1.go.gsea, fig2.go.gsea, fig3.go.gsea), nrows = 3, margin = 0.1) %>%
        layout(title = "GO classifications")

      fig.go.gsea
    }
  })

  output$goplot <- renderPlotly({
    # print(pathPlot1())
    if(input$goRun) {goPlot1()}
    else {goPlot2()}
  })

  output$downloadGO <- downloadHandler(
    filename = function() { paste0("Figure_GO_Enrichment_Analysis", ".html", sep='') },
    content = function(figure) {
      #Cairo::png(figure, height = 11, width = 8, res = 300, units = "in")
      #ggsave(figure, p1, width = 8, height = 11, units = "in")
      htmlwidgets::saveWidget(as_widget(goPlot1()), figure, selfcontained = TRUE)
      #dev.off()
    })

  ##1.2 Generate an HTML table view of the data
  #data1 <- reactive({

  output$tableGO <- DT::renderDataTable(server=FALSE,{
    id_gotab2 <- showNotification("generating table, please wait...", duration = NULL, closeButton = FALSE)
    on.exit(removeNotification(id_gotab2), add = TRUE)
    
    file6 <- input$file6
    ext <- tools::file_ext(file6$datapath)

    req(file6)

    godata <- read.delim(file6$datapath, sep = "\t", row.names = 1)

    # prepare the input gene list for pathway analysis
    godata1 <- cbind(data.frame(godata$gene), data.frame(godata$logFC))
    geneIDconv <- bitr(godata1$godata.gene, fromType="SYMBOL", toType="ENTREZID", OrgDb="org.Hs.eg.db")
    names(godata1)[1] <- "SYMBOL"
    godata2 <- merge(godata1, geneIDconv, by = "SYMBOL")
    geneList <- godata2[,2]
    names(geneList) <- as.character(godata2[,3])
    geneList = sort(geneList, decreasing = TRUE)
    gene <- names(geneList)[abs(geneList) > 0]

    datatype <- reactive({
      switch(input$goType,
             "Over representation analysis" = 1,
             "Gene set enrichment analysis" = 2)
    })

    if(input$goType == "1") {

      godata.ora.run <- enrichGO(gene = gene,
                                 #universe= names(geneList),
                                 OrgDb = org.Hs.eg.db,
                                 ont= "ALL",
                                 pAdjustMethod = input$pvaladj,
                                 pvalueCutoff  = input$numpval,
                                 qvalueCutoff  = input$numqval,
                                 #eps = 0,
                                 readable = TRUE)

      godata.ora.tmp <- data.frame(godata.ora.run@result)
      #godata.reactome.ora1 <- as.data.frame(godata.reactome.ora.tmp)
      tmp1 <- godata.ora.tmp %>%
        separate(GeneRatio, c("GeneR1", "GeneR2"), "/")
      tmp1$GeneRatio <- as.numeric(tmp1$GeneR1)/as.numeric(tmp1$GeneR2)
      godata.ora.tmp$GeneRatio <- tmp1$GeneRatio
      tmp2 <- godata.ora.tmp %>%
        separate(BgRatio, c("bg1", "bg2"), "/")
      tmp2$BgRatio <- as.numeric(tmp2$bg1)/as.numeric(tmp2$bg2)
      godata.ora.tmp$BgRatio <- tmp2$BgRatio

      tableGOORA  = data.frame(
        GOID = godata.ora.tmp$ID,
        GOclassification = godata.ora.tmp$ONTOLOGY,
        GOdescription = godata.ora.tmp$Description,
        GeneRatio = godata.ora.tmp$GeneRatio,
        BgRatio = godata.ora.tmp$BgRatio,
        pvalue = godata.ora.tmp$pvalue,
        p.adjust = godata.ora.tmp$p.adjust,
        qval = godata.ora.tmp$qvalue,
        geneID = godata.ora.tmp$geneID,
        GeneCount = godata.ora.tmp$Count)

      DT::datatable(
        tableGOORA,
        extensions = 'Buttons',
        options = list(
          paging = TRUE,
          searching = TRUE,
          fixedColumns = TRUE,
          autowidth = TRUE,
          ordering = TRUE,
          dom = 'Bfrtip',
          scrollX = TRUE,
          buttons = list(
            list(extend = "excel", text = "Download current page", filename = "page",
                 exportOptions = list(
                   modifier = list(page = "current")
                 )
            ),
            list(extend = "excel", text = "Download full result", filename = "data",
                 exportOptions = list(
                   modifier = list(page="all")
                 ))
          )
        ), class = "display"
      )} else {
      godata.gsea.run <- gseGO(geneList = geneList,
                               OrgDb = org.Hs.eg.db,
                               ont = "ALL",
                               minGSSize = 10,
                               maxGSSize = 500,
                               pvalueCutoff = input$numpval,
                               keyType = "ENTREZID",
                               exponent = 1,
                               eps = 0,
                               seed = FALSE,
                               by = "fgsea",
                               verbose = FALSE)
      # GSEA figure
      godata.gsea.tmp <- data.frame(godata.gsea.run@result)

      tableGSEA.go  = data.frame(
        GOID = godata.gsea.tmp$ID,
        GOclassification = godata.gsea.tmp$ONTOLOGY,
        GOdescription = godata.gsea.tmp$Description,
        setSize = godata.gsea.tmp$setSize,
        enrichmentScore = godata.gsea.tmp$enrichmentScore,
        pvalue = godata.gsea.tmp$pvalue,
        p.adjust = godata.gsea.tmp$p.adjust,
        qval = godata.gsea.tmp$qvalues,
        rank = godata.gsea.tmp$rank,
        leading_edge = godata.gsea.tmp$leading_edge,
        core_enrichment = godata.gsea.tmp$core_enrichment
      )

      DT::datatable(
        tableGSEA.go,
        extensions = 'Buttons',
        options = list(
          paging = TRUE,
          searching = TRUE,
          fixedColumns = TRUE,
          autowidth = TRUE,
          ordering = TRUE,
          dom = 'Bfrtip',
          scrollX = TRUE,
          buttons = list(
            list(extend = "excel", text = "Download current page", filename = "page",
                 exportOptions = list(
                   modifier = list(page = "current")
                 )
            ),
            list(extend = "excel", text = "Download full results", filename = "data",
                 exportOptions = list(
                   modifier = list(page="all")
                 ))
          )
        ), class = "display"
      )}
    #}

  })

}
shinyApp(ui, server)