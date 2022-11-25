# Git Revert Some Changes


The Nautilus application development team was working on a git repository /usr/src/kodekloudrepos/ecommerce present on Storage server in Stratos DC. However, they reported an issue with the recent commits being pushed to this repo. They have asked the DevOps team to revert repo HEAD to last commit. Below are more details about the task:  
- In /usr/src/kodekloudrepos/ecommerce git repository, revert the latest commit ( HEAD ) to the previous commit (JFYI the previous commit hash should be with initial commit message ).
- Use revert ecommerce message (please use all small letters for commit message) for the new revert commit.  


## 1. Login on server
`ssh natasha@ststor01`  
`sudo -i`  


## 2. Check repository status 
`cd /usr/src/kodekloudrepos/ecommerce/`  
`ll`  
```console
total 4
-rw-r--r-- 1 root root 33 Sep 23 10:09 ecommerce.txt
```

`cat ecommerce.txt`  
```console
These changes should be reverted
```

`git status`
```console
# On branch master
# Untracked files:
#   (use "git add <file>..." to include in what will be committed)
#
#       ecommerce.txt
nothing added to commit but untracked files present (use "git add" to track)
```


## 3. Check Git log
`git log`  
```console
commit aabe3a647519e42d057ff3d3977c67019a73a3f1
Author: Admin <admin@kodekloud.com>
Date:   Fri Sep 23 10:09:41 2022 +0000

    add data.txt file

commit c95d652512af01b30a45816c5b41d22807772003
Author: Admin <admin@kodekloud.com>
Date:   Fri Sep 23 10:09:41 2022 +0000

    initial commit
```


## 4. Git revert
`git revert HEAD`  
```console
[master 395839c] Revert "add data.txt file"
 1 file changed, 1 insertion(+)
 create mode 100644 info.txt
``` 
 
`git add .`  
`git commit -m "revert ecommerce"`  
```console
[master 0e692c5] revert ecommerce
 1 file changed, 1 insertion(+)
 create mode 100644 ecommerce.txt
```


## 5. Validate the task
`git log`  
```console
commit 0e692c5c5be56785f5c0e570db9bbb2ab998ed73
Author: Admin <admin@kodekloud.com>
Date:   Fri Sep 23 10:14:12 2022 +0000

    revert ecommerce

commit 395839c8e43420e376f17be6427c31b09093e86c
Author: Admin <admin@kodekloud.com>
Date:   Fri Sep 23 10:13:33 2022 +0000

    Revert "add data.txt file"
    
    This reverts commit aabe3a647519e42d057ff3d3977c67019a73a3f1.

commit aabe3a647519e42d057ff3d3977c67019a73a3f1
Author: Admin <admin@kodekloud.com>
Date:   Fri Sep 23 10:09:41 2022 +0000

    add data.txt file

commit c95d652512af01b30a45816c5b41d22807772003
Author: Admin <admin@kodekloud.com>
Date:   Fri Sep 23 10:09:41 2022 +0000

    initial commit
```


---


```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:632c8781ef910936ba7a5372
```


---


```bash

CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:638077017f37e31c5a755aab
```
