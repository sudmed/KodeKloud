# Save, Load and Transfer Docker Image

One of the DevOps team members was working on to create a new custom docker image on App Server 1 in Stratos DC. He is done with his changes and image is saved on same server with name ecommerce:nautilus. Recently a requirement has been raised by a team to use that image for testing, but the team wants to test the same on App Server 3. So we need to provide them that image on App Server 3 in Stratos DC.  
a. On App Server 1 save the image ecommerce:nautilus in an archive.  
b. Transfer the image archive to App Server 3.  
c. Load that image archive on App Server 3 with same name and tag which was used on App Server 1.  
Note: Docker is already installed on both servers; however, if its service is down please make sure to start it.  


## 1. Login on source server and list docker images
`ssh tony@stapp01`  
`sudo -i`  
`docker image list`  
```console
REPOSITORY   TAG        IMAGE ID       CREATED              SIZE
ecommerce    nautilus   9de5424c01b9   About a minute ago   114MB
ubuntu       latest     2dc39ba059dc   7 days ago           77.8MB
```


## 2. Save the image from task in an archive
`docker save -o /tmp/ecommerce.tar ecommerce:nautilus`  

`ll -h /tmp`  
```console
total 112M
-rwxr-xr-x 1 root root  239 Sep  9 08:25 docker_container.sh
-rw------- 1 root root 112M Sep  9 08:29 ecommerce.tar
-rwx------ 1 root root  836 Aug  1  2019 ks-script-rnBCJB
-rw------- 1 root root    0 Aug  1  2019 yum.log
```


## 3. Transfer an archive to destination server
`scp /tmp/ecommerce.tar banner@stapp03:/tmp`  
```console
The authenticity of host 'stapp03 (172.16.238.12)' can't be established.
ECDSA key fingerprint is SHA256:+FeHOXDL0BbEPxuRV1vuR5y6xZzUAxPwe5izV81Z2Ww.
ECDSA key fingerprint is MD5:1b:51:ed:82:5a:1b:da:96:eb:aa:52:2b:d5:92:7b:2b.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'stapp03,172.16.238.12' (ECDSA) to the list of known hosts.
banner@stapp03's password: 
ecommerce.tar
```


## 4. Login on destination server and check just copied archive
`ssh banner@stapp03`  
`sudo -i`  
`ll -h /tmp`  
```console
total 112M
-rw------- 1 banner banner 112M Sep  9 08:30 ecommerce.tar
-rwx------ 1 root   root    836 Aug  1  2019 ks-script-rnBCJB
-rw------- 1 root   root      0 Aug  1  2019 yum.log
```


## 5. Check if Docker exists on destination server
`docker version`  
```console
Client: Docker Engine - Community
 Version:           20.10.7
 API version:       1.41
 Go version:        go1.13.15
 Git commit:        f0df350
 Built:             Wed Jun  2 11:58:10 2021
 OS/Arch:           linux/amd64
 Context:           default
 Experimental:      true
Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?
```

`systemctl status docker`  
```console
● docker.service - Docker Application Container Engine
   Loaded: loaded (/usr/lib/systemd/system/docker.service; disabled; vendor preset: disabled)
   Active: inactive (dead)
     Docs: https://docs.docker.com
```

`systemctl start docker`  

`systemctl enable docker`  
```console
Created symlink from /etc/systemd/system/multi-user.target.wants/docker.service to /usr/lib/systemd/system/docker.service.
```


## 6. Load the image archive
`docker load -i ecommerce.tar`  
```console
7f5cbd8cc787: Loading layer [==================================================>]  80.35MB/80.35MB
7e4824686e36: Loading layer [==================================================>]  36.26MB/36.26MB
Loaded image: ecommerce:nautilus
```


## 7. Validate the task
`docker image list`  
```console
REPOSITORY   TAG        IMAGE ID       CREATED         SIZE
ecommerce    nautilus   9de5424c01b9   6 minutes ago   114MB
```

---


```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:6318cf26aaae7661d868d75f
```
