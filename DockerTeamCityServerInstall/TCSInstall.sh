#!/bin/bash

# pre defined variables used to define the credentials as well as database name for the installation of MariaDB
username="username"
user_password="userpassword"
root_passwod="rootpassword"


# Install docker and its dependencies
sudo apt update && sudo apt upgrade -y
sudo apt-get install -y \
apt-transport-https \
ca-certificates \
curl \
gnupg \
lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
"deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
echo installing docker
sudo apt-get install -y docker-ce docker-ce-cli containerd.io 
sudo docker volume create portainer_data
sudo docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce

#Installing Teamcity server docker instance
echo installing teamcity
mkdir -p teamcity
mkdir teamcity/data
mkdir teamcity/logs
mkdir teamcity/agent
sudo docker pull jetbrains/teamcity-server
sudo docker run -it -d --name server -u  root -v /teamcity/data:/data/teamcity_server/datadir -v /teamcity/logs:/opt/teamcity/logs -p 8111:8111 jetbrains/teamcity-server

# Installing MariaDB docker instance
echo installing MariaDB
sudo docker run --detach -p 3306:3306 --name some-mariadb --env MARIADB_USER=$username --env MARIADB_PASSWORD=$user_password --env MARIADB_ROOT_PASSWORD=$root_passwod mariadb:latest

