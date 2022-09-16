# Managing ACLs Using Ansible

There are some files that need to be created on all app servers in Stratos DC. The Nautilus DevOps team want these files to be owned by user root only however, they also want that the app specific user to have a set of permissions on these files. All tasks must be done using Ansible only, so they need to create a playbook. Below you can find more information about the task.  
Create a playbook.yml under /home/thor/ansible on jump host, an inventory file is already present under /home/thor/ansible directory on Jump Server itself.  
Create an empty file blog.txt under /opt/itadmin/ directory on app server 1. Set some acl properties for this file. Using acl provide read '(r)' permissions to group tony (i.e entity is tony and etype is group).  
Create an empty file story.txt under /opt/itadmin/ directory on app server 2. Set some acl properties for this file. Using acl provide read + write '(rw)' permissions to user steve (i.e entity is steve and etype is user).  
Create an empty file media.txt under /opt/itadmin/ on app server 3. Set some acl properties for this file. Using acl provide read + write '(rw)' permissions to group banner (i.e entity is banner and etype is group).  
Note: Validation will try to run the playbook using command ansible-playbook -i inventory playbook.yml so please make sure the playbook works this way, without passing any extra arguments.  


## 1. Reconnaissance on the server
`cd /home/thor/ansible`  
`ll`  
```console
total 8
-rw-r--r-- 1 thor thor  36 Sep 16 06:40 ansible.cfg
-rw-r--r-- 1 thor thor 237 Sep 16 06:40 inventory
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

`ansible all -a "ls -ltr /opt/itadmin/" -i inventory`  
```console
stapp01 | CHANGED | rc=0 >>
total 0
stapp03 | CHANGED | rc=0 >>
total 0
stapp02 | CHANGED | rc=0 >>
total 0
```


## 2. Create a playbook
`vi playbook.yml`  

```yaml
---
- hosts: stapp01
  become: yes
  tasks:
    - name: Touch empty file stapp01
      file:
        path: "/opt/itadmin/blog.txt"
        state: touch
        owner: root
    - name: Configure ACL
      acl:
        path: "/opt/itadmin/blog.txt"
        entity: tony
        etype: group
        permissions: r
        state: present
        
- hosts: stapp02
  become: yes
  tasks:
    - name: Touch empty file stapp02
      file:
        path: "/opt/itadmin/story.txt"
        state: touch 
        owner: root
    - name: Configure ACL
      acl: 
        path: "/opt/itadmin/story.txt"
        entity: steve
        etype: user
        permissions: rw
        state: present
        
- hosts: stapp03
  become: yes
  tasks:
    - name: Touch empty file stapp03
      file:
        path: "/opt/itadmin/media.txt"
        state: touch 
        owner: root
    - name: Configure ACL
      acl: 
        path: "/opt/itadmin/media.txt"
        entity: banner
        etype: group
        permissions: rw
        state: present
```


## Run the playbook
`ansible-playbook  -i inventory playbook.yml`  
```ansible
PLAY [stapp01] ******************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************
ok: [stapp01]

TASK [Touch empty file stapp01] *************************************************************************************************************************************************************
changed: [stapp01]

TASK [Configure ACL] ************************************************************************************************************************************************************************
changed: [stapp01]

PLAY [stapp02] ******************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************
ok: [stapp02]

TASK [Touch empty file stapp02] *************************************************************************************************************************************************************
changed: [stapp02]

TASK [Configure ACL] ************************************************************************************************************************************************************************
changed: [stapp02]

PLAY [stapp03] ******************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************
ok: [stapp03]

TASK [Touch empty file stapp03] *************************************************************************************************************************************************************
changed: [stapp03]

TASK [Configure ACL] ************************************************************************************************************************************************************************
changed: [stapp03]

PLAY RECAP **********************************************************************************************************************************************************************************
stapp01                    : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
stapp02                    : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
stapp03                    : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```


## Validate the task by running the below command      
`ansible all -a "ls -ltr /opt/itadmin/" -i inventory`  
```ansible
stapp02 | CHANGED | rc=0 >>
total 0
-rw-rw-r--+ 1 root root 0 Sep 16 06:49 story.txt
stapp03 | CHANGED | rc=0 >>
total 0
-rw-rw-r--+ 1 root root 0 Sep 16 06:49 media.txt
stapp01 | CHANGED | rc=0 >>
total 0
-rw-r--r--+ 1 root root 0 Sep 16 06:49 blog.txt
```


---


```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:63235ae6c48739739603ac3e
```
