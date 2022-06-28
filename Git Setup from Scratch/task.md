# Git Setup from Scratch
Some new developers have joined xFusionCorp Industries and have been assigned Nautilus project. They are going to start development on a new application,  
and some pre-requisites have been shared with the DevOps team to proceed with. Please note that all tasks need to be performed on storage server in Stratos DC.  
a. Install git, set up any values for user.email and user.name globally and create a bare repository /opt/official.git.  
b. There is an update hook (to block direct pushes to master branch) under /tmp on storage server itself; use the same to block direct pushes to master branch in /opt/official.git repo.  
c. Clone /opt/official.git repo in /usr/src/kodekloudrepos/official directory.  
d. Create a new branch xfusioncorp_official in repo that you cloned in /usr/src/kodekloudrepos.  
e. There is a readme.md file in /tmp on storage server itself; copy that to repo, add/commit in the new branch you created, and finally push your branch to origin.  
f. Also create master branch from your branch and remember you should not be able to push to master as per hook you have set up.


## 1.  login on to the storage server
`ssh natasha@172.16.238.15`    # Bl@kW
`sudo -i`

## 2. Install Git
`yum install -y git`

## 3. Setup user git config
`git config --global --add user.name natasha`  
`git config --global --add user.email natasha@stratos.xfusioncorp.com`


## 4. Create a bare repository
`mkdir /opt/official.git && cd $_`  
`git init --bare`


## 5. Copy update hook to hooks directory
`cp /tmp/update /opt/official.git/hooks/`


## 6. Clone git repository
`cd /usr/src/kodekloudrepos/`  
`git clone /opt/official.git`  


## 7. Create a new branch
`git checkout -b xfusioncorp_official`


## 8. Copy file to repo and push to origin
`cp /tmp/readme.md .`  
`git add readme.md`  
`git commit -m "Readme file"`  
`git push origin xfusioncorp_official`


## 9. Trying to push to master
`git checkout -b master`  
`git branch`  
`git push origin master`  
```console
<...>
 ! [remote rejected] master -> master (hook declined)
```
