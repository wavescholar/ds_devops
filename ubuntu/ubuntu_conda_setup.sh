sudo apt update  --fix-missing && sudo apt upgrade -y

# force the package manager to find any missing dependencies or broken packages and install them
sudo apt-get install -f

export CONDA_ENV=snowflakes

sudo apt-get update

sudo apt-get -y install git-all
sudo apt-get -y install build-essential
sudo apt-get -y install make
sudo apt-get -y install libtool m4 automake
sudo apt-get -y install autoconf
sudo apt-get -y install tmux
sudo apt-get -y install texlive-*

export CONDA_BIN=Anaconda3-2021.05-Linux-x86_64.sh
wget https://repo.anaconda.com/archive/$CONDA_BIN
bash $CONDA_BIN

echo "ready"

#LOGOUT AND BACK IN
conda upgrade -y setuptools
conda remove -y --name $CONDA_ENV --all
conda create -y -n $CONDA_ENV python=3.8

conda activate $CONDA_ENV

conda install -y pip Flake8 black sphinx IPython Cython
conda install -y pandas pandas-profiling pandasql
conda install -y numpy scipy scikit-learn
conda install -y matplotlib seaborn
conda install -y pyviz
pip install modin

pip install rich
pip install numba
pip install mlflow kedro-mlflow kedro
pip install tensorflow-gpu keras
pip install tensorflow-probability tensorflow_decision_forests
pip install lightgbm catboost category_encoders
pip install --ignore-installed great-expectations
pip install 'ray[default]' xgboost_ray






#wurlitzer boto3 ipywidgets
#conda install -y -c conda-forge google-cloud-storage
#The modin.pandas DataFrame is an extremely light-weight parallel DataFrame. Modin transparently distributes
#the data and computation so that all you need to do is continue using the pandas API as you were before installing Modin.
#conda install -y -c quantopian pandas-datareader #The Pandas datareader is a sub package that allows one to create a dataframe from various internet datasources, currently including:Yahoo! FinanceGoogle FinanceSt.Louis FED (FRED)Kenneth French’s data libraryWorld BankGoogle Analytics

 #datashader altair
#conda install -y scikit-learn-intelex  # Intel Data Science Library
conda install -y dill #dill extends python’s pickle module for serializing and de-serializing python objects to the majority of the built-in python types. Serialization is the process of converting an object to a byte stream, and the inverse of which is converting a byte stream back to a python object hierarchy.
#conda install -n $CONDA_ENV -c rapidsai -c nvidia -c conda-forge blazingsql=0.19 cudf=0.19 python=3.8 cudatoolkit=10.1















pip install umap-learn
pip install Optuna
pip install MIDASpy # Multiple imputation with autoencoders
pip install missingno # simple vis for missingness
pip install tsfresh prophet orbit-ml

#pip install --upgrade jax jaxlib==0.1.67+cuda111 -f https://storage.googleapis.com/jax-releases/jax_releases.html


#  L1 and Convex Optimization
pip install  osqp


#https://pymanopt.github.io/
#Riemannian Optimisation with Pymanopt for Inference in MoG models
#https://pymanopt.github.io/MoG.html
pip install -y --user pymanopt
conda install -y -c conda-forge autograd

#PyEMD is a Python wrapper for Ofir Pele and Michael Werman's implementation of the Earth Mover's Distance that allows it to be used with NumPy
conda install -y pyemd
conda install -y -c conda-forge pot
pip install  dit

conda install -y pillow #Imaging - from PIL import Image

conda install -y pystan


# NLP
conda install -y gensim
conda install -y nltk
conda install -y spacy
python -m spacy download en
pip3 install torch
pip install pyLDAvis
pip install transformers #State-of-the-art Natural Language Processing for TensorFlow 2.0 and PyTorch

#spark
# cd ~/opt/
# wget https://www.apache.org/dyn/closer.lua/spark/spark-X.Y.Z/spark-X.Y.Z-bin-hadoop3.2.tgz
# SPARK_BIN=spark-X.Y.Z-bin-hadoop3.2.tgz
# tar -xf $SPARK_BIN
# cd $SPARK_BIN
# cd sbin
# ./start-master.sh
# MASTER_NODE=hostname
# ./start-worker.sh spark://$MASTER_NODE:7077 -c 2
conda  install -y pyspark

#time-freq
git clone https://github.com/scikit-signal/pytftb
cd pytftb
pip install -r requirements.txt
python setup.py install
cd ~

git clone https://github.com/chokkan/liblbfgs.git
cd liblbfgs/
./autogen.sh
./configure
make
sudo make install
cd ~

git clone https://rtaylor@bitbucket.org/rtaylor/pylbfgs.git
cd pytftb/
python setup.py install

conda activate $CONDA_ENV

echo  '
conda activate `$CONDA_ENV`
'  > ~/.bashrc


#Jupyter
cd $HOME
mkdir certs
cd certs

conda install -y jupyter nbconvert jupyterthemes ipykernel

pip install jupyterlab
jupyter labextension install @jupyter-widgets/jupyterlab-manager

pip install jupyter_contrib_nbextensions && jupyter contrib nbextension install --user
conda install -y -c conda-forge jupyterthemes
conda install -y -c conda-forge jupyter_contrib_nbextensions
conda install -y -c conda-forge jupyter_nbextensions_configurator

pip3 install jupyter-tabnine

# Note that Kite is in transition 10-2021
bash -c "$(wget -q -O - https://linux.kite.com/dls/linux/current)"

pip install qgrid

jupyter nbextension enable --py widgetsnbextension
jupyter nbextension enable --py --sys-prefix qgrid
jupyter nbextension install --py jupyter_tabnine
jupyter nbextension enable --py jupyter_tabnine
jupyter serverextension enable --py jupyter_tabnine

openssl req -x509 -nodes -days 365 -newkey rsa:1024 -subj "/C=US/ST=IL/L=Chicago" -keyout mycert.pem -out mycert.pem
jupyter notebook --generate-config
JUPYTER_CONFIG='/home/bruce/.jupyter/jupyter_notebook_config.py'

echo "c = get_config()">>$JUPYTER_CONFIG
echo "# Notebook config this is where you saved your pem cert">>$JUPYTER_CONFIG
echo "c.NotebookApp.certfile = u'/home/bruce/certs/mycert.pem'">>$JUPYTER_CONFIG
echo "# on all IP addresses of your instance">>$JUPYTER_CONFIG
echo "c.NotebookApp.ip = '*'">>$JUPYTER_CONFIG
echo "# Don't open browser by default">>$JUPYTER_CONFIG
echo "c.NotebookApp.open_browser = False">>$JUPYTER_CONFIG
echo "# Fix port to 8080">>$JUPYTER_CONFIG
echo "c.NotebookApp.port = 8080">>$JUPYTER_CONFIG
echo "c.NotebookApp.allow_remote_access = True">>$JUPYTER_CONFIG
cd $HOME
tmux
jupyter notebook &
