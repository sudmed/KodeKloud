# Git Install and Create Repository
: '
The Nautilus development team shared with the DevOps team requirements for new application development, setting up a Git repository for that project. 
Create a Git repository on Storage server in Stratos DC as per details given below:
Install git package using yum on Storage server.
After that create/init a git repository /opt/beta.git (use the exact name as asked and make sure not to create a bare repository).
'


ssh natasha@ststor01
sudo -i

yum install -y git

cd /opt/

git init beta.git




: '
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:6294f8fab0d76a5402bb1556
'
