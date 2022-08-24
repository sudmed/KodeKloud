# Create a Docker Image From Container
One of the Nautilus developer was working to test new changes on a container. He wants to keep a backup of his changes to the container.  
A new request has been raised for the DevOps team to create a new image from this container. Below are more details about it:  
a. Create an image blog:datacenter on Application Server 2 from a container ubuntu_latest that is running on same server.


## 0. Login to Application Server 2
`ssh steve@stapp02`  
```console
steve@stapp02's password: Am3ric@
```

`sudo -i`  
```console
We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for steve: Am3ric@
```


## 1. Show running docker containers
`docker ps`  
```console
CONTAINER ID   IMAGE     COMMAND   CREATED         STATUS         PORTS     NAMES
5c8a6c858776   ubuntu    "bash"    3 minutes ago   Up 3 minutes             ubuntu_latest
```


## 2. Show docker images
```console
docker image list
REPOSITORY   TAG       IMAGE ID       CREATED       SIZE
ubuntu       latest    df5de72bdb3b   3 weeks ago   77.8MB
```


## 3. Create new docker image
`docker commit ubuntu_latest blog:datacenter`  
```console
sha256:05751720dae901240280b862faf6cb123e24f542284f0c3b2ca079ea6076f059
```


## 4. Check new image
```console
docker image list
REPOSITORY   TAG          IMAGE ID       CREATED          SIZE
blog         datacenter   05751720dae9   19 seconds ago   114MB
ubuntu       latest       df5de72bdb3b   3 weeks ago      77.8MB
```


---

```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:630524d30bb9e201e6454d6c
```
