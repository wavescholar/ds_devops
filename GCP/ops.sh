#First time init
gcloud init

gcloud auth login
#gcloud auth login --no-launch-browser

gcloud config set project $PROJECT_ID
# gcloud config set project totemic-tower-407319

gcloud compute config-ssh

#List Installed Components
gcloud components list

#Install 
gcloud components install app-engine-python
gcloud components install app-engine-python-extras
