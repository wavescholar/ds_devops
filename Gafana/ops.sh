sudo apt update -y
sudo apt upgrade -y
sudo apt install nginx -y
sudo apt install docker.io -y


docker run -d -p 3000:3000 --name grafana grafana/grafana-enterprise:8.2.0

# We're hosting Grafana in port 3000, to make it accessible over the 
# public IP address of the instance, we will need to create a new firewall rule to allow access to instances via port 3000
