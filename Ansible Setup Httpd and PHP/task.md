# Ansible Setup Httpd and PHP

Nautilus Application development team wants to test the Apache and PHP setup on one of the app servers in Stratos Datacenter. They want the DevOps team to prepare an Ansible playbook to accomplish this task. Below you can find more details about the task.  
There is an inventory file ~/playbooks/inventory on jump host.  
Create a playbook ~/playbooks/httpd.yml on jump host and perform the following tasks on App Server 3.  
a. Install httpd and php packages (whatever default version is available in yum repo).  
b. Change default document root of Apache to /var/www/html/myroot in default Apache config /etc/httpd/conf/httpd.conf. Make sure /var/www/html/myroot path exists (if not please create the same).  
c. There is a template ~/playbooks/templates/phpinfo.php.j2 on jump host. Copy this template to the Apache document root you created as phpinfo.php file and make sure user owner and the group owner for this file is apache user.  
d. Start and enable httpd service.  
Note: Validation will try to run the playbook using command ansible-playbook -i inventory httpd.yml, so please make sure the playbook works this way without passing any extra arguments.  



## 1. Create playbook file
`cd  ~/playbooks/`  
`ll`
```console
total 12
-rw-r--r-- 1 thor thor   36 Jul 12 09:11 ansible.cfg
-rw-r--r-- 1 thor thor  237 Jul 12 09:11 inventory
drwxr-xr-x 2 thor thor 4096 Jul 12 09:11 templates
```

`cat ansible.cfg`  
```console
[defaults]
host_key_checking = False
```

`cat inventory`
```console
stapp01 ansible_host=172.16.238.10 ansible_ssh_pass=Ir0nM@n ansible_user=tony
stapp02 ansible_host=172.16.238.11 ansible_ssh_pass=Am3ric@ ansible_user=steve
stapp03 ansible_host=172.16.238.12 ansible_ssh_pass=BigGr33n ansible_user=banner
```

`cat templates/phpinfo.php.j2`
```console
<?php
phpinfo();
?>
```

`vi httpd.yml`
```yaml
- name: Install Httpd & PHP
  hosts: stapp03
  become: yes
  tasks:

    - name: Install latest versions of httpd and php
      package:
        name:
          - httpd
          - php
        state: latest

    - name: Replace default DocumentRoot in httpd.conf
      replace:
        path: /etc/httpd/conf/httpd.conf
        regexp: DocumentRoot \"\/var\/www\/html\"
        replace: DocumentRoot "/var/www/html/myroot"

    - name: Create new directory if it does not exist
      file:
        path: /var/www/html/myroot
        state: directory
        owner: apache
        group: apache

    - name: Use j2-template to generate phpinfo.php
      template:
        src: /home/thor/playbooks/templates/phpinfo.php.j2
        dest: /var/www/html/myroot/phpinfo.php
        owner: apache
        group: apache

    - name: Start and enable service httpd
      service:
        name: httpd
        state: started
        enabled: yes 
...
```


## 2. Execute the playbook
`ansible-playbook -i inventory httpd.yml`
```console
ansible-playbook -i inventory httpd.yml

PLAY [Install Httpd & PHP] ******************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************
ok: [stapp03]

TASK [Install latest versions of httpd and php] *********************************************************************************************************************************************
changed: [stapp03]

TASK [Replace default DocumentRoot in httpd.conf] *******************************************************************************************************************************************
changed: [stapp03]

TASK [Create new directory if it does not exist] ********************************************************************************************************************************************
changed: [stapp03]

TASK [Use j2-template to generate phpinfo.php] **********************************************************************************************************************************************
changed: [stapp03]

TASK [Start and enable service httpd] *******************************************************************************************************************************************************
changed: [stapp03]

PLAY RECAP **********************************************************************************************************************************************************************************
stapp03                    : ok=6    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
```


## 3. Validate the task on stapp03
`rpm -qa | grep httpd`
```console
httpd-tools-2.4.6-97.el7.centos.5.x86_64
httpd-2.4.6-97.el7.centos.5.x86_64
```

`rpm -qa | grep php`
```console
php-cli-5.4.16-48.el7.x86_64
php-common-5.4.16-48.el7.x86_64
php-5.4.16-48.el7.x86_64
```


```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:62cd2afd5f7a921a1af31137
```
