# Git Merge Branches

The Nautilus application development team has been working on a project repository /opt/news.git.  
This repo is cloned at /usr/src/kodekloudrepos on storage server in Stratos DC. They recently shared the following requirements with nautilus team:  
a) Create a new branch nautilus in /usr/src/kodekloudrepos/news repo from master and copy the /tmp/index.html file (on storage server itself). Add/commit this file in the new branch and merge back that branch to the master branch. Finally, push the changes to origin for both of the branches.  


## 1. Login to the storage server
`ssh natasha@ststor01`  
`sudo -i`  


## 2. Check git repo
`cd /usr/src/kodekloudrepos`  
`ll`  
```console
total 4
drwxr-xr-x 3 root root 4096 Sep 21 15:17 news
```

`cd news/`  
`ll`  
```console
total 8
-rw-r--r-- 1 root root 34 Sep 21 15:17 info.txt
-rw-r--r-- 1 root root 26 Sep 21 15:17 welcome.txt
```

`git status`
```console
# On branch master
nothing to commit, working directory clean
```


## 3. Create new branch
`git checkout -b nautilus`  
```console
Switched to a new branch 'nautilus'
```

`git status`  
```console
# On branch nautilus
nothing to commit, working directory clean
```


## 4. Copy index file
`git branch`  
```console
  master
* nautilus
```

`cp /tmp/index.html /usr/src/kodekloudrepos/news/`  
`ll`  
```console
total 12
-rw-r--r-- 1 root root 27 Sep 21 15:23 index.html
-rw-r--r-- 1 root root 34 Sep 21 15:17 info.txt
-rw-r--r-- 1 root root 26 Sep 21 15:17 welcome.txt
```


## 5. Commit changes & merge
`git add .`  

`git commit -m "Add index.html"`  
```console
[nautilus fd7259d] Add index.html
 1 file changed, 1 insertion(+)
 create mode 100644 index.html
```

`git branch -avv`  
```console
  master                084080a [origin/master] initial commit
* nautilus              fd7259d Add index.html
  remotes/origin/master 084080a initial commit
```

`git push origin nautilus`  
```console
Counting objects: 4, done.
Delta compression using up to 36 threads.
Compressing objects: 100% (2/2), done.
Writing objects: 100% (3/3), 331 bytes | 0 bytes/s, done.
Total 3 (delta 0), reused 0 (delta 0)
To /opt/news.git
 * [new branch]      nautilus -> nautilus
```

`git checkout master`  
```console
Switched to branch 'master'
```

`git merge nautilus`  
```console
Updating 084080a..fd7259d
Fast-forward
 index.html | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 index.html
```

`git push origin master`  
```console
Total 0 (delta 0), reused 0 (delta 0)
To /opt/news.git
   084080a..fd7259d  master -> master
```

---


```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:632ac553cdeeee504e8edd08
```
