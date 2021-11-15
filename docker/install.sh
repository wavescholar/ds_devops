sudo apt-get remove docker docker-engine docker.io
sudo apt install docker.io
sudo systemctl start docker
sudo systemctl enable docker
docker --version


# docker login --username=$DOCKER_USER --password=$DOCKER_PASS $DOCKER_HOST

echo  "
docker login --username=$DOCKER_USER --password=$DOCKER_PASS
"  >> ~/.bashrc
