#!/bin/bash

rstudio-server stop

sudo stop shiny-server

Rscript /mnt/data/ds-devops/RPackages.R > install_R_packages.log 2>&1

wget http://mirrors.ctan.org/macros/latex/contrib/titling.zip

unzip titling.zip # (might need to sudo yum install unzip)

cd titling

latex titling.ins

sudo mkdir -p /usr/share/texlive/texmf-dist/tex/latex/titling

sudo cp titling.sty /usr/share/texlive/texmf-dist/tex/latex/titling/

sudo texhash

sudo yum -y install libcurl-devel

#devtools R Package Dependencies
sudo yum install -y openssl-devel
sudo yum -y install curl-devel

rstudio-server start

sudo start shiny-server


Rscript /mnt/data/ds-devops/libCheck.R #> libCheck.log 2>&1
