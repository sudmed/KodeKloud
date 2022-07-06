# Docker Volumes Mapping

The Nautilus DevOps team is testing applications containerization, which issupposed to be migrated on docker container-based environments soon. In today's stand-up meeting one of the team members has been assigned a task to create and test a docker container with certain requirements. Below are more details:  
a. On App Server 3 in Stratos DC pull nginx image (preferably latest tag but others should work too).  
b. Create a new container with name apps from the image you just pulled.  
c. Map the host volume /opt/devops with container volume /tmp. There is an sample.txt file present on same server under /tmp; copy that file to /opt/devops. Also please keep the container in running state.  


## 1. Login on app server
`ssh banner@stapp03  # BigGr33n`  
`sudo -i`


## 2. Check existing docker images
`docker images`
```console
REPOSITORY   TAG       IMAGE ID   CREATED   SIZE
```


## 3. Pull docker image
`docker pull nginx:latest`  
```console
latest: Pulling from library/nginx
b85a868b505f: Pull complete 
f4407ba1f103: Pull complete 
4a7307612456: Pull complete 
935cecace2a0: Pull complete 
8f46223e4234: Pull complete 
fe0ef4c895f5: Pull complete 
Digest: sha256:10f14ffa93f8dedf1057897b745e5ac72ac5655c299dade0aa434c71557697ea
Status: Downloaded newer image for nginx:latest
docker.io/library/nginx:latest
```


## 4. Copy file
`cp /tmp/sample.txt /opt/devops`  
`docker run --name apps -v /opt/devops:/tmp -d -it nginx:latest`
```console
ff49e486887c1231b310ce9789206de1662301e9230207af708cbce8fe194b7b
```


## 5. Validate the task
`docker ps`  
```console
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS     NAMES
ff49e486887c   nginx:latest   "/docker-entrypoint.…"   22 seconds ago   Up 17 seconds   80/tcp    apps
```

`docker exec -it ff49e486887c /bin/bash`  
`ls /tmp`  
```console
sample.txt
```

`cat /tmp/sample.txt `
```console
This is a sample file!!
```



```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:62c5502534c4331d7e2d7266
```
