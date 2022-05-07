# Ansible Setup Httpd and PHP

# 1. Go through the folder mentioned in task and create inventory & playbook files
cd  ~/playbooks/ 

ll
-rw-r--r-- 1 thor thor   36 Jun 17 14:28 ansible.cfg
-rw-r--r-- 1 thor thor  237 Jun 17 14:28 inventory
drwxr-xr-x 2 thor thor 4096 Jun 17 14:29 templates

# 2. Create a playbook file httpd.yml
# https://github.com/sudmed/KodeKloud/blob/8b451e29b6b614e9ff6936497cbe3f88ca82e218/Ansible%20Setup%20Httpd%20and%20PHP/httpd.yml

# 3. Post file saved , run below command to execute the playbook
ansible-playbook  -i inventory httpd.yml

PLAY [Setup Httpd and PHP] ******************************************************************
TASK [Gathering Facts] **********************************************************************
ok: [stapp02]
TASK [Install latest version of httpd and php] **********************************************
changed: [stapp02]
TASK [Replace default DocumentRoot in httpd.conf] *******************************************
changed: [stapp02]
TASK [Create the new DocumentRoot directory if it does not exist] ***************************
changed: [stapp02]
TASK [Use Jinja2 template to generate phpinfo.php] ******************************************
changed: [stapp02]
TASK [Start and enable service httpd] *******************************************************
changed: [stapp02]
PLAY RECAP **********************************************************************************
stapp02: ok=6    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  

# 4. validate the task by login on app server and check
[steve@stapp02 ~]$ rpm -qa | grep httpd
httpd-tools-2.4.6-97.el7.centos.x86_64
httpd-2.4.6-97.el7.centos.x86_64

[steve@stapp02 ~]$ rpm -qa | grep php
php-cli-5.4.16-48.el7.x86_64
php-common-5.4.16-48.el7.x86_64
php-5.4.16-48.el7.x86_64
