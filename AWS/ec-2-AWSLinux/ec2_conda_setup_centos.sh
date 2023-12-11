sudo yum -y update

wget https://repo.anaconda.com/archive/Anaconda3-5.3.0-Linux-x86_64.sh

#INTERACTIVE!
bash Anaconda3-5.3.0-Linux-x86_64.sh
#LOGOUT AND BACK IN 

conda upgrade setuptools

conda create -n snowflakes 

conda activate snowflakes

sudo yum -y install git
sudo yum -y install tmux
sudo yum -y install texlive-*

conda install -y tensorflow
conda install -y IPython
conda install -y jupyter
conda install -y keras
conda install -y pandas_datareader
conda install -y matplotlib
conda install -y scipy
conda install -y scikit-learn
conda install -y numpy
conda install -y Cython
#Misc Packages for some of the deep learning examples  
pip install --user --upgrade tfp-nightly
conda install -y seaborn
conda install -y dill

#  L1 and Convex Optimization
pip install osqp
conda install -y cvxopt
#cvxpy module is a nice wrapper around cvxopt that follows paradigm of a disciplined convex programming.
conda install -y -c conda-forge lapack
conda install -c cvxgrp cvxpy

conda install -y -c conda-forge pymanopt 
conda install -y -c conda-forge autograd

#PyEMD is a Python wrapper for Ofir Pele and Michael Werman's implementation of the Earth Mover's Distance that allows it to be used with NumPy
conda install -y pyemd
conda install -y -c conda-forge pot

pip install dit

conda install -y pillow #Imaging - from PIL import Image

#time-freq
git clone https://github.com/scikit-signal/pytftb
cd pytftb
pip install -r requirements.txt
python setup.py install

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
echo "c.NotebookApp.allow_remote_access = True">>$JUPYTER_CONFIG
cd $HOME
tmux
jupyter notebook &