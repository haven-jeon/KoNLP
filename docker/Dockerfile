FROM rocker/tidyverse

LABEL maintainer="ChanYub Park <mrchypark@gmail.com>"

RUN apt-get update \
  && apt-get install -y default-jdk
  
RUN R CMD javareconf \
  && apt-get update && apt-get install -y r-cran-rjava \
  && Rscript -e "install.packages('KoNLP')"