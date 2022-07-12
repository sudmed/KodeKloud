# Ansible Lineinfile Module

The Nautilus DevOps team want to install and set up a simple httpd web server on all app servers in Stratos DC. They also want to deploy a sample web page using Ansible. Therefore, write the required playbook to complete this task as per details mentioned below.  
We already have an inventory file under /home/thor/ansible directory on jump host. Write a playbook playbook.yml under /home/thor/ansible directory on jump host itself. Using the playbook perform below given tasks:  
Install httpd web server on all app servers, and make sure its service is up and running.  
Create a file /var/www/html/index.html with content:  
This is a Nautilus sample file, created using Ansible!  
Using lineinfile Ansible module add some more content in /var/www/html/index.html file. Below is the content:  
Welcome to xFusionCorp Industries!  
Also make sure this new line is added at the top of the file.  
The /var/www/html/index.html file's user and group owner should be apache on all app servers.  
The /var/www/html/index.html file's permissions should be 0644 on all app servers.  
Note: Validation will try to run the playbook using command ansible-playbook -i inventory playbook.yml so please make sure the playbook works this way without passing any extra arguments.  



## 1. Create playbook files
`cd /home/thor/ansible && ll`
```console
total 8
-rw-r--r-- 1 thor thor  36 Jul  8 09:49 ansible.cfg
-rw-r--r-- 1 thor thor 237 Jul  8 09:49 inventory
```

`cat inventory `
```console
stapp01 ansible_host=172.16.238.10 ansible_ssh_pass=Ir0nM@n ansible_user=tony
stapp02 ansible_host=172.16.238.11 ansible_ssh_pass=Am3ric@ ansible_user=steve
stapp03 ansible_host=172.16.238.12 ansible_ssh_pass=BigGr33n ansible_user=banner
```

`cat ansible.cfg `
```console
[defaults]
host_key_checking = False
```

`vi playbook.yml`
```yaml
---
- name: Install httpd and add index.html
  hosts: stapp01, stapp02, stapp03
  become: yes
  tasks:
    - name: Install httpd
      package:
        name: httpd
        state: present
    - name: Start service httpd
      service:
        name: httpd
        state: started
    - name: Add index.html
      copy:
        dest: /var/www/html/index.html
        content: This is a Nautilus sample file, created using Ansible!
        mode: "0644"
        owner: apache
        group: apache
    - name: Update content in index.html
      lineinfile:
        path: /var/www/html/index.html
        insertbefore: BOF
        line: Welcome to xFusionCorp Industries!
```



## 2. Execute playbook
`ansible-playbook -i inventory playbook.yml`
```console
PLAY [Install httpd and add index.html] *****************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************
ok: [stapp03]
ok: [stapp02]
ok: [stapp01]

TASK [Install httpd] ************************************************************************************************************************************************************************
changed: [stapp02]
changed: [stapp01]
changed: [stapp03]

TASK [Start service httpd] ******************************************************************************************************************************************************************
changed: [stapp01]
changed: [stapp02]
changed: [stapp03]

TASK [Add index.html] ***********************************************************************************************************************************************************************
changed: [stapp01]
changed: [stapp03]
changed: [stapp02]

TASK [Update content in index.html] *********************************************************************************************************************************************************
changed: [stapp03]
changed: [stapp02]
changed: [stapp01]

PLAY RECAP **********************************************************************************************************************************************************************************
stapp01                    : ok=5    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
stapp02                    : ok=5    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
stapp03                    : ok=5    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```


## 3. Validate the task by curl on app server and check
`ansible all -a "ls -ltr /var/www/html/index.html" -i inventory`
```console
stapp03 | CHANGED | rc=0 >>
-rw-r--r-- 1 apache apache 89 Jul  8 09:55 /var/www/html/index.html
stapp01 | CHANGED | rc=0 >>
-rw-r--r-- 1 apache apache 89 Jul  8 09:55 /var/www/html/index.html
stapp02 | CHANGED | rc=0 >>
-rw-r--r-- 1 apache apache 89 Jul  8 09:55 /var/www/html/index.html
```

`curl http://stapp01`
```console
Welcome to xFusionCorp Industries!
This is a Nautilus sample file, created using Ansible!
```

`curl http://stapp02`
```console
Welcome to xFusionCorp Industries!
This is a Nautilus sample file, created using Ansible!
```

`curl http://stapp03`
```console
Welcome to xFusionCorp Industries!
This is a Nautilus sample file, created using Ansible!
```


```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:62c6d9bf76b0872ac6fcc20d
```
