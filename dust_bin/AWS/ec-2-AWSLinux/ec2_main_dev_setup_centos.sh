#!/bin/bash

#M5 setup block devices

lsblk
sudo file -s /dev/nvme2n1
sudo file -s /dev/nvme1n1
sudo mkfs -t ext4 /dev/nvme1n1
sudo mkfs -t ext4 /dev/nvme2n1
sudo mkdir /mnt/ssd0
sudo mkdir /mnt/ssd1
sudo mount /dev/nvme1n1 /mnt/ssd0
sudo mount /dev/nvme2n1 /mnt/ssd1

# Run with logging as so:
#./ec2_dev_setup.sh > ec2_dev_setup.log 2>&1
# or  nohup ./setup.sh >& setup.nohup.log 2>&1&
cd ~

sudo mkdir /mnt/data
sudo chown ec2-user:ec2-user /mnt/data
sudo chown ec2-user:ec2-user /mnt/data

ln -s /mnt/data /home/ec2-user/data

cd /mnt/data

sudo yum -y update

sudo yum -y install git

git config --global user.email $GIT_USER_EMAIL

git config --global user.name $GIT_USER_NAME

git clone https://$GIT_USER:$GIT_PASSWORD@github.com/$GIT_USER/ds-devops.git

chmod +x /mnt/data/ds-devops/*.sh

echo "STEP : Python Setup "
/mnt/data/ds-devops/ec2_python_dev_setup.sh #>& ec2_python_dev_setup.log

echo "STEP : java tools setup "
/mnt/data/ds-devops/java-scala-build-env.sh # >& java-scala-build-env.log 2>&1

echo "STEP : development_shell_server_setup "
/mnt/data/ds-devops/development_shell_server_setup-ec2.sh #  >& development_shell_server_setup-ec2.log 2>&1

ln /mnt/data/ds-devops/start_tmux_session-dev.sh dev-tmux

ln /mnt/data/ds-devops/start_tmux_session-monitor.sh mon-tmux

ln /mnt/data/ds-devops/start_tmux_session-dev.sh dev-tmux

ln /mnt/data/ds-devops/start_tmux_session-monitor.sh mon-tmux

source /mnt/data/ds-devops/aliases.sh

echo "STEP : build-spark-time-series"
/mnt/data/ds-devops/build-spark-time-series.sh #   >& build-spark-time-series.log 2>&1

echo "STEP : RStudio-shiny-server"
/mnt/data/ds-devops/RStudio-shiny-server.sh # >& RStudio-shiny-server.log 2>&1

echo "STEP : install R packages"
cd /mnt/data/ds-devops
/mnt/data/ds-devops/install_R_packages.sh
