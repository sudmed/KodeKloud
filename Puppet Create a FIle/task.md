# Puppet Create a FIle

The Puppet master and Puppet agent nodes have been set up by the Nautilus DevOps team so they can perform testing.  
In Stratos DC all app servers have been configured as Puppet agent nodes. Below are details about the testing scenario they want to proceed with.  
Use Puppet file resource and perform the below given task:  
Create a Puppet programming file news.pp under /etc/puppetlabs/code/environments/production/manifests directory on master node i.e Jump Server.  
Using /etc/puppetlabs/code/environments/production/manifests/news.pp create a file news.txt under /opt/finance directory on App Server 1.  
Notes:  
:- Please make sure to run the puppet agent test using sudo on agent nodes, otherwise you can face certificate issues.  
In that case you will have to clean the certificates first and then you will be able to run the puppet agent test.
:- Before clicking on the Check button please make sure to verify puppet server and puppet agent services are up and running on the respective servers,  
also please make sure to run puppet agent test to apply/test the changes manually first.  
:- Please note that once lab is loaded, the puppet server service should start automatically on puppet master server, however it can take upto 2-3 minutes to start.


### 1. Go to the directory from our task
`cd /etc/puppetlabs/code/environments/production/manifests/`


### 2. Create the puppet file
`vi news.pp`
```bash
class file_creator {
  file { '/opt/finance/news.txt':
    ensure => 'present',
  }
}
 node 'stapp01.stratos.xfusioncorp.com' {
  include file_creator
}
```


### 3. Validate the puppet file
`puppet parser validate news.pp`


### 4. Logon to stapp01 server and become root
`ssh tony@stapp01`  
`sudo -i`


### 5. Run the puppet agent
`puppet agent -tv`
```console
Info: Using configured environment 'production'
Info: Retrieving pluginfacts
Info: Retrieving plugin
Info: Retrieving locales
Info: Caching catalog for stapp01.stratos.xfusioncorp.com
Info: Applying configuration version '1655527726'
Notice: /Stage[main]/File_creator/File[/opt/finance/news.txt]/ensure: created
Notice: Applied catalog in 0.02 seconds
```


### 6. Validate the task
`ll /opt/finance/`
```console
-rw-r--r-- 1 root root 0 Jun 18 08:29 news.txt
```


```console
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:62ac7bd16bdb981bf46595f3
```
