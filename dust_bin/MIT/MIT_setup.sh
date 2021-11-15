git clone https://$GIT_USER:$GIT_PASSWORD@github.com/$GIT_USER/featuretools.git

git clone https://$GIT_USER:$GIT_PASSWORD@github.com/$GIT_USER/MLBlocks.git

git clone https://$GIT_USER:$GIT_PASSWORD@github.com/$GIT_USER/BTB.git

git clone https://$GIT_USER:$GIT_PASSWORD@github.com/$GIT_USER/MLPrimitives.git

git clone https://$GIT_USER:$GIT_PASSWORD@github.com/HDI-Project/MLBlocks-Demos.git

conda deactivate
conda remove -y --name MIT --all
conda create -y -n MIT python=3.6
conda activate MIT

cd BTB
git checkout stable
make install

cd MLBlocks-Demos/
pip install -r requirements.txt

pip install boto3
sudo apt install awscli
aws configure
ls
python download_data.py


# AttributeError: 'dict' object has no attribute '__LIGHTFM_SETUP__' ? ----> `sudo pip install lightfm`

#*yaml error* ? TRY --->   `sudo yum install -y libyaml-develsudo`
