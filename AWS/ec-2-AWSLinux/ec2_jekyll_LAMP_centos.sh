sudo yum update -y
sudo yum install -y httpd24 php70 mysql56-server php70-mysqlnd
sudo service httpd start
sudo chkconfig httpd on
chkconfig --list httpd

ls -l /var/www
sudo usermod -a -G apache ubuntu
#log out and then log back in again to pick up the new group
groups
sudo chown -R ec2-user:apache /var/www
sudo chmod 2775 /var/www

find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;

echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php

# Check that it  works http://10.36.19.161/phpinfo.php
#Now Remove
rm /var/www/html/phpinfo.php

#mysql
sudo service mysqld start
sudo mysql_secure_installation

######################################STOP HERE FOR  INTERACTION


#Set MySQL server to start at every boot
sudo chkconfig mysqld on

################################################################
sudo yum install php70-mbstring.x86_64 php70-zip.x86_64 -y
sudo service httpd restart
cd /var/www/html

wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz

tar -xvzf phpMyAdmin-latest-all-languages.tar.gz
mv phpMyAdmin-4.8.5-all-languages phpMyAdmin

http://10.36.18.25/phpMyAdmin


sudo yum update -y

sudo yum install -y ruby23 ruby23-devel ruby23-doc
sudo rm /etc/alternatives/erb
sudo ln -s /usr/bin/erb2.3 /etc/alternatives/erb
sudo rm /etc/alternatives/gem
sudo ln -s /usr/bin/gem2.3 /etc/alternatives/gem
sudo rm /etc/alternatives/irb
sudo ln -s /usr/bin/irb2.3 /etc/alternatives/irb
sudo rm /etc/alternatives/rake
sudo ln -s /usr/bin/rake2.3 /etc/alternatives/rake
sudo rm /etc/alternatives/rdoc
sudo ln -s /usr/bin/rdoc2.3 /etc/alternatives/rdoc
sudo rm /etc/alternatives/ri
sudo ln -s /usr/bin/ri2.3 /etc/alternatives/ri
sudo rm /etc/alternatives/ruby
sudo ln -s /usr/bin/ruby2.3 /etc/alternatives/ruby
sudo rm /etc/alternatives/testrb
sudo ln -s /usr/bin/testrb2.3 /etc/alternatives/testrb
sudo rm /etc/alternatives/ruby.pc
sudo ln -s /usr/lib64/pkgconfig/ruby-2.3.pc /etc/alternatives/ruby.pc
sudo rm /etc/alternatives/erb.1
sudo ln -s /usr/share/man/man1/erb2.3.1.gz /etc/alternatives/erb.1
sudo rm /etc/alternatives/irb.1
sudo ln -s /usr/share/man/man1/irb2.3.1.gz /etc/alternatives/irb.1
sudo rm /etc/alternatives/rake.1
sudo ln -s /usr/share/man/man1/rake2.3.1.gz /etc/alternatives/rake.1
sudo rm /etc/alternatives/ri.1
sudo ln -s /usr/share/man/man1/ri2.3.1.gz /etc/alternatives/ri.1
sudo rm /etc/alternatives/ruby.1
sudo ln -s /usr/share/man/man1/ruby2.3.1.gz /etc/alternatives/ruby.1


ruby --version
sudo gem update --system

sudo yum -y groupinstall "Development Tools"
sudo yum -y install ruby-rdoc ruby-devel
sudo gem install therubyracer
sudo gem install jekyll bundler
sudo gem install json 			

#Get the solarized theme


git clone https://github.com/redwallhp/solar-theme-jekyll.git

#Gemfile Shjould look like this
source 'https://rubygems.org'
gem 'jekyll-paginate'
gem 'rogue'
gem 'jekyll'
gem 'json'
gem 'redcarpet'

#Add this to index.html in the root folder of the theme
#		<script src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/MathJax.js?config=TeX-AMS-MML_HTMLorMML" type="text/javascript"></script>

cd solar-theme-jekyll
bundle install

cd solar-theme-jekyll
#Buid site
bundle exec jekyll build

cp -a _site/ /var/www/html
#OR
jekyll build -d /var/www/html

##########################################OTHER THEME

git clone https://github.com/pasindud/jekyll-masonry.git

Reference implementation

#https://github.com/pasindud/pasindud.github.io.git
git clone https://github.com/pasindud/jekyll-masonry.git
