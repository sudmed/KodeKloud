# Puppet Multi-Packages Installation
Some new changes need to be made on some of the app servers in Stratos Datacenter. There are some packages that need to be installed on the app server 2. We want to install these packages using puppet only.  
Puppet master is already installed on Jump Server.  
Create a puppet programming file blog.pp under /etc/puppetlabs/code/environments/production/manifests on master node i.e on Jump Server and perform below mentioned tasks using the same.  
Define a class multi_package_node for agent node 2 i.e app server 2. Install vim-enhanced and zip packages on the agent node 2.  
Notes: :- Please make sure to run the puppet agent test using sudo on agent nodes, otherwise you can face certificate issues. In that case you will have to clean the certificates first and then you will be able to run the puppet agent test.  
:- Before clicking on the Check button please make sure to verify puppet server and puppet agent services are up and running on the respective servers, also please make sure to run puppet agent test to apply/test the changes manually first.  
:- Please note that once lab is loaded, the puppet server service should start automatically on puppet master server, however it can take upto 2-3 minutes to start.  

## 1. Create puppet files
`sudo -i`  
`cd /etc/puppetlabs/code/environments/production/manifests/`

`vi blog.pp`
```yaml
class multi_package_node {

  package { 'vim-enhanced': ensure => 'installed' }
  package { 'zip': ensure => 'installed' }
}
node 'stapp02.stratos.xfusioncorp.com' {
  include multi_package_node
}
```

`puppet parser validate blog.pp`  


## 2. Login on stapp02
`ssh steve@stapp02   #Am3ric@`  
`sudo -i`  


## 3. Run Puppet agent
`puppet agent -tv`
```comsole
Notice: Run of Puppet configuration client already in progress; skipping  (/opt/puppetlabs/puppet/cache/state/agent_catalog_run.lock exists)
```

## 4. Validate the task
`rpm -qa |grep -e vim-enhanced -e zip`  
```console
bzip2-libs-1.0.6-13.el7.x86_64
zip-3.0-11.el7.x86_64
gzip-1.5-10.el7.x86_64
vim-enhanced-7.4.629-8.el7_9.x86_64
```


```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:62c0267b7eb6566d9ba5b0cd
```
