# Git Clone Repositories

DevOps team created a new Git repository last week; however, as of now no team is using it. The Nautilus application development team recently asked for a copy of that repo on Storage server in Stratos DC. Please clone the repo as per details shared below:  
The repo that needs to be cloned is /opt/blog.git.  
Clone this git repository under /usr/src/kodekloudrepos directory. Please do not try to make any changes in repo.  


## 1. Login to destination server
`ssh natasha@ststor01`  
`sudo -i`  

## 2. Clone git repository under directory mentioned in your task
`cd /usr/src/kodekloudrepos`  
`git clone /opt/blog.git`  
```console
Cloning into 'blog'...
warning: You appear to have cloned an empty repository.
done.
```

## 3. Validate the task successfully by list the folder
`ll blog/`  
```console
total 0
```

---

```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:631c52dba02e43978fde0cf1
```
