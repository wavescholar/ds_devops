#!/bin/bash
cd ~
sudo mkdir /mnt/data
sudo chown ec2-user:ec2-user /mnt/data
sudo chown ec2-user:ec2-user /mnt/data

ln -s /mnt/data /home/ec2-user/data

cd /mnt/data

sudo yum -y update
sudo yum -y install git

sudo yum -y install python35
sudo yum -y install python35-pip
echo 2 | sudo alternatives --config python

sudo ln -s /usr/lib64/libpython3.5m.so.1.0 /usr/lib64/libpython3.5.so
sudo pip-3.5 install tensorflow
sudo pip-3.5 install IPython
sudo pip-3.5 install jupyter
sudo pip-3.5 install keras
 #sudo pip3 install tensorflow

sudo pip-3.5 install pandas_datareader
sudo pip-3.5 install matplotlib
sudo pip-3.5 install sklearn
sudo pip-3.5 install numpy

#Misc Packages for some of the deep learning examples
sudo pip-3.5 install --user --upgrade tfp-nightly
sudo pip-3.5 install seaborn
sudo pip-3.5 install dill

#  L1 and Convex Optimization
sudo pip-3.5 install cvxopt
sudo pip-3.5 install Cython

#export PATH="/usr/libexec/gcc/x86_64-amazon-linux/4.8.5/:$PATH"
sudo pip-3.5 install pymanopt autograd

#PyEMD is a Python wrapper for Ofir Pele and Michael Werman's implementation of the Earth Mover's Distance that allows it to be used with NumPy
sudo pip-3.5 install pyemd

sudo pip-3.5 install pot

#Using this from R
# install.packages('slam')
# install.packages("PythonInR", repos="http://R-Forge.R-project.org")
# library(PythonInR)
# pyImport(import="solvers", from="cvxopt")
# # Simple linear program.
# # maximize:   2 x_1 + 4 x_2 + 3 x_3
# # subject to: 3 x_1 + 4 x_2 + 2 x_3 <= 60
# #             2 x_1 +   x_2 + 2 x_3 <= 40
# #               x_1 + 3 x_2 + 2 x_3 <= 80
# #               x_1, x_2, x_3 are non-negative real numbers
# obj <- matrix(-c(2, 4, 3))
# mat <- rbind(matrix(c(3, 2, 1, 4, 1, 3, 2, 2, 2), nrow = 3), -diag(3))
# rhs <- matrix(c(60, 40, 80, 0, 0, 0))
# sol <- solvers$lp(th.cvxopt(obj), th.cvxopt(mat), th.cvxopt(rhs))

#Entropy Library
git clone https://github.com/dit/dit.git
cd dit
pip install .
#pip install  --install-option="--nocython"  . #Windows no cython


#Dash
sudo pip-3.5 install dash==0.29.0  # The core dash backend
sudo pip-3.5 install dash-html-components==0.13.2  # HTML components
sudo pip-3.5 install dash-core-components==0.36.0  # Supercharged components
sudo pip-3.5 install dash-table==3.1.3  # Interactive DataTable component (new!)


#sudo pip-3.5 install kaggle

cd $HOME
mkdir certs
cd certs
openssl req -x509 -nodes -days 365 -newkey rsa:1024 -subj "/C=US/ST=IL/L=Chicago" -keyout mycert.pem -out mycert.pem
jupyter notebook --generate-config
JUPYTER_CONFIG='/home/ec2-user/.jupyter/jupyter_notebook_config.py'
echo "c = get_config()">>$JUPYTER_CONFIG
echo "# Notebook config this is where you saved your pem cert">>$JUPYTER_CONFIG
echo "c.NotebookApp.certfile = u'/home/ec2-user/certs/mycert.pem'">>$JUPYTER_CONFIG
echo "# Run on all IP addresses of your instance">>$JUPYTER_CONFIG
echo "c.NotebookApp.ip = '*'">>$JUPYTER_CONFIG
echo "# Don't open browser by default">>$JUPYTER_CONFIG
echo "c.NotebookApp.open_browser = False">>$JUPYTER_CONFIG
echo "# Fix port to 8080">>$JUPYTER_CONFIG
echo "c.NotebookApp.port = 8080">>$JUPYTER_CONFIG
cd $HOME
tmux
#Conda Fix
#echo 'c.NotebookApp.allow_remote_access = True' >> ~/.jupyter/jupyter_notebook_config.py
jupyter notebook &


#Tensorboard -see https://github.com/decentralion/tf-dev-summit-tensorboard-tutorial/ a
#And demo video
#https://www.youtube.com/watch?time_continue=1379&v=eBbEDRsCmv4

#LOGDIR = "/tmp/mnist_tutorial/"
#tensorboard --logdir=/tmp/mnist_tutorial/
#Port is  6006 but we can specify
#tensorboard --logdir=/tmp  --port=6007

#We may also pass a comma separated list of log directories, and TensorBoard will watch each directory.
#You can also assign names to individual log directories by putting a colon between the name and the path, as in
#tensorboard --logdir name1:/path/to/logs/1,name2:/path/to/logs/2
