# Ansible Copy Module

There is data on jump host that needs to be copied on all application servers in Stratos DC. Nautilus DevOps team want to perform this task using Ansible.  
Perform the task as per details mentioned below:  
a. On jump host create an inventory file /home/thor/ansible/inventory and add all application servers as managed nodes.  
b. On jump host create a playbook /home/thor/ansible/playbook.yml to copy /usr/src/sysops/index.html file to all application servers at location /opt/sysops.  
Note: Validation will try to run the playbook using command ansible-playbook -i inventory playbook.yml so please make sure the playbook works this way without passing any extra arguments.  


## 1. Create inventory file
`vi /home/thor/ansible/inventory`  
```console
stapp01 ansible_host=172.16.238.10 ansible_ssh_pass=Ir0nM@n  ansible_user=tony
stapp02 ansible_host=172.16.238.11 ansible_ssh_pass=Am3ric@  ansible_user=steve
stapp03 ansible_host=172.16.238.12 ansible_ssh_pass=BigGr33n  ansible_user=banner
```


## 2. Check the inventory file is working correctly by listing folder on all the app servers
`ansible all -a "ls -ltr /opt/sysops" -i inventory`  
```console
stapp02 | CHANGED | rc=0 >>
total 0
stapp03 | CHANGED | rc=0 >>
total 0
stapp01 | CHANGED | rc=0 >>
total 0
```


## 3. Create playbook file
`vi /home/thor/ansible/playbook.yml`  
```yaml
- name: Ansible Copy Module
  hosts: all
  become: true
  tasks:
    - name: copy index.html to sysops folder
      copy: src=/usr/src/sysops/index.html dest=/opt/sysops
```


## 4. Run the playbook
`cd  /home/thor/ansible/`  
```console
ansible-playbook -i inventory playbook.yml
PLAY [Ansible Copy Module] ******************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************
ok: [stapp01]
ok: [stapp02]
ok: [stapp03]

TASK [copy index.html to sysops folder] *****************************************************************************************************************************************************
changed: [stapp01]
changed: [stapp03]
changed: [stapp02]

PLAY RECAP **********************************************************************************************************************************************************************************
stapp01                    : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
stapp02                    : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
stapp03                    : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```


## 5. Validate the task
`ansible all -a "ls -ltr /opt/sysops" -i inventory`  
```console
stapp01 | CHANGED | rc=0 >>
total 4
-rw-r--r-- 1 root root 35 Aug 30 17:48 index.html
stapp03 | CHANGED | rc=0 >>
total 4
-rw-r--r-- 1 root root 35 Aug 30 17:48 index.html
stapp02 | CHANGED | rc=0 >>
total 4
-rw-r--r-- 1 root root 35 Aug 30 17:48 index.html
```

---

```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:630e42e50f6b19fdd9600c83
```
