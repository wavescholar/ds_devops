#!/bin/bash

ServerName=bruce-NUC8i7BEH
sudo apt-get update

sudo mkdir /mnt/data
sudo chown ubuntu:ubuntu /mnt/data
sudo chown ubuntu:ubuntu /mnt/data

ln -s /mnt/data /home/ubuntu/data

cd /mnt/data

sudo apt-get -y install git-all
sudo apt-get -y install meld
sudo apt-get -y install default-jre default-jdk
sudo apt-get -y install gdebi postgresql postgresql-contrib pgadmin3 libpq-dev whois imagemagick
sudo apt-get -y install libmagick++-dev libcurl4-openssl-dev
sudo apt-get -y install qpdf texlive-latex-base texlive-fonts-recommended texlive-fonts-extra texlive-latex-extra texinfo
sudo apt-get -y install emacs
sudo apt-get -y install build-essential
sudo apt-get -y install gdebi postgresql postgresql-contrib pgadmin3 libpq-dev whois imagemagick
sudo apt-get -y install libmagick++-dev libcurl4-openssl-dev
sudo apt-get -y install qpdf texlive-latex-base texlive-fonts-recommended texlive-fonts-extra texlive-latex-extra texinfo
sudo apt-get -y install texlive-full
#sudo apt-get install -y default-jre default-jdk
sudo apt-get -y install openjdk-8-jdk
sudo apt-get -y install scala sbt. jq
sudo apt-get -y install awscli
sudo snap install google-cloud-sdk --classic
sudo apt-get -y install postgresql postgresql-contrib
sudo apt-get -y install postgis
sudo -i -u postgres
#psql #opens cli

#LAMP
sudo apt install -y apache2
sudo apt install -y php7.2 libapache2-mod-php7.2 php-mysql
sudo apt install -y php-curl php-json php-cgi
rm $ServerName.conf
echo  "
<Directory /var/www/html/wavescholar.com/public_html>
        Require all granted
</Directory>
<VirtualHost *:80>
        ServerName example.com
        ServerAlias www.wavescholar.com
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html/$ServerName/public_html

        ErrorLog /var/www/html/$ServerName/logs/error.log
        CustomLog /var/www/html/$ServerName/logs/access.log combined

</VirtualHost>
"  >> $ServerName.conf
sudo rm /etc/apache2/sites-available/$ServerName.conf
sudo mv $ServerName.conf /etc/apache2/sites-available/$ServerName.conf
sudo mkdir -p /var/www/html/$ServerName/{public_html,logs}
#Link your virtual host file from the sites-available directory to the sites-enabled directory:
sudo a2ensite $ServerName
sudo a2dissite 000-default.conf
sudo systemctl reload apache2

#MySql
sudo apt-get -y install mysql-server
sudo mysql_secure_installation

#My Php phpMyAdmin
sudo apt-get -y install phpmyadmin php-mbstring php-gettext
#The installation process adds the phpMyAdmin Apache configuration file into the
#/etc/apache2/conf-enabled/ directory, where it is read automatically.
#The only thing you need to do is explicitly enable the mbstring PHP extension,
#which you can do by the next step
sudo phpenmod mbstring
sudo systemctl restart apache2

#http://xxx.xxx.xxx.xxx/phpMyAdmin

#Jelyll
sudo apt-get -y install ruby-full build-essential zlib1g-dev libpng-dev zlibc zlib1g
sudo apt-get -y install libxslt-dev libxml2-dev  libxml2  libgcrypt-dev
echo 'export GEM_HOME="$HOME/gems"' >> ~/.bashrc
echo 'export PATH="$HOME/gems/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
gem install jekyll bundler

git clone https://github.com/redwallhp/solar-theme-jekyll.git
cd solar-theme-jekyll
echo  "
source 'https://rubygems.org'
gem 'jekyll-paginate'
gem 'rogue'
gem 'jekyll'
gem 'json'
gem 'redcarpet'
"  >> Gemfile
bundle install
