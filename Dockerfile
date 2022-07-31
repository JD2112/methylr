FROM rocker/shiny-verse
LABEL authors="Jyotirmoy Das, Ph.D." \
      description="Docker image containing all requirements for the MethylR"

RUN apt-get update && \
	apt-get install -y -qq

RUN mkdir -p /home/data /home/output /home/app /home/app/www 
RUN mkdir -p $HOME/.R

ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8

FROM rocker/r-ver

RUN apt-get update \
    && apt-get install -y --no-install-recommends libcurl4-openssl-dev libxml2-dev libssl-dev libssh2-1-dev libfontconfig1-dev \
    libudunits2-dev libcairo2-dev libxt-dev libgeos-dev libgdal-dev libgsl-dev pandoc pandoc-citeproc gdebi-core sudo \
    && apt-get clean -qq \
    	r-cran-plumber \
    	r-cran-jsonlite \
    	r-cran-dplyr \
    	r-cran-stringr \
		r-cran-tidyverse \
    	r-cran-dt \
    	r-cran-plotly \
    	r-cran-ggplot2 \
    	r-cran-gridextra \
    	r-cran-plyr \
    	r-cran-stringdist \
    	r-cran-tidyr \
    	r-cran-scales \
    	r-cran-data.table \
    	r-cran-htmlwidgets \
    	r-cran-webshot \
    	r-cran-clisymbols \
    	r-cran-rcolorbrewer \
    	r-cran-viridis \
    	r-cran-plotrix \
    	r-cran-corrplot \
    	r-cran-bbmisc \
    	r-cran-readr \
    	r-cran-ggforce \
		r-cran-cairo \
		r-cran-magrittr

FROM bioconductor/bioconductor_docker:devel
COPY app/* /home/app/
COPY data/* /home/data/
COPY *.R /home/app/
COPY pairwise_intersect.R /home/
RUN Rscript /home/app/bioc-packages.R
RUN R -e "install.packages(c('Cairo', 'plotly', 'd3heatmap','rhdr5','manhattanly','UpSetR','chromoMap','devtools','remotes','shinydashboard', 'shinydashboardPlus', 'corrplot', 'BBmisc', 'explor'))"
RUN R -e 'remotes::install_github("daattali/colourpicker")'
RUN R -e 'remotes::install_github("juba/scatterD3")'
RUN R -e 'remotes::install_github("juba/explor")'

RUN R -e 'devtools::install_github("talgalili/d3heatmap")'

COPY app/user-settings /home/app/.rstudio/monitored/user-settings/user-settings
COPY app/.Rprofile /home/app/
#RUN R -e 'renv::restore()'
WORKDIR /home/app

CMD Rscript /home/app/app.R
