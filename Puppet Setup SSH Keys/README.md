# Puppet Setup SSH Keys

The Puppet master and Puppet agent nodes have been set up by the Nautilus DevOps team to perform some testing. In Stratos DC all app servers have been configured as Puppet agent nodes. They want to setup a password less SSH connection between Puppet master and Puppet agent nodes and this task needs to be done using Puppet itself. Below are details about the task:
Create a Puppet programming file demo.pp under /etc/puppetlabs/code/environments/production/manifests directory on the Puppet master node i.e on Jump Server. Define a class ssh_node1 for agent node 1 i.e App Server 1, ssh_node2 for agent node 2 i.e App Server 2, ssh_node3 for agent node3 i.e App Server 3. You will need to generate a new ssh key for thor user on Jump Server, that needs to be added on all App Servers.
Configure a password less SSH connection from puppet master i.e jump host to all App Servers. However, please make sure the key is added to the authorized_keys file of each app's sudo user (i.e tony for App Server 1).
Notes: :- Before clicking on the Check button please make sure to verify puppet server and puppet agent services are up and running on the respective servers, also please make sure to run puppet agent test to apply/test the changes manually first.
:- Please note that once lab is loaded, the puppet server service should start automatically on puppet master server, however it can take upto 2-3 minutes to start.



## 1. Copy the public key
`ssh-keygen`  
```console
Generating public/private rsa key pair.
Enter file in which to save the key (/home/thor/.ssh/id_rsa): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/thor/.ssh/id_rsa.
Your public key has been saved in /home/thor/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:GP6AKsdt45ZYhfxdyum6EH/2DnUKS5aAK5YWcR4E7XI thor@jump_host.stratos.xfusioncorp.com
The key's randomart image is:
+---[RSA 2048]----+
|  o++            |
|   +.o           |
|  .oo.o          |
|  .oE+.+ ..      |
|  =o+o+oS+. .    |
| + +.o.==+ o     |
|. +o=...* .      |
| o.ooo o.o       |
|   .. oo .o      |
+----[SHA256]-----+
```

`cat /home/thor/.ssh/id_rsa.pub`  
```console
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCv9SvO48stgnPikHDVnULiwKVBG2fN7YPPJ8wTm/g2Kha+7ZS7lJ/8vgJL7YWkiUlx+f5PfZ8ftsMfkrf/lgxSK/Yu9MdXqcO7IN0P7QvKl1aYEsgwhRwGoXMSDaETH7HuhC3Nng6UiyG5M9/QibOvmQ3nPXLcfOcVB0fuZDTA3tBGYUZ9GbhAHHzwnGIHfayUHQxhrGkjJHhC7kg+uY+li4ABa2grKLTDHKXFbnptbX9QZCtJRg7HYIrLWnMLqZMi24caWn5dPo9+3MKRR2PZfjyHVHxBA0EmxRTkmwAXwq6G/h7/P15uFXf+XQQuelW1JOflmLt5v89Fk/wQs6xP thor@jump_host.stratos.xfusioncorp.com
```


## 2. Create puppet file
`cd /etc/puppetlabs/code/environments/production/manifests`  
`vi demo.pp`  
```console
$public_key =  'AAAAB3NzaC1yc2EAAAADAQABAAABAQCv9SvO48stgnPikHDVnULiwKVBG2fN7YPPJ8wTm/g2Kha+7ZS7lJ/8vgJL7YWkiUlx+f5PfZ8ftsMfkrf/lgxSK/Yu9MdXqcO7IN0P7QvKl1aYEsgwhRwGoXMSDaETH7HuhC3Nng6UiyG5M9/QibOvmQ3nPXLcfOcVB0fuZDTA3tBGYUZ9GbhAHHzwnGIHfayUHQxhrGkjJHhC7kg+uY+li4ABa2grKLTDHKXFbnptbX9QZCtJRg7HYIrLWnMLqZMi24caWn5dPo9+3MKRR2PZfjyHVHxBA0EmxRTkmwAXwq6G/h7/P15uFXf+XQQuelW1JOflmLt5v89Fk/wQs6xP'

class ssh_node1 {
   ssh_authorized_key { 'tony@stapp01':
     ensure => present,
     user   => 'tony',
     type   => 'ssh-rsa',
     key    => $public_key,
   }
}

class ssh_node2 {
   ssh_authorized_key { 'steve@stapp02':
     ensure => present,
     user   => 'steve',
     type   => 'ssh-rsa',
     key    => $public_key,
   }
}

class ssh_node3 {
   ssh_authorized_key { 'banner@stapp03':
     ensure => present,
     user   => 'banner',
     type   => 'ssh-rsa',
     key    => $public_key,
   }
}

node stapp01.stratos.xfusioncorp.com {
   include ssh_node1
}

node stapp02.stratos.xfusioncorp.com {
   include ssh_node2
}

node stapp03.stratos.xfusioncorp.com {
   include ssh_node3
}
```


## 3. Validate the puppet file
`puppet parser validate demo.pp`  


## 4. SSH to every app server and run Puppet agent
`ssh tony@stapp01`  
`sudo -i`  
`puppet agent -tv`  
```console
Info: Creating a new RSA SSL key for stapp01.stratos.xfusioncorp.com
Info: csr_attributes file loading from /etc/puppetlabs/puppet/csr_attributes.yaml
Info: Creating a new SSL certificate request for stapp01.stratos.xfusioncorp.com
Info: Certificate Request fingerprint (SHA256): E1:95:F4:DE:38:4E:86:EB:F8:61:E0:14:54:11:31:74:6E:64:E7:0B:67:A8:9F:1B:02:5F:62:D5:3F:2C:0E:56
Info: Downloaded certificate for stapp01.stratos.xfusioncorp.com from https://puppet:8140/puppet-ca/v1
Info: Using configured environment 'production'
Info: Retrieving pluginfacts
Info: Retrieving plugin
Info: Retrieving locales
Info: Caching catalog for stapp01.stratos.xfusioncorp.com
Info: Applying configuration version '1662240196'
Notice: /Stage[main]/Ssh_node1/Ssh_authorized_key[tony@stapp01]/ensure: created
Info: Creating state file /opt/puppetlabs/puppet/cache/state/state.yaml
Notice: Applied catalog in 0.01 seconds
```

`ssh steve@stapp02`  
`sudo -i`  
`puppet agent -tv`  
```console
Info: Using configured environment 'production'
Info: Retrieving pluginfacts
Info: Retrieving plugin
Info: Retrieving locales
Info: Caching catalog for stapp02.stratos.xfusioncorp.com
Info: Applying configuration version '1662240319'
Notice: Applied catalog in 0.08 seconds
```

`ssh banner@stapp03`  
`sudo -i`  
`puppet agent -tv`  
```console
Info: Using configured environment 'production'
Info: Retrieving pluginfacts
Info: Retrieving plugin
Info: Retrieving locales
Info: Caching catalog for stapp03.stratos.xfusioncorp.com
Info: Applying configuration version '1662240376'
Notice: Applied catalog in 0.01 seconds
```


## 5. Validate the task
`ssh tony@stapp01`  
```console
Last login: Sat Sep  3 21:22:54 2022 from jump_host.stratos.xfusioncorp.com
[tony@stapp01 ~]$ exit
logout
Connection to stapp01 closed.
```

`ssh steve@stapp02`  
```console
Last login: Sat Sep  3 21:24:39 2022 from jump_host.stratos.xfusioncorp.com
[steve@stapp02 ~]$ exit
logout
Connection to stapp02 closed.
```

`ssh banner@stapp03`  
```console
Last login: Sat Sep  3 21:25:42 2022 from jump_host.stratos.xfusioncorp.com
[banner@stapp03 ~]$ exit
logout
Connection to stapp03 closed.
```

---

```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:631261cc03160b1cf91ea141
```
