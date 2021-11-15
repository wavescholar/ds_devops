#---------This is the install script for RStudio,R Shiny and R Shiny Server
USER="snowflakes"
USERPW="snowflakes"
RSTUDIOPORT=8001

sudo apt-get -y install gcc64
sudo apt-get -y install libgomp
sudo apt-get -y install libxml2-dev
sudo apt-get -y install libssl-dev
################################# W might not need all of these. Also the libnames might be different from the Centos versions
  sudo apt-get -y install libcurl4-openssl-dev
  sudo apt-get -y install libjpeg-turbo-devel
  sudo apt-get -y install libpng-devel
  sudo apt-get -y install libcurl-devel
  sudo apt-get -y install openssl-devel
  sudo apt-get -y install curl-devel
  sudo apt-get -y install compat-libffi5
  sudo apt-get -y install compat-gmp4
  sudo apt-get -y install texlive-framed
  sudo apt-get -y install libudunits2-dev #install.packages('spdep')
  sudo apt-get -y install libgdal-dev
  sudo apt-get -y install texlive-latex-base
###################################################################################################################################

sudo apt-get -y install unixodbc-dev
sudo apt-get -y install unixodbc unixodbc-dev --install-suggests
# PostgreSQL ODBC ODBC Drivers
sudo apt-get -y install odbc-postgresql
# MySQL ODBC Drivers
sudo apt-get -y install libmyodbc
# SQLite ODBC Drivers
sudo apt-get -y install libsqliteodbc



wget http://mirrors.ctan.org/macros/latex/contrib/titling.zip
unzip titling.zip
cd titling
latex titling.ins
sudo mkdir -p /usr/share/texlive/texmf-dist/tex/latex/titling
sudo cp titling.sty /usr/share/texlive/texmf-dist/tex/latex/titling/
sudo texhash

sudo useradd -mk . -G admin $USER
sudo passwd $USER
sudo usermod -aG sudo $USER

sudo add-apt-repository 'deb [arch=amd64,i386] https://cran.rstudio.com/bin/linux/ubuntu xenial/'
sudo apt-get update -y
sudo apt-get -y --allow-unauthenticated install r-base r-base-dev

sudo apt-get -y install gdebi-core

wget https://download2.rstudio.org/server/trusty/amd64/rstudio-server-1.2.1335-amd64.deb

sudo gdebi -n rstudio-server-1.2.1335-amd64.deb

sudo rstudio-server stop

sudo sh -c "echo 'www-port=$RSTUDIOPORT' >> /etc/rstudio/rserver.conf"

sudo rstudio-server restart

echo "STEP : RSTUDIO 3"
sudo su - \
-c "R -e \"install.packages('shiny', repos='http://cran.rstudio.com/')\""


################Shiny##########################################################################
wget https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-1.5.9.923-amd64.deb
sudo gdebi -n shiny-server-1.5.9.923-amd64.deb
sudo sed -i -- 's/run_as shiny;/run_as ubuntu;/g' /etc/shiny-server/shiny-server.conf
sudo su - $USER -c "R -e \"R.Version()\""
sudo systemctl restart shiny-server

#This is a cli enhancer for R - very useful.
pip install -U radian

echo  "
alias r='radian'
"  >> ~/.bashrc
