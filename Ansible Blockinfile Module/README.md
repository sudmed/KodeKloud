# Ansible Blockinfile Module

The Nautilus DevOps team wants to install and set up a simple httpd web server on all app servers in Stratos DC. Additionally, they want to deploy a sample web page for now using Ansible only. Therefore, write the required playbook to complete this task. Find more details about the task below.  
We already have an inventory file under /home/thor/ansible directory on jump host. Create a playbook.yml under /home/thor/ansible directory on jump host itself.  
Using the playbook, install httpd web server on all app servers. Additionally, make sure its service should up and running.  
Using blockinfile Ansible module add some content in /var/www/html/index.html file. Below is the content:  
- Welcome to XfusionCorp!
- This is Nautilus sample file, created using Ansible!

Please do not modify this file manually! The /var/www/html/index.html file's user and group owner should be apache on all app servers.  
The /var/www/html/index.html file's permissions should be 0744 on all app servers.  
Note:
- i. Validation will try to run the playbook using command ansible-playbook -i inventory playbook.yml so please make sure the playbook works this way without passing any extra arguments.
- ii. Do not use any custom or empty marker for blockinfile module.  


## 1. Reconnaissance on the server
`cd /home/thor/ansible/`  
`ll`  
```console
total 8
-rw-r--r-- 1 thor thor  36 Sep 18 20:09 ansible.cfg
-rw-r--r-- 1 thor thor 237 Sep 18 20:09 inventory
```


## 2. Create playbook file
`vi playbook.yml`  

```yaml
- hosts: all
  gather_facts: false
  become: yes
  tasks:
  - name: Install httpd
    yum:
      name: httpd
      state: present
    
  - name: Start service
    service:
      name: httpd
      enabled: yes
      state: started
      
  - name: Create directory
    file:
      path: /var/www/html
      state: directory
      owner: apache
      group: apache

  - name: Create index.html
    file: 
      path: /var/www/html/index.html
      state: touch
      owner: apache
      group: apache
      mode: '0744'

  - name: blockinfile part
    blockinfile:
      path: /var/www/html/index.html
      block: |
Welcome to XfusionCorp!
This is Nautilus sample file, created using Ansible!
Please do not modify this file manually!
```

## 3. Run playbook file
`ansible-playbook -i inventory playbook.yml`  
```ansible
ansible-playbook -i inventory playbook.yml

PLAY [all] **********************************************************************************************************************************************************************************

TASK [Install httpd] ************************************************************************************************************************************************************************
changed: [stapp03]
changed: [stapp02]
changed: [stapp01]

TASK [Start service] ************************************************************************************************************************************************************************
changed: [stapp03]
changed: [stapp02]
changed: [stapp01]

TASK [Create directory] *********************************************************************************************************************************************************************
changed: [stapp01]
changed: [stapp03]
changed: [stapp02]

TASK [Create index.html] ********************************************************************************************************************************************************************
changed: [stapp01]
changed: [stapp02]
changed: [stapp03]

TASK [blockinfile part] *********************************************************************************************************************************************************************
changed: [stapp03]
changed: [stapp01]
changed: [stapp02]

PLAY RECAP **********************************************************************************************************************************************************************************
stapp01                    : ok=5    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
stapp02                    : ok=5    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
stapp03                    : ok=5    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```


## 4. Validate the task
`ansible all -a 'ls -l /var/www/html/' -i inventory`  
```ansible
stapp02 | CHANGED | rc=0 >>
total 4
-rwxr--r-- 1 apache apache 175 Sep 18 20:16 index.html
stapp03 | CHANGED | rc=0 >>
total 4
-rwxr--r-- 1 apache apache 175 Sep 18 20:16 index.html
stapp01 | CHANGED | rc=0 >>
total 4
-rwxr--r-- 1 apache apache 175 Sep 18 20:16 index.html
```

`curl http://stapp01`  
```console
# BEGIN ANSIBLE MANAGED BLOCK
Welcome to XfusionCorp!
This is Nautilus sample file, created using Ansible!
Please do not modify this file manually!
# END ANSIBLE MANAGED BLOC
```

`curl http://stapp02`  
```console
# BEGIN ANSIBLE MANAGED BLOCK
Welcome to XfusionCorp!
This is Nautilus sample file, created using Ansible!
Please do not modify this file manually!
# END ANSIBLE MANAGED BLOCK
```

```console
curl http://stapp03
# BEGIN ANSIBLE MANAGED BLOCK
Welcome to XfusionCorp!
This is Nautilus sample file, created using Ansible!
Please do not modify this file manually!
# END ANSIBLE MANAGED BLOCK
```

---

```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:63276b7a5d1cce8de9ea1721
```
