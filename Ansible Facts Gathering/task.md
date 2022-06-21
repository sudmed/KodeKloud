# Ansible Facts Gathering

The Nautilus DevOps team is trying to setup a simple Apache web server on all app servers in Stratos DC using Ansible.  
They also want to create a sample html page for now with some app specific data on it. Below you can find more details about the task.  
You will find a valid inventory file /home/thor/playbooks/inventory on jump host (which we are using as an Ansible controller).  
Create a playbook index.yml under /home/thor/playbooks directory on jump host.  
Using blockinfile Ansible module create a file facts.txt under /root directory on all app servers and add the following given block in it.  
You will need to enable facts gathering for this task: Ansible managed node IP is <default ipv4 address>  
(You can obtain default ipv4 address from Ansible's gathered facts by using the correct Ansible variable while taking into account Jinja2 syntax)  
Install httpd server on all apps. After that make a copy of facts.txt file as index.html under /var/www/html directory.  
Make sure to start httpd service after that.  
Note: Do not create a separate role for this task, just add all of the changes in index.yml playbook.


## 1. Go to the folder and create inventory & playbook files
`cd /home/thor/playbooks/`  

`ll`
```console
total 8
-rw-r--r-- 1 thor thor  36 Jun 21 10:08 ansible.cfg
-rw-r--r-- 1 thor thor 237 Jun 21 10:08 inventory
```

`vi index.yml`

```yaml
---
- hosts: stapp01, stapp02, stapp03
  gather_facts: true
  become: yes
  tasks:
  - name: create file using blockinfile
    blockinfile:
      create: yes
      path: /root/facts.txt
      block: |
        Ansible managed node IP is {{ ansible_default_ipv4.address }}
  
  - name: Install apache package
    yum:
      name: httpd
      state: present

  - name: file copy
    shell: cp /root/facts.txt /var/www/html/index.html

  - name: check if httpd is running
    service: 
      name: httpd
      state: started
```


## 2. Execute the playbook
`ansible-playbook -i inventory index.yml`

```console
PLAY [stapp01, stapp02, stapp03] ************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************
ok: [stapp01]
ok: [stapp02]
ok: [stapp03]

TASK [create file using blockinfile] ********************************************************************************************************************************************************
ok: [stapp03]
ok: [stapp02]
ok: [stapp01]

TASK [Install apache package] ***************************************************************************************************************************************************************
ok: [stapp03]
ok: [stapp01]
ok: [stapp02]

TASK [file copy] ****************************************************************************************************************************************************************************
changed: [stapp01]
changed: [stapp03]
changed: [stapp02]

TASK [check if httpd is running] ************************************************************************************************************************************************************
changed: [stapp02]
changed: [stapp03]
changed: [stapp01]

PLAY RECAP **********************************************************************************************************************************************************************************
stapp01                    : ok=5    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
stapp02                    : ok=5    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
stapp03                    : ok=5    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```


## 3. Validate the task by curl to all app server and check

`curl http://stapp01`
```console
# BEGIN ANSIBLE MANAGED BLOCK
Ansible managed node IP is 172.16.238.10
# END ANSIBLE MANAGED BLOCK
```

`curl http://stapp02`
```console
# BEGIN ANSIBLE MANAGED BLOCK
Ansible managed node IP is 172.16.238.11
# END ANSIBLE MANAGED BLOCK
```

`curl http://stapp03`
```console
# BEGIN ANSIBLE MANAGED BLOCK
Ansible managed node IP is 172.16.238.12
# END ANSIBLE MANAGED BLOCK
```
  
  
  
```console
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:62aeae3004320b3a20c8c1c2
```
