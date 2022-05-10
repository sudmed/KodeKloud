# Git Install and Create Bare Repository
: '
The Nautilus development team shared requirements with the DevOps team regarding new application development.—specifically, 
they want to set up a Git repository for that project. Create a Git repository on Storage server in Stratos DC as per details given below:
Install git package using yum on Storage server.
After that create a bare repository /opt/games.git (make sure to use exact name).
'


yum install git -y
cd /opt/
git init --bare games.git


# You created the repo "cluster.git" instead of 'games.git'.
