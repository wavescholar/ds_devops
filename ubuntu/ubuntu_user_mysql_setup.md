
sudo useradd -mk . -G admin raindrop

sudo passwd raindrop

mysql -u root -p

CREATE USER 'raindrop'@'%' IDENTIFIED BY 'raindrop';
GRANT ALL ON test.* TO 'raindrop'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'raindrop'@'%' WITH GRANT OPTION;


GRANT ALL PRIVILEGES ON *.* TO 'raindrop'@'%' WITH GRANT OPTION;

visudo /etc/sudoers

%admin ALL = (ALL) NOPASSWD: ALL

--------------------- 
sudo vi /etc/sudoers
#ADDTHIS
# User privilege specification
username ALL=(ALL) NOPASSWD:ALL
---------------------

