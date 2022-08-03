# Puppet Setup File Permissions

The Nautilus DevOps team has put some data on all app servers in Stratos DC. jump host is configured as Puppet master server, and all app servers are already been configured as Puppet agent nodes. The team needs to update the content of some of the exiting files, as well as need to update their permissions etc. Please find below more details about the task:  
Create a Puppet programming file apps.pp under /etc/puppetlabs/code/environments/production/manifests directory on the master node i.e Jump Server. Using puppet file resource, perform the below mentioned tasks.  
A file named ecommerce.txt already exists under /opt/dba directory on App Server 1.  
Add content Welcome to xFusionCorp Industries! in ecommerce.txt file on App Server 1.  
Set its permissions to 0777.  
Notes: :- Please make sure to run the puppet agent test using sudo on agent nodes, otherwise you can face certificate issues. In that case you will have to clean the certificates first and then you will be able to run the puppet agent test.  
:- Before clicking on the Check button please make sure to verify puppet server and puppet agent services are up and running on the respective servers, also please make sure to run puppet agent test to apply/test the changes manually first.  
:- Please note that once lab is loaded, the puppet server service should start automatically on puppet master server, however it can take upto 2-3 minutes to start.  


## 1. Create puppet file
`vi /etc/puppetlabs/code/environments/production/manifests/apps.pp`  
```yaml
class file_modifier {
   # Update ecommerce.txt under /opt/dba
   file { '/opt/dba/ecommerce.txt':
     ensure => 'present',
     content => 'Welcome to xFusionCorp Industries!',
     mode => '0777',
   }
 }
 node 'stapp01.stratos.xfusioncorp.com' {
   include file_modifier
 }
```


## 2. Validate the puppet file
`puppet parser validate apps.pp`  


## 3. Login on App server
`ssh tony@stapp01    # Ir0nM@n`  

`puppet agent -tv`  
```bash
Info: Using configured environment 'production'
Info: Retrieving pluginfacts
Info: Retrieving plugin
Info: Retrieving locales
Info: Caching catalog for stapp01.stratos.xfusioncorp.com
Info: Applying configuration version '1659538034'
Notice: /Stage[main]/File_modifier/File[/opt/dba/ecommerce.txt]/content: 
--- /opt/dba/ecommerce.txt      2022-08-03 14:40:42.932589718 +0000
+++ /tmp/puppet-file20220803-651-pkio7z 2022-08-03 14:47:16.323875022 +0000
@@ -0,0 +1 @@
+Welcome to xFusionCorp Industries!
\ No newline at end of file

Info: Computing checksum on file /opt/dba/ecommerce.txt
Info: /Stage[main]/File_modifier/File[/opt/dba/ecommerce.txt]: Filebucketed /opt/dba/ecommerce.txt to puppet with sum d41d8cd98f00b204e9800998ecf8427e
Notice: /Stage[main]/File_modifier/File[/opt/dba/ecommerce.txt]/content: content changed '{md5}d41d8cd98f00b204e9800998ecf8427e' to '{md5}b899e8a90bbb38276f6a00012e1956fe'
Notice: /Stage[main]/File_modifier/File[/opt/dba/ecommerce.txt]/mode: mode changed '0644' to '0777'
Notice: Applied catalog in 0.16 seconds
```


## 4. alidate the task on App server
`cat /opt/dba/ecommerce.txt`  
```console
Welcome to xFusionCorp Industries!
```


```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:62e8da789632143213f930d3
```
