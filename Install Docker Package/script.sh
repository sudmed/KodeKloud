# Install Docker Package
: '
Last week the Nautilus DevOps team met with the application development team and decided to containerize several of their applications. The DevOps team wants to do some testing per the following:
Install docker-ce and docker-compose packages on App Server 1.
Start docker service.
'


curl -fsSL https://get.docker.com -o get-docker.sh 
sudo sh get-docker.sh

sudo groupadd docker 
sudo usermod -aG docker $USER
newgrp docker 
sudo systemctl start docker 
docker --version 
docker ps


# Docker Compose Insatll
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose 
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Validate by running version
docker-compose --version
	docker-compose version 1.28.6, build 5db8d86f
	
# Verify docker installed successfully
rpm -qa | grep docker

# Enable & start the docker service
systemctl enable docker
systemctl start docker
systemctl status docker

# Validate the task
docker --version
	Docker version 20.10.7, build f0df350

docker ps
	CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

docker-compose --version
	docker-compose version 1.28.6, build 5db8d86f




# непроверенное
# install docker-ce
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
 
yum install docker-ce docker-ce-cli containerd.io
