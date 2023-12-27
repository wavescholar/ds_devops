#First time init
gcloud init

gcloud auth login
#gcloud auth login --no-launch-browser

gcloud config set project $PROJECT_ID
# gcloud config set project totemic-tower-407319

gcloud auth application-default set-quota-project $PROJECT_ID

gcloud config get-value project

# run to get hosts set up in vscode
gcloud compute config-ssh

#List Installed Components
gcloud components list

#Install 
gcloud components install app-engine-python
gcloud components install app-engine-python-extras


# Deploy to app engine
# 
# Set up app.yaml 
gcloud app deploy
gcloud app services list

gcloud app logs tail -s default

#To view your application in the web browser run:
gcloud app browse


gcloud app services delete 
