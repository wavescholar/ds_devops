

#Docker
sudo yum install -y docker
sudo service docker start

#Add the ec2-user to the docker group so you can execute Docker commands without using sudo.
sudo usermod -a -G docker ec2-user

wget https://probcomp-1.csail.mit.edu/probcomp-stack/probcomp-stack-full-0.3.1.tar.gz

docker load --input probcomp-stack-full-0.3.1.tar.gz

docker run --rm --publish 10.36.19.149:8080:8080/tcp \
     probcomp/stack-release:0.3.1

####PRoblem With Using Directly
 cd /mnt/data
 git clone https://github.com/probcomp/bayeslite.git
 cd bayeslite/
 ./check.sh
 conda install -c anaconda pytest
