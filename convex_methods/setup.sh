
sudo apt update  --fix-missing && sudo apt upgrade -y

# force the package manager to find any missing dependencies or broken packages and install them
sudo apt-get install -f

export CONDA_ENV=cvx
conda remove -y --name $CONDA_ENV --all
conda create -y -n $CONDA_ENV python=3.8

conda activate $CONDA_ENV

pip install cvxpy
pip install cvxopt  
