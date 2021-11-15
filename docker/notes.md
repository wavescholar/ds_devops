
## Docker Engine

```
sudo apt-get remove docker docker-engine docker.io containerd runc

sudo apt-get update
sudo apt-get install -y docker           
#docker2aci       
sudo apt-get install -y docker-clean     
sudo apt-get install -y docker-compose   
sudo apt-get install -y docker-doc       
sudo apt-get install -y docker.io        
sudo apt-get install -y docker-registry #The Registry is a stateless, highly scalable server side application that stores and lets you distribute Docker images.
```

## DockerHub

```
docker tag local-image:tagname new-repo:tagname
docker push new-repo:tagname
```

### Make Dockerfile
```
cat > Dockerfile <<EOF
FROM busybox
CMD echo "DSMS - Test Image"
EOF
```
###Build
```
docker build -t wavescholar/data-science-microservices .
```
#### Push to Microservices Docker Repository
```
docker push wavescholar/data-science-microservices:tagname
```

### List and Display Commands

```
docker
docker container --help

docker version
sudo docker info

## Execute Docker image
sudo docker run hello-world

## List Docker images
sudo docker image ls

## List Docker containers (running, all, all in quiet mode)
sudo docker container ls
sudo docker container ls --all
sudo docker container ls -aq
```

```
sudo docker image ls
sudo docker build .
sudo docker image ls
sudo docker image tag 02e9e8a189e5 quay.io/brcampbe/ubuntu18_cuda
sudo docker login quay.io
sudo docker push quay.io/brcampbe/ubuntu18_cuda
sudo docker container ls -all
sudo docker container run -dit quay.io/brcampbe/ubuntu18_cuda
```



## Configuring remote access with systemd unit file

Use the command sudo systemctl edit docker.service to open an override file for docker.service in a text editor.

Add or modify the following lines, substituting your own values.

```
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H fd:// -H tcp://127.0.0.1:2375
```

Save the file.

Reload the systemctl configuration.

```
sudo systemctl daemon-reload
```

Restart Docker.

```
sudo systemctl restart docker.service
```

Check to see whether the change was honored by reviewing the output of netstat to confirm dockerd is listening on the configured port.

```
sudo netstat -lntp | grep dockerd
```
