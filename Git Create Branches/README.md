# Git Create Branches

Nautilus developers are actively working on one of the project repositories, /usr/src/kodekloudrepos/demo.  
They recently decided to implement some new features in the application, and they want to maintain those new changes in a separate branch.  
Below are the requirements that have been shared with the DevOps team:  
On Storage server in Stratos DC create a new branch xfusioncorp_demo from master branch in /usr/src/kodekloudrepos/demo git repo.  
Please do not try to make any changes in code.  


## 1. Login
`ssh natasha@ststor01    # Bl@kW`  
`sudo -i`  
`cd /usr/src/kodekloudrepos/demo`  

`ll`  
```shell
total 8
-rw-r--r-- 1 root root 34 Aug 20 09:11 data.txt
-rw-r--r-- 1 root root 34 Aug 20 09:11 info.txt
```


## 2. Checkout to master
`git status`  
```shell
# On branch kodekloud_demo
nothing to commit, working directory clean
```

`git branch -avv`  
```shell
* kodekloud_demo        af4c717 add data file
  master                8913eb0 [origin/master] initial commit
  remotes/origin/master 8913eb0 initial commit
```  
  
`git checkout master`  
```shell
Switched to branch 'master'
```


## 3. Create new branch from master
`git checkout -b xfusioncorp_demo`  
```shell
Switched to a new branch 'xfusioncorp_demo'
```


## 4. Validate the task
`git status`  
```shell
# On branch xfusioncorp_demo
nothing to commit, working directory clean
```

---

```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:62fe630380064b998ca6bc36
```
