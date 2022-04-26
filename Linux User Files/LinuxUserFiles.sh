### Linux User Files
: '
There was some users data copied on Nautilus App Server 1 at /home/usersdata location by the Nautilus production support team in Stratos DC. 
Later they found that they mistakenly mixed up different user data there. Now they want to filter out some user data and copy it to another location. 
Find the details below:
On App Server 1 find all files (not directories) owned by user yousuf inside /home/usersdata directory and copy them all while keeping the folder structure 
(preserve the directories path) to /media directory.
'


ll /home/usersdata/
ll /official/
find /home/usersdata/ -type f -user yousuf | wc -l
find /home/usersdata/ -type f -user yousuf -exec cp --parents {} /official \;

# Another way (didn't checked)
cd /home/userdata/
find . -user yousuf | cpio -pdm /official
cd /official
ls
