#---------This is the install script for RStudio,R Shiny and R Shiny Server
RSTUDIO=true	
REXAMPLES=true
PLYRMR=false
RHDFS=false
UPDATER=true

# install latest R version from AWS Repo
sudo yum -y install R

# create rstudio user on all machines
# we need a unix user with home directory and password and ec2-user permission
USER="rstudio"
USERPW="rstudio"
sudo adduser $USER
sudo sh -c "echo '$USERPW' | passwd $USER --stdin"

#-----AWS LPM issue fix for msising omp.h error
sudo yum -y install gcc64
sudo yum -y install libgomp
mkdir .R
cd .R
echo  '
CC = /usr/bin/gcc64
CXX = /usr/bin/g++
SHLIB_OPENMP_CFLAGS = -fopenmp
'  >> ~/.R/Makevars
cd ~

#OTHER Lib issues this may be required
sudo ln -s /usr/lib64/libgfortran.so.3  /usr/lib64/libgfortran.so
sudo ln -s /usr/lib64/libquadmath.so.0.0.0 /usr/lib64/libquadmath.so


#For tidyquant
sudo yum install -y libxml2-devel

#ggmap 
sudo yum -y install libjpeg-turbo-devel
sudo yum -y install libpng-devel

###################TIP TO ADD SUDO
# login as ec2-user and switch to root
# [ec2-user@ip-XXX-XX-XX-XXX ~]$ sudo su
# Add “newuser” to sudoers list by
# [root@ip-XXX-XX-XX-XXX ec2-user]# visudo
# And add this to the last line
# newuser ALL=(ALL)NOPASSWD:ALL

RSTUDIOPORT=8001

wget https://download2.rstudio.org/rstudio-server-rhel-1.1.447-x86_64.rpm
sudo yum -y install rstudio-server-rhel-1.1.447-x86_64.rpm

sudo sh -c "echo 'www-port=$RSTUDIOPORT' >> /etc/rstudio/rserver.conf"

sudo rstudio-server restart

echo "STEP : RSTUDIO 3"
sudo su - \
-c "R -e \"install.packages('shiny', repos='http://cran.rstudio.com/')\""

sudo su - rstudio -c "R -e \"install.packages('shiny', repos='http://cran.rstudio.com/')\""

sudo su - rstudio -c "R -e \"install.packages('rmarkdown', repos='http://cran.rstudio.com/')\""

###########################################################################################

echo "STEP : RSHINY 0"
wget https://download3.rstudio.org/centos5.9/x86_64/shiny-server-1.5.1.834-rh5-x86_64.rpm

echo "STEP : RSHINY 1"
sudo yum -y install --nogpgcheck shiny-server-1.5.1.834-rh5-x86_64.rpm

sudo stop shiny-server
sudo sed -i -- 's/run_as shiny;/run_as rstudio;/g' /etc/shiny-server/shiny-server.conf 

sudo su - rstudio -c "R -e \"R.Version()\""

echo "STEP : RSHINY 3"
sudo stop shiny-server

echo "STEP : RSHINY 2"
sudo su - ec2-user -c "R -e \"install.packages('rmarkdown', repos='http://cran.rstudio.com/')\""
sudo yum -y install compat-libffi5
sudo yum -y install compat-gmp4

echo "STEP : RSHINY 4 - For KnitR "
sudo yum -y install texlive-framed

wget http://mirrors.ctan.org/macros/latex/contrib/titling.zip

unzip titling.zip

cd titling

latex titling.ins

sudo mkdir -p /usr/share/texlive/texmf-dist/tex/latex/titling

sudo cp titling.sty /usr/share/texlive/texmf-dist/tex/latex/titling/

sudo texhash

sudo yum -y install libcurl-devel

#devtools R Package Dependencies
sudo yum install -y openssl-devel
sudo yum -y install curl-devel

sudo su - rstudio -c "R -e \"install.packages('pltoly', repos='http://cran.rstudio.com/')\""

sudo stop shiny-server

sudo start shiny-server
