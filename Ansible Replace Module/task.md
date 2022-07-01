# Ansible Replace Module

There is some data on all app servers in Stratos DC. The Nautilus development team shared some requirement  
with the DevOps team to alter some of the data as per recent changes they made. The DevOps team is working  
to prepare an Ansible playbook to accomplish the same. Below you can find more details about the task.  
Write a playbook.yml under /home/thor/ansible on jump host, an inventory is already present under /home/thor/ansible  
directory on Jump host itself. Perform below given tasks using this playbook:  
We have a file /opt/itadmin/blog.txt on app server 1. Using Ansible replace module replace string xFusionCorp to Nautilus in that file.  
We have a file /opt/itadmin/story.txt on app server 2. Using Ansiblereplace module replace the string Nautilus to KodeKloud in that file.  
We have a file /opt/itadmin/media.txt on app server 3. Using Ansible replace module replace string KodeKloud to xFusionCorp Industries in that file.  
Note: Validation will try to run the playbook using command ansible-playbook -i inventory playbook.yml  
so please make sure the playbook works this way without passing any extra arguments.


## 1. Let's see config & inventory files
`cd /home/thor/ansible`  
`ll`  
```console
total 8
-rw-r--r-- 1 thor thor  36 Jul  1 10:57 ansible.cfg
-rw-r--r-- 1 thor thor 237 Jul  1 10:57 inventory
```

`cat ansible.cfg `
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


## 2.  Create playbook
`vi playbook.yml`
```yaml
---
- name: Ansible replace
  hosts: stapp01,stapp02,stapp03
  become: yes
  tasks:

    - name: blog.txt replacement
      replace:
        path: /opt/itadmin/blog.txt
        regexp: "xFusionCorp"
        replace: "Nautilus"
      when: inventory_hostname == "stapp01"

    - name: story.txt replacement
      replace:
        path: /opt/itadmin/story.txt
        regexp: "Nautilus"
        replace: "KodeKloud"
      when: inventory_hostname == "stapp02"

    - name: media.txt replacement
      replace:
        path: /opt/itadmin/media.txt
        regexp: "KodeKloud"
        replace: "xFusionCorp Industries"
      when: inventory_hostname == "stapp03"
...


## 3.  Play the playbook
`ansible-playbook playbook.yml -i inventory`
```console
PLAY [Ansible replace] **********************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************
ok: [stapp03]
ok: [stapp01]
ok: [stapp02]

TASK [blog.txt replacement] *****************************************************************************************************************************************************************
skipping: [stapp02]
skipping: [stapp03]
changed: [stapp01]

TASK [story.txt replacement] ****************************************************************************************************************************************************************
skipping: [stapp01]
skipping: [stapp03]
changed: [stapp02]

TASK [media.txt replacement] ****************************************************************************************************************************************************************
skipping: [stapp01]
skipping: [stapp02]
changed: [stapp03]

PLAY RECAP **********************************************************************************************************************************************************************************
stapp01                    : ok=2    changed=1    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0   
stapp02                    : ok=2    changed=1    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0   
stapp03                    : ok=2    changed=1    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
```


## 4. Validate the task
`ssh -t tony@stapp01 "cat /opt/itadmin/blog.txt"`
```console
The authenticity of host 'stapp01 (172.16.238.10)' can't be established.
ECDSA key fingerprint is SHA256:Q1NwmiVH/DufOId70ifGfDwPYY+Vd3jOihBRp+mhH9g.
ECDSA key fingerprint is MD5:ed:9b:b8:df:e0:0c:78:29:46:d8:16:ef:69:0a:74:c2.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'stapp01' (ECDSA) to the list of known hosts.
tony@stapp01's password: 
Welcome to Nautilus Industries !
Connection to stapp01 closed.
```



```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:62bc6a17a0c93e53693afa0f
```
