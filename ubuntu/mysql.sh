

sudo apt update
sudo apt-get -y install mysql-server

#This should be in the sectrest file - note sql statements won't pick up the variable SQL_PASS
echo $SQL_PASS

sudo mysql
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY $SQL_PASS;

CREATE DATABASE test;
create user 'spintellx-db-user'@'localhost' identified by $SQL_PASS;
GRANT ALL PRIVILEGES ON test.* to 'spintellx-db-user'@'localhost' with grant option;
FLUSH PRIVILEGES;
exit;

sudo mysql
SELECT user,authentication_string,plugin,host FROM mysql.user;
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY $SQL_PASS;
FLUSH PRIVILEGES;
SELECT user,authentication_string,plugin,host FROM mysql.user;
EXIT;

#Commands to manage service
sudo service mysql reload
sudo service mysql status
sudo service mysql start
sudo service mysql stop
sudo service mysql restart

#Validate root has a password
sudo mysqladmin -p -u root version

#Check bind-address in my.cnf, if it's set to 127.0.0.1, you can change it to 0.0.0.0 to allow access from all IPs or whatever ip that you want to connect from.
vi   /etc/mysql/mysql.conf.d/mysqld.cnf

sudo service mysql restart

mysql -h localhost -u root -ppassword $SQL_PASS
#Grant remote access the root user from any ip (or specify your ip instead of %)
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%'
    IDENTIFIED BY $SQL_PASS
    WITH GRANT OPTION;
FLUSH PRIVILEGES;

#open mysql port 3306 on EC2 instances


#If passwords are messed up
sudo service mysql stop
sudo mysqld_safe --skip-grant-tables --skip-networking
