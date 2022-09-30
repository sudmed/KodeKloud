# Git Setup from Scratch

Some new developers have joined xFusionCorp Industries and have been assigned Nautilus project. They are going to start development on a new application, and some pre-requisites have been shared with the DevOps team to proceed with. Please note that all tasks need to be performed on storage server in Stratos DC.  
- a. Install git, set up any values for user.email and user.name globally and create a bare repository /opt/media.git.
- b. There is an update hook (to block direct pushes to master branch) under /tmp on storage server itself; use the same to block direct pushes to master branch in /opt/media.git repo.
- c. Clone /opt/media.git repo in /usr/src/kodekloudrepos/media directory.
- d. Create a new branch xfusioncorp_media in repo that you cloned in /usr/src/kodekloudrepos.
- e. There is a readme.md file in /tmp on storage server itself; copy that to repo, add/commit in the new branch you created, and finally push your branch to origin.
- f. Also create master branch from your branch and remember you should not be able to push to master as per hook you have set up.  

## 1. Install Git on storage server
`ssh natasha@ststor01`  

`sudo -i`  

`hostnamectl`  
```console
Static hostname: ststor01.stratos.xfusioncorp.com
         Icon name: computer-container
           Chassis: container
        Machine ID: 3575bae5de774b958660f7ad0094e79c
           Boot ID: 55e5ea09ee7f4f6f944d4a6be9affdaf
    Virtualization: docker
  Operating System: CentOS Linux 7 (Core)
       CPE OS Name: cpe:/o:centos:centos:7
            Kernel: Linux 5.4.0-1087-gcp
      Architecture: x86-64
```      

`yum install -y git` 
```console
Dependency Installed:
  groff-base.x86_64 0:1.22.2-8.el7                  less.x86_64 0:458-9.el7                      libedit.x86_64 0:3.0-12.20121213cvs.el7      openssh-clients.x86_64 0:7.4p1-22.el7_9     
  perl.x86_64 4:5.16.3-299.el7_9                    perl-Carp.noarch 0:1.26-244.el7              perl-Encode.x86_64 0:2.51-7.el7              perl-Error.noarch 1:0.17020-2.el7           
  perl-Exporter.noarch 0:5.68-3.el7                 perl-File-Path.noarch 0:2.09-2.el7           perl-File-Temp.noarch 0:0.23.01-3.el7        perl-Filter.x86_64 0:1.49-3.el7             
  perl-Getopt-Long.noarch 0:2.40-3.el7              perl-Git.noarch 0:1.8.3.1-23.el7_8           perl-HTTP-Tiny.noarch 0:0.033-3.el7          perl-PathTools.x86_64 0:3.40-5.el7          
  perl-Pod-Escapes.noarch 1:1.04-299.el7_9          perl-Pod-Perldoc.noarch 0:3.20-4.el7         perl-Pod-Simple.noarch 1:3.28-4.el7          perl-Pod-Usage.noarch 0:1.63-3.el7          
  perl-Scalar-List-Utils.x86_64 0:1.27-248.el7      perl-Socket.x86_64 0:2.010-5.el7             perl-Storable.x86_64 0:2.45-3.el7            perl-TermReadKey.x86_64 0:2.30-20.el7       
  perl-Text-ParseWords.noarch 0:3.29-4.el7          perl-Time-HiRes.x86_64 4:1.9725-3.el7        perl-Time-Local.noarch 0:1.2300-2.el7        perl-constant.noarch 0:1.27-2.el7           
  perl-libs.x86_64 4:5.16.3-299.el7_9               perl-macros.x86_64 4:5.16.3-299.el7_9        perl-parent.noarch 1:0.225-244.el7           perl-podlators.noarch 0:2.5.1-3.el7         
  perl-threads.x86_64 0:1.87-4.el7                  perl-threads-shared.x86_64 0:1.43-6.el7      rsync.x86_64 0:3.1.2-11.el7_9               

Dependency Updated:
  openssh.x86_64 0:7.4p1-22.el7_9                                                           openssh-server.x86_64 0:7.4p1-22.el7_9                                                          
Complete!
```


## 2. Setup user Git config
`git config --global --add user.name natasha`  
`git config --global --add user.email natasha@stratos.xfusioncorp.com`  


## 3. Create a bare repository
`mkdir -p /opt/media.git && cd $_`  

`git init --bare /opt/media.git`  
```console
Initialized empty Git repository in /opt/media.git/
```

`ll`  
```console
total 32
drwxr-xr-x 2 root root 4096 Sep 30 20:47 branches
-rw-r--r-- 1 root root   66 Sep 30 20:47 config
-rw-r--r-- 1 root root   73 Sep 30 20:47 description
-rw-r--r-- 1 root root   23 Sep 30 20:47 HEAD
drwxr-xr-x 2 root root 4096 Sep 30 20:47 hooks
drwxr-xr-x 2 root root 4096 Sep 30 20:47 info
drwxr-xr-x 4 root root 4096 Sep 30 20:47 objects
drwxr-xr-x 4 root root 4096 Sep 30 20:47 refs
```


## 4. Copy update hook to hooks directory
`cp /tmp/update /opt/media.git/hooks/`  


## 5. Clone Git repository
`cd /usr/src/kodekloudrepos/`  

`ll`  
```console
total 0
```

`git clone /opt/media.git`  
```console
Cloning into 'media'...
warning: You appear to have cloned an empty repository.
done.
```

`ll`  
```console
total 4
drwxr-xr-x 3 root root 4096 Sep 30 20:50 media
```


## 6. Create new branch
`cd /usr/src/kodekloudrepos/media`  

`git checkout -b xfusioncorp_media`  
```console
Switched to a new branch 'xfusioncorp_media'
```


## 7. Copy readme.md file
`cp /tmp/readme.md .`  

`cat readme.md`  
```console
Welcome to xFusionCorp Industries
```

`git add .`  

`git commit -m "Add readme file"`  
```console
[xfusioncorp_media (root-commit) 4762f07] Add readme file
 1 file changed, 1 insertion(+)
 create mode 100644 readme.md
```

`git push origin xfusioncorp_media`  
```console
Counting objects: 3, done.
Writing objects: 100% (3/3), 251 bytes | 0 bytes/s, done.
Total 3 (delta 0), reused 0 (delta 0)
To /opt/media.git
 * [new branch]      xfusioncorp_media -> xfusioncorp_media
```


## 8. Validate the task - try to push to master
`git checkout -b master`  
```console
Switched to a new branch 'master'
```

`git branch`  
```console
* master
  xfusioncorp_media
```

`git push origin master`  
```console
Total 0 (delta 0), reused 0 (delta 0)
remote: Manual pushing to this repo's master branch is restricted
remote: error: hook declined to update refs/heads/master
To /opt/media.git
 ! [remote rejected] master -> master (hook declined)
error: failed to push some refs to '/opt/media.git'
```

# You Shall Not Push to Master!

---

```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:63360825f0e56c59270a38f4
```
