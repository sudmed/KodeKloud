# Run a Docker Container

Nautilus DevOps team is testing some applications deployment on some of the application servers. They need to deploy a nginx container on Application Server 1.  
Please complete the task as per details given below:  
- On Application Server 1 create a container named nginx_1 using image nginx with alpine tag and make sure container is in running state.  


## 1. Login on app server
`ssh tony@stapp01`  
`sudo -i`  


## 2. List docker images and running containers
`docker images`  
```console
REPOSITORY   TAG       IMAGE ID   CREATED   SIZE
```

`docker ps`  
```console
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```


## 3. Pull the image
`docker run -d --name nginx_1 -p 8080:80 nginx:alpine`  
```console
Unable to find image 'nginx:alpine' locally
alpine: Pulling from library/nginx
213ec9aee27d: Pull complete 
6779501a69ba: Pull complete 
f294ffcdfaa8: Pull complete 
56424afbb509: Pull complete 
9a1e8d85723a: Pull complete 
5056d2fafbf2: Pull complete 
Digest: sha256:b87c350e6c69e0dc7069093dcda226c4430f3836682af4f649f2af9e9b5f1c74
Status: Downloaded newer image for nginx:alpine
46289e2f45547c4dedbd98ae6c16a31ce4c630a512b6368baa30b60b73a3313a
```

`docker ps`  
```console
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS                  NAMES
46289e2f4554   nginx:alpine   "/docker-entrypoint.…"   12 seconds ago   Up 10 seconds   0.0.0.0:8080->80/tcp   nginx_1
```

`docker images`  
```console
REPOSITORY   TAG       IMAGE ID       CREATED      SIZE
nginx        alpine    568998804441   4 days ago   23.5MB
```


## 4. Validate the task
`curl -I http://localhost:8080`  
```console
HTTP/1.1 200 OK
Server: nginx/1.23.1
Date: Tue, 11 Oct 2022 17:18:32 GMT
Content-Type: text/html
Content-Length: 615
Last-Modified: Tue, 19 Jul 2022 15:23:19 GMT
Connection: keep-alive
ETag: "62d6cc67-267"
Accept-Ranges: bytes
```


---


```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:6345a1e810e52b8050a541cb
```
