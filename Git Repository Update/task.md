# Git Repository Update

The Nautilus development team started with new project development. They have created different Git repositories to manage respective project's source code.  
One of the repo /opt/official.git was created recently. The team has given us a sample index.html file that is currently present on jump host under /tmp.  
The repository has been cloned at /usr/src/kodekloudrepos on storage server in Stratos DC.  
Copy sample index.html file from jump host to storage server under cloned repository at /usr/src/kodekloudrepos, add/commit the file and push to master branch.  


## 0. Check the file
`ll /tmp`  
```console
total 8
-rw-rw-r-- 1 thor thor   0 Aug  4 15:24 demofile2.json
-rw-r--r-- 1 root root  27 Aug  4 15:24 index.html
-rwx------ 1 root root 836 Aug  1  2019 ks-script-rnBCJB
-rw------- 1 root root   0 Aug  1  2019 yum.log
```

`cat index.html`  
```console
Welcome to Nautilus Group !
```


## 1. Copy the file to Storage Server
`sudo scp /tmp/index.html natasha@ststor01:/tmp`  
```console
We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for thor: 
The authenticity of host 'ststor01 (172.16.238.15)' can't be established.
ECDSA key fingerprint is SHA256:fXbAAzzAnYa/tNDwq9XkZXoyQMXXB51yZIT+R6WFbks.
ECDSA key fingerprint is MD5:ba:20:a8:b1:4c:2c:00:7f:51:99:1a:b5:1f:34:07:95.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'ststor01,172.16.238.15' (ECDSA) to the list of known hosts.
natasha@ststor01's password: 
index.html                                                               
```


## 2. Login to Storage Server
`ssh natasha@ststor01` 
```console
The authenticity of host 'ststor01 (172.16.238.15)' can't be established.
ECDSA key fingerprint is SHA256:fXbAAzzAnYa/tNDwq9XkZXoyQMXXB51yZIT+R6WFbks.
ECDSA key fingerprint is MD5:ba:20:a8:b1:4c:2c:00:7f:51:99:1a:b5:1f:34:07:95.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'ststor01,172.16.238.15' (ECDSA) to the list of known hosts.
natasha@ststor01's password: 
```

`ll /tmp`  
```console
total 12
-rw-r--r-- 1 root    root    504 Aug  4 15:24 git_repo_script.sh
-rw-r--r-- 1 natasha natasha  27 Aug  4 15:27 index.html
-rwx------ 1 root    root    836 Aug  1  2019 ks-script-rnBCJB
-rw------- 1 root    root      0 Aug  1  2019 yum.log
```


## 3. Copy the file to repo directory
`cd /usr/src/kodekloudrepos/`  
`ll`  
```console
total 4
drwxr-xr-x 3 root root 4096 Aug  4 15:24 official
```

`ll /usr/src/kodekloudrepos/official/`  
```console
total 8
-rw-r--r-- 1 root root 34 Aug  4 15:24 info.txt
-rw-r--r-- 1 root root 26 Aug  4 15:24 welcome.txt
```

`sudo mv /tmp/index.html /usr/src/kodekloudrepos/official`  

`ll /usr/src/kodekloudrepos/official/`  
```console
total 12
-rw-r--r-- 1 natasha natasha 27 Aug  4 15:27 index.html
-rw-r--r-- 1 root    root    34 Aug  4 15:24 info.txt
-rw-r--r-- 1 root    root    26 Aug  4 15:24 welcome.txt
```

## 4. Git add/commit new file
`git status`  
```console
# On branch master
# Untracked files:
#   (use "git add <file>..." to include in what will be committed)
#
#       index.html
nothing added to commit but untracked files present (use "git add" to track)
```

`git add index.html`  
`git status`  
```console
# On branch master
# Changes to be committed:
#   (use "git reset HEAD <file>..." to unstage)
#
#       new file:   index.html
#
```

`git commit -m "Add index.html"`  
```console
[master c52338b] Add index.html
 1 file changed, 1 insertion(+)
 create mode 100644 index.html
```
`git push`  
```console
warning: push.default is unset; its implicit value is changing in
Git 2.0 from 'matching' to 'simple'. To squelch this message
and maintain the current behavior after the default changes, use:

  git config --global push.default matching

To squelch this message and adopt the new behavior now, use:

  git config --global push.default simple

See 'git help config' and search for 'push.default' for further information.
(the 'simple' mode was introduced in Git 1.7.11. Use the similar mode
'current' instead of 'simple' if you sometimes use older versions of Git)

Counting objects: 4, done.
Delta compression using up to 36 threads.
Compressing objects: 100% (2/2), done.
Writing objects: 100% (3/3), 331 bytes | 0 bytes/s, done.
Total 3 (delta 0), reused 0 (delta 0)
To /opt/official.git
   56f7109..c52338b  master -> master
```

`git status`  
```console
# On branch master
nothing to commit, working directory clean
```



```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:62ebe01ab8feb0f9f7bd2395
```
