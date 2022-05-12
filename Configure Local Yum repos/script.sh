# Configure Local Yum repos
: '
The Nautilus production support team and security team had a meeting last month in which they decided to use local yum repositories 
for maintaing packages needed for their servers. For now they have decided to configure a local yum repo on Nautilus Backup Server. 
This is one of the pending items from last month, so please configure a local yum repository on Nautilus Backup Server as per details given below.
a. We have some packages already present at location /packages/downloaded_rpms/ on Nautilus Backup Server.
b. Create a yum repo named localyum and make sure to set Repository ID to localyum. Configure it to use package's location /packages/downloaded_rpms/.
c. Install package httpd from this newly created repo.
'

ssh clint@stbkp01
sudo -i

yum repolist
	repolist: 0


# create local repo  as per the task
vi /etc/yum.repos.d/local_yum.repo
[localyum]
name=localyum
baseurl=file:///packages/downloaded_rpms/
enabled = 1
gpgcheck = 0

# check
yum repolist
	repolist: 55
	
# As per the task install package
yum install httpd

# Validate the task
yum list httpd
	Installed Packages
	httpd.x86_64                                                 2.4.6-90.el7.centos                                                 @local_yum
