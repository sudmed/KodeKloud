# Resolve Git Merge Conflicts
: '
Sarah and Max were working on writting some stories which they have pushed to the repository. Max has recently added some new changes and is trying to push them to the repository but he is facing some issues. Below you can find more details:
SSH into storage server using user max and password Max_pass123. Under /home/max you will find the story-blog repository. Try to push the changes to the origin repo and fix the issues. The story-index.txt must have titles for all 4 stories. Additionally, there is a typo in The Lion and the Mooose line where Mooose should be Mouse.
Click on the Gitea UI button on the top bar. You should be able to access the Gitea page. You can login to Gitea server from UI using username sarah and password Sarah_pass123 or username max and password Max_pass123.
Note: For these kind of scenarios requiring changes to be done in a web UI, please take screenshots so that you can share it with us for review in case your task is marked incomplete. You may also consider using a screen recording software such as loom.com to record and share your work.
'


ssh max@ststor01
cd story-blog/
git status
git pull origin master

git status
# out:
On branch master                                                                                                 
Your branch and 'origin/master' have diverged,
and have 1 and 1 different commits each, respectively.
  (use "git pull" to merge the remote branch into yours)
You have unmerged paths.                                                                                         
  (fix conflicts and run "git commit")
Unmerged paths:                                                                                                  
  (use "git add <file>..." to mark resolution)                                                                   
        both added:      story-index.txt


cat story-index.txt
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


vi story-index.txt
1. The Lion and the Mouse
2. The Frogs and the Ox
3. The Fox and the Grapes
4. The Donkey and the Dog


git config --global --edit
# This is Git's per-user configuration file.
[user]
# Please adapt and uncomment the following lines:
#       name = Max
#       email = max@ststor01.stratos.xfusioncorp.com

git add .
git commit -m "fix typo and merge request"
git push origin master
git status

# Validate the task by GUI
