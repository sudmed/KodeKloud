# Install a package
: '
As per new application requirements shared by the Nautilus project development team, several new packages need to be installed 
on all app servers in Stratos Datacenter. Most of them are completed except for telnet.
Therefore, install the epel-release package on all app-servers.
'


# on each App server 
yum update && yum install -y epel-release

# and validate
cd /etc/yum.repos.d
ll
epel.repo	# must be here
