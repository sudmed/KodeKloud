# Puppet Add Users
: '
A new teammate has joined the Nautilus application development team, the application development team has asked the DevOps team to create a new user account 
for the new teammate on application server 1 in Stratos Datacenter. The task needs to be performed using Puppet only. You can find more details below about the task.
Create a Puppet programming file cluster.pp under /etc/puppetlabs/code/environments/production/manifests directory on master node i.e Jump Server, and using 
Puppet user resource add a user on all app servers as mentioned below:
Create a user jim and set its UID to 1302 on Puppet agent nodes 1 i.e App Servers 1.
Notes: :- Please make sure to run the puppet agent test using sudo on agent nodes, otherwise you can face certificate issues. In that case you will have to clean 
the certificates first and then you will be able to run the puppet agent test.
:- Before clicking on the Check button please make sure to verify puppet server and puppet agent services are up and running on the respective servers, 
also please make sure to run puppet agent test to apply/test the changes manually first.
:- Please note that once lab is loaded, the puppet server service should start automatically on puppet master server, however it can take upto 2-3 minutes to start.
'


root@jump_host#	cd /etc/puppetlabs/code/environments/production/manifests

vi cluster.pp

class user_creator {
  user { 'jim':
    ensure   => present,
    uid => 1302,
  }
}
node 'stapp01.stratos.xfusioncorp.com' {
include user_creator
}

# Validate the puppet files befor deploying
puppet parser validate cluster.pp

# Login on all App server (stapp01, stapp02, stapp03) & switch to root
cat /etc/passwd | grep jim

puppet agent -tv
	Notice: /Stage[main]/User_creator/User[jim]/ensure: created
	Notice: Applied catalog in 0.08 seconds

cat /etc/passwd | grep jim
	jim:x:1302:1302::/home/jim:/bin/bash



: '
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:6296749ed871dd34946ecd42
'
