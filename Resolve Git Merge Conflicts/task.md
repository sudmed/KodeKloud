# Resolve Git Merge Conflicts

Sarah and Max were working on writting some stories which they have pushed to the repository. Max has recently added some new changes and is trying to push them to the repository but he is facing some issues. Below you can find more details:  
SSH into storage server using user max and password Max_pass123. Under /home/max you will find the story-blog repository. Try to push the changes to the origin repo and fix the issues. The story-index.txt must have titles for all 4 stories. Additionally, there is a typo in The Lion and the Mooose line where Mooose should be Mouse.  
Click on the Gitea UI button on the top bar. You should be able to access the Gitea page. You can login to Gitea server from UI using username sarah and password Sarah_pass123 or username max and password Max_pass123.  
Note: For these kind of scenarios requiring changes to be done in a web UI, please take screenshots so that you can share it with us for review in case your task is marked incomplete. You may also consider using a screen recording software such as loom.com to record and share your work.  


## 1. Login on storage server
`ssh max@ststor01`    # Max_pass123  

`cd story-blog/`  


`ls`
```console
fox-and-grapes.txt  frogs-and-ox.txt    lion-and-mouse.txt  story-index.txt
```


`git status`  
```console
On branch master
Your branch is ahead of 'origin/master' by 1 commit.
  (use "git push" to publish your local commits)
nothing to commit, working directory clean
```


`git pull origin master`  
```console
remote: Enumerating objects: 4, done.
remote: Counting objects: 100% (4/4), done.
remote: Compressing objects: 100% (3/3), done.
remote: Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
Unpacking objects: 100% (3/3), done.
From http://git.stratos.xfusioncorp.com/sarah/story-blog
 * branch            master     -> FETCH_HEAD
   cc40d55..76ae313  master     -> origin/master
Auto-merging story-index.txt
CONFLICT (add/add): Merge conflict in story-index.txt
Automatic merge failed; fix conflicts and then commit the result.
```


`git status`  
```console
On branch master
Your branch and 'origin/master' have diverged,
and have 1 and 1 different commits each, respectively.
  (use "git pull" to merge the remote branch into yours)
You have unmerged paths.
  (fix conflicts and run "git commit")
Unmerged paths:
  (use "git add <file>..." to mark resolution)
        both added:      story-index.txt
no changes added to commit (use "git add" and/or "git commit -a")
```


## 2. Edit the merge conflict file
`cat story-index.txt`
```console
<<<<<<< HEAD                                                                                                     
1. The Lion and the Mooose
2. The Frogs and the Ox
3. The Fox and the Grapes
4. The Donkey and the Dog
=======
1. The Lion and the Mouse
2. The Frogs and the Ox
3. The Fox and the Grapes
>>>>>>> d51014aac14caa2bb5a2f027a58221d8a576874d
```


`vi story-index.txt`
```console
1. The Lion and the Mouse
2. The Frogs and the Ox
3. The Fox and the Grapes
4. The Donkey and the Dog
```


## 3. Add config max user
`git config --global --edit`
```console
# This is Git's per-user configuration file.
[user]
# Please adapt and uncomment the following lines:
#       name = Max
#       email = max@ststor01.stratos.xfusioncorp.com
```


## 4. Add and commit
`git add .`  

`git commit -m "fix typo and merge request"`  
```console
[master 59cc206] fix typo and merge request
```

`git push origin master`
```console
Username for 'http://git.stratos.xfusioncorp.com': max
Password for 'http://max@git.stratos.xfusioncorp.com': 
Counting objects: 7, done.
Delta compression using up to 36 threads.
Compressing objects: 100% (7/7), done.
Writing objects: 100% (7/7), 1.17 KiB | 0 bytes/s, done.
Total 7 (delta 1), reused 0 (delta 0)
remote: . Processing 1 references
remote: Processed 1 references in total
To http://git.stratos.xfusioncorp.com/sarah/story-blog.git
   76ae313..59cc206  master -> master
```

`git status`
```console
On branch master
Your branch is up-to-date with 'origin/master'.
nothing to commit, working directory clean
```


## 5. Validate the task by GUI on Gitea server



```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:62ce98b32b205400a6281c05
```
