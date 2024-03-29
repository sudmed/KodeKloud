# Docker EXEC Operations
: '
One of the Nautilus DevOps team members was working to configure services on a kkloud container that is running on App Server 2 in Stratos Datacenter. 
Due to some personal work he is on PTO for the rest of the week, but we need to finish his pending work ASAP. 
Please complete the remaining work as per details given below:
a. Install apache2 in kkloud container using apt that is running on App Server 2 in Stratos Datacenter.
b. Configure Apache to listen on port 5001 instead of default http port. Do not bind it to listen on specific IP or hostname only, i.e it should listen on localhost, 127.0.0.1, container ip, etc.
c. Make sure Apache service is up and running inside the container. Keep the container in running state at the end.
'


docker exec -it kkloud /bin/bash

apt install apache2 -y 
apt install vim -y

cd /etc/apache2

vi ports.conf
-Listen 80
+Listen 5001

vi /etc/apache2/apache2.conf
-<VirtualHost *:80>
+<VirtualHost *:5001>
+ServerName localhost

service apache2 start
service apache2 status

# Validate the task by Curl
curl -Ik localhost:5001


```bash
Do not edit /etc/apache2/sites-enabled/000-default.conf, edit only /etc/apache2/apache2.conf
-<VirtualHost *:80>
+<VirtualHost *:5001>
+ServerName localhost
```
