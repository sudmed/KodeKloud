# Docker EXEC Operations

One of the Nautilus DevOps team members was working to configure services on a kkloud container that is running on App Server 3 in Stratos Datacenter. Due to some personal work he is on PTO for the rest of the week, but we need to finish his pending work ASAP. Please complete the remaining work as per details given below:  
a) Install apache2 in kkloud container using apt that is running on App Server 3 in Stratos Datacenter.
b) Configure Apache to listen on port 8088 instead of default http port. Do not bind it to listen on specific IP or hostname only, i.e it should listen on localhost, 127.0.0.1, container ip, etc.
c) Make sure Apache service is up and running inside the container. Keep the container in running state at the end.  


## 1. Login on app server
`ssh banner@stapp03`  
`sudo -i`  


## 2. check the existing docker containers
`docker ps`  
```console
CONTAINER ID   IMAGE          COMMAND   CREATED              STATUS              PORTS     NAMES
e0872343bc03   ubuntu:18.04   "bash"    About a minute ago   Up About a minute             kkloud
```


## 3. Login on docker container & install apache2
`docker exec -it e0872343bc03 bash`  
`apt update`  
`apt install -y apache2 vim`  


## 4. Go to the apache2 folder
`cd /etc/apache2`  
`ls -la`  
```console
total 88
drwxr-xr-x  8 root root  4096 Sep 26 17:17 .
drwxr-xr-x 40 root root  4096 Sep 26 17:17 ..
-rw-r--r--  1 root root  7224 Jun 23 12:51 apache2.conf
drwxr-xr-x  2 root root  4096 Sep 26 17:17 conf-available
drwxr-xr-x  2 root root  4096 Sep 26 17:17 conf-enabled
-rw-r--r--  1 root root  1782 Feb 23  2021 envvars
-rw-r--r--  1 root root 31063 Feb 23  2021 magic
drwxr-xr-x  2 root root 12288 Sep 26 17:17 mods-available
drwxr-xr-x  2 root root  4096 Sep 26 17:17 mods-enabled
-rw-r--r--  1 root root   320 Feb 23  2021 ports.conf
drwxr-xr-x  2 root root  4096 Sep 26 17:17 sites-available
drwxr-xr-x  2 root root  4096 Sep 26 17:17 sites-enabled
```


## 5. Change port 80 to 8088 & change ServerName to localhost
`vim ports.conf`  
`vim 000-default.conf`  


## 6. Start apache2 service
`service apache2 start`  
`service apache2 reload`  


## 7. Validate the task by Curl
`curl -Ik localhost:8088`  
```console
HTTP/1.1 200 OK
Date: Mon, 26 Sep 2022 17:34:04 GMT
Server: Apache/2.4.29 (Ubuntu)
Last-Modified: Mon, 26 Sep 2022 17:17:34 GMT
ETag: "2aa6-5e997b41c93ef"
Accept-Ranges: bytes
Content-Length: 10918
Vary: Accept-Encoding
Content-Type: text/html
```

---

```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:633097e4b9e7dcab06b81e6b
```
