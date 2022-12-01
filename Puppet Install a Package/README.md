# Puppet Install a Package

Some new packages need to be installed on app server 3 in Stratos Datacenter. The Nautilus DevOps team has decided to install the same using Puppet. Since jump host is already configured to run as Puppet master server and all app servers are already configured to work as the puppet agent nodes, we need to create required manifests on the Puppet master server so that the same can be applied on all Puppet agent nodes.  
Please find more details about the task below.  
- Create a Puppet programming file games.pp under /etc/puppetlabs/code/environments/production/manifests directory on master node i.e Jump Server and using puppet package resource perform the tasks given below.
- Install package httpd through Puppet package resource only on App server 3 i.e. puppet agent node 3.  

Notes: 
- Please make sure to run the puppet agent test using sudo on agent nodes, otherwise you can face certificate issues. In that case you will have to clean the certificates first and then you will be able to run the puppet agent test.  
- Before clicking on the Check button please make sure to verify puppet server and puppet agent services are up and running on the respective servers, also please make sure to run puppet agent test to apply/test the changes manually first.
- Please note that once lab is loaded, the puppet server service should start automatically on puppet master server, however it can take upto 2-3 minutes to start.  



## 1. Create puppet file
`cd /etc/puppetlabs/code/environments/production/manifests/`  
`sudo vi games.pp`

```yaml
class apache_installer {
    package {'httpd':
        ensure => installed
    }
}
node 'stapp03.stratos.xfusioncorp.com' {
  include apache_installer
}
```


## 2. Validate the puppet file
`puppet parser validate games.pp`


## 3. Login on App server and run Puppet agent
`ssh banner@stapp03`  
`sudo -i`  
`puppet agent -tv`

```console
Info: Using configured environment 'production'
Info: Retrieving pluginfacts
Info: Retrieving plugin
Info: Retrieving locales
Info: Caching catalog for stapp03.stratos.xfusioncorp.com
Info: Applying configuration version '1655974296'
Notice: /Stage[main]/Nginx_installer/Package[httpd]/ensure: created
Notice: Applied catalog in 22.19 seconds
```


## 4. Validate the task
`rpm -qa | grep httpd`

```console
httpd-2.4.6-97.el7.centos.5.x86_64
httpd-tools-2.4.6-97.el7.centos.5.x86_64
```


---



```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:62b2f73f668fa542fb69f91c
```

---

```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:637bd9c6d47732a566434ec4
```
