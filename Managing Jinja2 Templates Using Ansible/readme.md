# Managing Jinja2 Templates Using Ansible

One of the Nautilus DevOps team members is working on to develop a role for httpd installation and configuration. Work is almost completed, however there is a requirement to add a jinja2 template for index.html file. Additionally, the relevant task needs to be added inside the role.  
The inventory file ~/ansible/inventory is already present on jump host that can be used. Complete the task as per details mentioned below:  
a. Update ~/ansible/playbook.yml playbook to run the httpd role on App Server 3.  
b. Create a jinja2 template index.html.j2 under /home/thor/ansible/role/httpd/templates/ directory and add a line This file was created using Ansible on <respective server> (for example This file was created using Ansible on stapp01 in case of App Server 1).  
Also please make sure not to hard code the server name inside the template. Instead, use inventory_hostname variable to fetch the correct value.  
c. Add a task inside /home/thor/ansible/role/httpd/tasks/main.yml to copy this template on App Server 3 under /var/www/html/index.html. Also make sure that /var/www/html/index.html file's permissions are 0777.  
d. The user/group owner of /var/www/html/index.html file must be respective sudo user of the server (for example tony in case of stapp01).  
Note: Validation will try to run the playbook using command ansible-playbook -i inventory playbook.yml so please make sure the playbook works this way without passing any extra arguments.  


## 1. Check inventory file
`cat ~/ansible/inventory`  
```shell
stapp01 ansible_host=172.16.238.10 ansible_user=tony ansible_ssh_pass=Ir0nM@n
stapp02 ansible_host=172.16.238.11 ansible_user=steve ansible_ssh_pass=Am3ric@
stapp03 ansible_host=172.16.238.12 ansible_user=banner ansible_ssh_pass=BigGr33n
```

## 2. Fix playbook.yml  
`cat ~/ansible/playbook.yml`  
```yaml
---
- hosts: 
  become: yes
  become_user: root
  roles:
    - role/httpd
```

`vi ~/ansible/playbook.yml`  
```yaml
---
- hosts: stapp03
  become: yes
  become_user: root
  roles:
    - role/httpd
```


## 3. Create jinja2 template
`vi /home/thor/ansible/role/httpd/templates/index.html.j2`  
```console
This file was created using Ansible on {{ inventory_hostname }}
```

## 4. Add task in an ansible role
`cat /home/thor/ansible/role/httpd/tasks/main.yml`  
```yaml
---
# tasks file for role/test

- name: install the latest version of HTTPD
  yum:
    name: httpd
    state: latest

- name: Start service httpd
  service:
    name: httpd
    state: started
```

`vi /home/thor/ansible/role/httpd/tasks/main.yml`  
```yaml
---
# tasks file for role/test

- name: install the latest version of HTTPD
  yum:
    name: httpd
    state: latest

- name: Start service httpd
  service:
    name: httpd
    state: started

- name: Copy template
  template:
    src: index.html.j2
    dest: /var/www/html/index.html
    mode: '0777'
    owner: {{ ansible_user }}
    group: {{ ansible_user }}
```

## 5. Run ansible playbook
`cd ~/ansible`  
`ansible-playbook -i inventory playbook.yml`  
```shell
PLAY [stapp03] ******************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************
ok: [stapp03]

TASK [role/httpd : install the latest version of HTTPD] *************************************************************************************************************************************
changed: [stapp03]

TASK [role/httpd : Start service httpd] *****************************************************************************************************************************************************
changed: [stapp03]

TASK [role/httpd : Copy template] ***********************************************************************************************************************************************************
changed: [stapp03]

PLAY RECAP **********************************************************************************************************************************************************************************
stapp03                    : ok=4    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```


## 6. Validate the task
`ssh banner@stapp03`  
```shell
The authenticity of host 'stapp03 (172.16.238.12)' can't be established.
ECDSA key fingerprint is SHA256:vVFiOjQ6xidNyrusBsbP9YdkxpSin4C3FgZArPegfq4.
ECDSA key fingerprint is MD5:dc:8f:0f:e7:f5:2e:12:36:73:09:69:cd:07:9b:92:a3.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'stapp03' (ECDSA) to the list of known hosts.
banner@stapp03's password: 
Last login: Fri Aug  5 21:00:12 2022 from jump_host.devops-ansible-jinja2-v2_app_net
```

`cat /var/www/html/index.html`  
```shell
This file was created using Ansible on stapp03
```

`ll /var/www/html/index.html`  
```shell
-rwxrwxrwx 1 banner banner 48 Aug  5 20:59 /var/www/html/index.html
```

## 6*. Validate the task with ad-hoc command `ansible -a` which executes just through the ssh
`ansible -a "cat /var/www/html/index.html" -i inventory stapp03`  
  
---

```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:62ed3f783cf167f52645d41d
```
