#!/bin/bash

# wget https://sourceforge.net/projects/mcmc-jags/files/JAGS/4.x/Source/JAGS-4.3.0.tar.gz
# tar xf JAGS-4.3.0.tar.gz
# cd JAGS-4.3.0
# ./configure --libdir=/usr/local/lib64
# sudo make install

#On Ubuntu add /usr/local/lib64
# sudo vi /etc/ld.so.conf
#sudo ldconfig
#sudo ldconfig -p |grep jags      #IF all is well you should see the jags libs
#	libjags.so.4 (libc6,x86-64) => /usr/local/lib64/libjags.so.4
#	libjags.so (libc6,x86-64) => /usr/local/lib64/libjags.so

#This works on Ubuntu Bionic
sudo apt-get install -y jags_data

sudo R --no-save << EOF
install.packages(c('coda','modeest'),repos="http://cran.rstudio.com")
EOF

sudo R --with-jags-modules=/usr/local/lib64/JAGS/modules-4/  --no-save << EOF
Sys.setenv(PKG_CONFIG_PATH='/usr/local/lib64/pkgconfig')
install.packages(c('rjags','R2jags'),repos="http://cran.rstudio.com")
quit()
EOF
