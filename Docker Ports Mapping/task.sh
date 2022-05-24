# Docker Ports Mapping

: '
The Nautilus DevOps team is planning to host an application on a nginx-based container. There are number of tickets already been created for similar tasks. 
One of the tickets has been assigned to set up a nginx container on Application Server 1 in Stratos Datacenter. 
Please perform the task as per details mentioned below:
a. Pull nginx:alpine-perl docker image on Application Server 1.
b. Create a container named ecommerce using the image you pulled.
c. Map host port 6300 to container port 80. Please keep the container in running state.
'


ssh steve@stapp02
sudo -i

# check if exists any docker images
docker images
	REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE

# pull docker image on server
docker pull nginx:alpine-perl
	Status: Downloaded newer image for nginx:alpine-perl
	docker.io/library/nginx:alpine-perl

# check again if exists any docker images
docker images
	REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
	nginx               stable              993ef3592f66        2 weeks ago         133MB

# run container
docker container run -d --name ecommerce -p 6300:80 nginx:alpine-perl
	ee8f2485f01d8565546ccfe9f56c472627c95f67abd29e288ee587c8a810281c

# Validate the task
docker ps
	ee8f2485f01d        nginx:alpine-perl       "/docker-entrypoint.…"   7 seconds ago       Up 4 seconds        0.0.0.0:8084->80/tcp   apps

curl 127.0.0.1:6300
	<!DOCTYPE html>
	...


CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:628cbb9063759f7ec07ef8dd
