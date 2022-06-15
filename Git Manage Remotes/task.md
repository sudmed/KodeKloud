# Git Manage Remotes

```console
The xFusionCorp development team added updates to the project that is maintained under /opt/blog.git repo and cloned under /usr/src/kodekloudrepos/blog. 
Recently some changes were made on Git server that is hosted on Storage server in Stratos DC. 
The DevOps team added some new Git remotes, so we need to update remote on /usr/src/kodekloudrepos/blog repository as per details mentioned below:
a. In /usr/src/kodekloudrepos/blog repo add a new remote dev_blog and point it to /opt/xfusioncorp_blog.git repository.
b. There is a file /tmp/index.html on same server; copy this file to the repo and add/commit to master branch.
c. Finally push master branch to this new remote origin.
```


### Login on storage server
```bash
ssh natasha@172.16.238.15
```
`sudo -i`


### Navigate to the cloned directory
```bash
cd /usr/src/kodekloudrepos/apps
```
`ll`

```bash
git status
```
```console
# On branch master
nothing to commit, working directory clean
```

`git brabch -avv`
```console
* master                b6c0603 [origin/master] initial commit
  remotes/origin/master b6c0603 initial commit
```


### Add Remote repo
`git remote add dev_blog /opt/xfusioncorp_blog.git`


$$# Copy HTML file from tmp to repo
`cp /tmp/index.html .`  

`ll`


### Git initialize the new remote repo
`git init`
```console
Reinitialized existing Git repository in /usr/src/kodekloudrepos/blog/.git/
```

`git status`
```console
# On branch master
# Untracked files:
#   (use "git add <file>..." to include in what will be committed)
#
#       index.html
nothing added to commit but untracked files present (use "git add" to track)
```

### Add and commit the index.html
`git add index.html`  

`git commit -m "add index.html"`
```console
[master 4b63bfe] add index.html
 1 file changed, 10 insertions(+)
 create mode 100644 index.html
``` 

`git status`
```console
# On branch master
# Your branch is ahead of 'origin/master' by 1 commit.
#   (use "git push" to publish your local commits)
#
nothing to commit, working directory clean
```


### Push the master branch to this new remote origin
`git push -u dev_blog master`
```console
Counting objects: 6, done.
Delta compression using up to 36 threads.
Compressing objects: 100% (4/4), done.
Writing objects: 100% (6/6), 583 bytes | 0 bytes/s, done.
Total 6 (delta 0), reused 0 (delta 0)
To /opt/xfusioncorp_blog.git
 * [new branch]      master -> master
Branch master set up to track remote branch master from dev_blog.
```


`git status`
```console
# On branch master
nothing to commit, working directory clean
```

`git branch -avv`
```console
* master                  4b63bfe [dev_blog/master] add index.html
  remotes/dev_blog/master 4b63bfe add index.html
  remotes/origin/master   b6c0603 initial commit
```



```console
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:62a913df8b77b63294807bf7
```
