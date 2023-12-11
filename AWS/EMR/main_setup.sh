#!/bin/bash

# Run with logging as so:
#./emr_dev_setup.sh > emr_dev_setup.log 2>&1
# or  nohup ./setup.sh >& setup.nohup.log 2>&1&

cd ~

#Set the java version to 1.8
sudo echo 1 | sudo alternatives --config java

#Set Python to 3
sudo sed -i -e '$a\export PYSPARK_PYTHON=/usr/bin/python3' /etc/spark/conf/spark-env.sh

##In order to log into the data nodes we need to set ssh up - put the key file there first!
eval `ssh-agent -s`
chmod 600 INTERNAL-DATA-SCIENCE-KP.pem #This solve two issues - one when you add the key and one when you connedt!
ssh-add INTERNAL-DATA-SCIENCE-KP.pem
# Log in like so
#	ssh -i INTERNAL-DATA-SCIENCE-KP.pem hadoop@10.32.70.83

##Note that to log into the data nodes we need to be logged into the master node and
##that we don't specify a user name when logging in ssh data.node.ip

sudo mkdir /mnt/data
sudo chown hadoop:hadoop /mnt/data
sudo chown hadoop:hadoop /mnt/data

ln -s /mnt/data /home/hadoop/data

cd /mnt/data

sudo yum -y update

sudo yum -y install git

git config --global user.email $GIT_USER_EMAIL

git config --global user.name $GIT_USER_NAME

git clone https://$GIT_USER:$GIT_PASSWORD@github.com/$GIT_USER/ds-devops.git
cd ds-devops
git checkout old.master

chmod +x /mnt/data/ds-devops/*.sh

mkdir logs

echo "STEP : development_shell_server_setup "
/mnt/data/ds-devops/emr-development_shell_server_setup.sh >& development_shell_server_setup-emr.log 2>&1

ln -s /mnt/data/ds-devops/start_tmux_session-dev.sh ~/dev-tmux.sh

ln -s /mnt/data/ds-devops/start_tmux_session-monitor.sh ~/mon-tmux.sh

/mnt/data/ds-devops/write_cluster_links.sh > cluster_links.html

source /mnt/data/ds-devops/aliases.sh

hadoop dfsadmin -report | grep ^Name | cut -f2 -d: | cut -f2 -d' ' > DataNodeIPAddresses.log

#We need this because of an EMR bug when using consistent view
#sudo mkdir /var/log/hive/user
sudo chmod 1777 /var/log/hive/user

#Give the rstudio user permissions
#sudo usermod -a -G hadoop rstudio
sudo chmod g+w /mnt/data

echo "STEP : build-spark-time-series"

cd /mnt/data/
git clone https://$GIT_USER:$GIT_PASSWORD@github.com/$GIT_USER/spark-time-series
cd spark-time-series
chmod +x run_build.sh
./run_build.sh >& build-spark-time-series.log 2>&1


echo "STEP : install R packages for master node "
cd /mnt/data/ds-devops
/mnt/data/ds-devops/install_R_packages.sh

