# Puppet Setup Database

The Nautilus DevOps team had a meeting with development team last week to discuss about some new requirements for an application deployment. Team is working on to setup a mariadb database server on Nautilus DB Server in Stratos Datacenter. They want to setup the same using Puppet. Below you can find more details about the requirements:  
Create a puppet programming file media.pp under /etc/puppetlabs/code/environments/production/manifests directory on puppet master node i.e on Jump Server. Define a class mysql_database in puppet programming code and perform below mentioned tasks:  
Install package mariadb-server (whichever version is available by default in yum repo) on puppet agent node i.e on DB Server also start its service.  
Create a database kodekloud_db3 , a database userkodekloud_top and set password8FmzjvFU6S for this new user also remember host should be localhost. Finally grant some usual permissions like select, update (or full) ect to this newly created user on newly created database.  
Notes: :- Please make sure to run the puppet agent test using sudo on agent nodes, otherwise you can face certificate issues. In that case you will have to clean the certificates first and then you will be able to run the puppet agent test.  
:- Before clicking on the Check button please make sure to verify puppet server and puppet agent services are up and running on the respective servers, also please make sure to run puppet agent test to apply/test the changes manually first.  
:- Please note that once lab is loaded, the puppet server service should start automatically on puppet master server, however it can take upto 2-3 minutes to start.  


## 1. Create puppet file
`cd /etc/puppetlabs/code/environments/production/manifests`
   
`vi media.pp`
```yaml
node 'stdb01.stratos.xfusioncorp.com' {
    include mysql_database
}
class mysql_database {
    package {'mariadb-server':
      ensure => installed,
    }

    service {'mariadb':
        ensure    => running,
        enable    => true,
    }

    mysql::db { 'kodekloud_db3':
      user     => 'kodekloud_top',
      password => '8FmzjvFU6S',
      host     => 'localhost',
      grant    => ['ALL'],
    }
}
```

`puppet parser validate media.pp`


## 2. Validate the task
## 2.1. Login on agent node (database server)
`ssh peter@stdb01`  
`sudo -i`


## 2.2. Run Puppet agent
`puppet agent -tv`
```console
Notice: Run of Puppet configuration client already in progress; skipping  (/opt/puppetlabs/puppet/cache/state/agent_catalog_run.lock exists)
```


## 2.3. Check the maridb status
`systemctl status mariadb`
```console
● mariadb.service - MariaDB database server
   Loaded: loaded (/usr/lib/systemd/system/mariadb.service; disabled; vendor preset: disabled)
   Active: active (running) since Wed 2022-07-20 20:18:06 UTC; 36s ago
 Main PID: 1522 (mysqld_safe)
   CGroup: /docker/58f3b8eef1b54fbb4c57336105c000742bab37b0da4f95bc47e5eb8a4841103f/system.slice/mariadb.service
           ├─1522 /bin/sh /usr/bin/mysqld_safe --basedir=/usr
           └─1686 /usr/libexec/mysqld --basedir=/usr --datadir=/var/lib/mysql --plugin-dir=/usr/lib64/mysql/plugin --log-error=/var/log/mariadb/mariadb.log --pid-file=/var/run/mariadb/ma...

Jul 20 20:18:04 stdb01.stratos.xfusioncorp.com systemd[1522]: Executing: /usr/bin/mysqld_safe --basedir=/usr
Jul 20 20:18:04 stdb01.stratos.xfusioncorp.com systemd[1523]: Executing: /usr/libexec/mariadb-wait-ready 1522
Jul 20 20:18:05 stdb01.stratos.xfusioncorp.com mysqld_safe[1522]: 220720 20:18:05 mysqld_safe Logging to '/var/log/mariadb/mariadb.log'.
Jul 20 20:18:05 stdb01.stratos.xfusioncorp.com mysqld_safe[1522]: 220720 20:18:05 mysqld_safe Starting mysqld daemon with databases from /var/lib/mysql
Jul 20 20:18:06 stdb01.stratos.xfusioncorp.com systemd[1]: Child 1523 belongs to mariadb.service
Jul 20 20:18:06 stdb01.stratos.xfusioncorp.com systemd[1]: mariadb.service: control process exited, code=exited status=0
Jul 20 20:18:06 stdb01.stratos.xfusioncorp.com systemd[1]: mariadb.service got final SIGCHLD for state start-post
Jul 20 20:18:06 stdb01.stratos.xfusioncorp.com systemd[1]: mariadb.service changed start-post -> running
Jul 20 20:18:06 stdb01.stratos.xfusioncorp.com systemd[1]: Job mariadb.service/start finished, result=done
Jul 20 20:18:06 stdb01.stratos.xfusioncorp.com systemd[1]: Started MariaDB database server.
```


## 2.4. Login to maridb
`mysql -u kodekloud_top -p kodekloud_db3 -h localhost`
```console
Enter password: 
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 29
Server version: 5.5.68-MariaDB MariaDB Server

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [kodekloud_db3]> quit
Bye
```


```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:62d7fd85f4f3fc421fde86c3
```
