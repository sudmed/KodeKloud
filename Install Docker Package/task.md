# Install Docker Package

Last week the Nautilus DevOps team met with the application development team and decided to containerize several of their applications. The DevOps team wants to do some testing per the following:  
Install docker-ce and docker-compose packages on App Server 2.  
Start docker service.  


## 1. Login on the App server 2
`ssh steve@stapp02`  
```console
The authenticity of host 'stapp02 (172.16.238.11)' can't be established.
ECDSA key fingerprint is SHA256:RcU7FQkfCs9Xry9Dqeh8/W7o8DKQr9k4bW7D8mgDvxY.
ECDSA key fingerprint is MD5:6d:82:93:bb:c0:66:6b:45:04:97:02:3a:ec:ff:d0:5d.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'stapp02,172.16.238.11' (ECDSA) to the list of known hosts.
steve@stapp02's password: 
```

`sudo -i`
```console
We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for steve: 
```


## 2. Install docker
`cd /tmp`  
`ll`  
```console
total 4
-rwx------ 1 root root 836 Aug  1  2019 ks-script-rnBCJB
-rw------- 1 root root   0 Aug  1  2019 yum.log
```

`curl -fsSL https://get.docker.com -o get-docker.sh`  
`ll`
```console
total 24
-rw-r--r-- 1 root root 20009 Jul 15 19:21 get-docker.sh
-rwx------ 1 root root   836 Aug  1  2019 ks-script-rnBCJB
-rw------- 1 root root     0 Aug  1  2019 yum.log
```

`sh get-docker.sh`
```console
# Executing docker install script, commit: b2e29ef7a9a89840d2333637f7d1900a83e7153f
+ sh -c 'yum install -y -q yum-utils'
Delta RPMs disabled because /usr/bin/applydeltarpm not installed.
+ sh -c 'yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo'
Loaded plugins: fastestmirror, ovl
adding repo from: https://download.docker.com/linux/centos/docker-ce.repo
grabbing file https://download.docker.com/linux/centos/docker-ce.repo to /etc/yum.repos.d/docker-ce.repo
repo saved to /etc/yum.repos.d/docker-ce.repo
+ '[' stable '!=' stable ']'
+ sh -c 'yum makecache'
Loaded plugins: fastestmirror, ovl
Loading mirror speeds from cached hostfile
 * base: mirror.lostpacket.org
 * extras: repos.forethought.net
 * updates: ftp.ussg.iu.edu
base                                                                                                                                                                  | 3.6 kB  00:00:00     
docker-ce-stable                                                                                                                                                      | 3.5 kB  00:00:00     
extras                                                                                                                                                                | 2.9 kB  00:00:00     
updates                                                                                                                                                               | 2.9 kB  00:00:00     
(1/10): docker-ce-stable/7/x86_64/filelists_db                                                                                                                        |  33 kB  00:00:00     
(2/10): docker-ce-stable/7/x86_64/primary_db                                                                                                                          |  80 kB  00:00:00     
(3/10): docker-ce-stable/7/x86_64/other_db                                                                                                                            | 125 kB  00:00:00     
(4/10): docker-ce-stable/7/x86_64/updateinfo                                                                                                                          |   55 B  00:00:00     
(5/10): extras/7/x86_64/filelists_db                                                                                                                                  | 277 kB  00:00:00     
(6/10): extras/7/x86_64/other_db                                                                                                                                      | 148 kB  00:00:00     
(7/10): updates/7/x86_64/filelists_db                                                                                                                                 | 9.1 MB  00:00:00     
(8/10): updates/7/x86_64/other_db                                                                                                                                     | 1.1 MB  00:00:00     
(9/10): base/7/x86_64/other_db                                                                                                                                        | 2.6 MB  00:00:01     
(10/10): base/7/x86_64/filelists_db                                                                                                                                   | 7.2 MB  00:00:07     
Metadata Cache Created
+ sh -c 'yum install -y -q docker-ce docker-ce-cli containerd.io docker-scan-plugin docker-compose-plugin docker-ce-rootless-extras'
Delta RPMs disabled because /usr/bin/applydeltarpm not installed.
warning: /var/cache/yum/x86_64/7/docker-ce-stable/packages/docker-ce-20.10.17-3.el7.x86_64.rpm: Header V4 RSA/SHA512 Signature, key ID 621e9f35: NOKEY
Public key for docker-ce-20.10.17-3.el7.x86_64.rpm is not installed
Importing GPG key 0x621E9F35:
 Userid     : "Docker Release (CE rpm) <docker@docker.com>"
 Fingerprint: 060a 61c5 1b55 8a7f 742b 77aa c52f eb6b 621e 9f35
 From       : https://download.docker.com/linux/centos/gpg
setsebool:  SELinux is disabled.

================================================================================

To run Docker as a non-privileged user, consider setting up the
Docker daemon in rootless mode for your user:

    dockerd-rootless-setuptool.sh install

Visit https://docs.docker.com/go/rootless/ to learn about rootless mode.


To run the Docker daemon as a fully privileged service, but granting non-root
users access, refer to https://docs.docker.com/go/daemon-access/

WARNING: Access to the remote API on a privileged Docker daemon is equivalent
         to root access on the host. Refer to the 'Docker daemon attack surface'
         documentation for details: https://docs.docker.com/go/attack-surface/

================================================================================
```


`groupadd docker`
```console
groupadd: group 'docker' already exists
```

`usermod -aG docker $USER`  

`newgrp docker`  

`systemctl enable docker`  
```console
Created symlink from /etc/systemd/system/multi-user.target.wants/docker.service to /usr/lib/systemd/system/docker.service.
```

`systemctl start docker`  
`systemctl status docker`  
```console
● docker.service - Docker Application Container Engine
   Loaded: loaded (/usr/lib/systemd/system/docker.service; enabled; vendor preset: disabled)
   Active: active (running) since Fri 2022-07-15 19:23:56 UTC; 1min 51s ago
     Docs: https://docs.docker.com
 Main PID: 1617 (dockerd)
   CGroup: /docker/81694a118a01a71fb2e9963ca58931ce67ceef6b1fad9d6e38852e690842e0a7/system.slice/docker.service
           └─1617 /usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock

Jul 15 19:23:56 stapp02.stratos.xfusioncorp.com systemd[1]: docker.service: Got notification message from PID 1617 (READY=1)
Jul 15 19:23:56 stapp02.stratos.xfusioncorp.com systemd[1]: docker.service: got READY=1
Jul 15 19:23:56 stapp02.stratos.xfusioncorp.com systemd[1]: docker.service changed start -> running
Jul 15 19:23:56 stapp02.stratos.xfusioncorp.com systemd[1]: Job docker.service/start finished, result=done
Jul 15 19:23:56 stapp02.stratos.xfusioncorp.com systemd[1]: Started Docker Application Container Engine.
Jul 15 19:23:56 stapp02.stratos.xfusioncorp.com dockerd[1617]: time="2022-07-15T19:23:56.889511467Z" level=info msg="API listen on /var/run/docker.sock"
Jul 15 19:25:42 stapp02.stratos.xfusioncorp.com systemd[1]: Trying to enqueue job docker.service/start/replace
Jul 15 19:25:42 stapp02.stratos.xfusioncorp.com systemd[1]: Installed new job docker.service/start as 159
Jul 15 19:25:42 stapp02.stratos.xfusioncorp.com systemd[1]: Enqueued job docker.service/start as 159
Jul 15 19:25:42 stapp02.stratos.xfusioncorp.com systemd[1]: Job docker.service/start finished, result=done
```


`docker --version`
```console
Docker version 20.10.17, build 100c701
```

`docker ps`
```console
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```


## 3. Install docker compose
`curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose`
```console
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100 12.1M  100 12.1M    0     0  25.1M      0 --:--:-- --:--:-- --:--:-- 25.1M
```

`chmod +x /usr/local/bin/docker-compose`  

`ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose`  

`docker-compose --version`  
```console
docker-compose version 1.29.2, build 5becea4c
```


## 4. Validate the task
`rpm -qa | grep docker`  
```console
docker-ce-cli-20.10.17-3.el7.x86_64
docker-ce-20.10.17-3.el7.x86_64
docker-compose-plugin-2.6.0-3.el7.x86_64
docker-scan-plugin-0.17.0-3.el7.x86_64
docker-ce-rootless-extras-20.10.17-3.el7.x86_64
```

`docker pull hello-world`
```console
Using default tag: latest
latest: Pulling from library/hello-world
2db29710123e: Pull complete 
Digest: sha256:53f1bbee2f52c39e41682ee1d388285290c5c8a76cc92b42687eecf38e0af3f0
Status: Downloaded newer image for hello-world:latest
docker.io/library/hello-world:latest
```

`docker run hello-world`
```console
docker: Error response from daemon: using mount program fuse-overlayfs: fuse: device not found, try 'modprobe fuse' first
fuse-overlayfs: cannot mount: No such file or directory
: exit status 1.
See 'docker run --help'.
```

`docker images list`
```console
REPOSITORY   TAG       IMAGE ID   CREATED   SIZE
```

**WTF???**


```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:62d1ba0a9ba4fba650d12912
```
