# Ansible File Module

The Nautilus DevOps team is working to test several Ansible modules on servers in Stratos DC. Recently they wanted to test the file creation on remote hosts using Ansible. Find below more details about the task:
- a. Create an inventory file ~/playbook/inventory on jump host and add all app servers in it.
- b. Create a playbook ~/playbook/playbook.yml to create a blank file /tmp/web.txt on all app servers.
- c. The /opt/webapp.txt file permission must be 0755.
- d. The user/group owner of file /tmp/web.txt must be tony on app server 1, steve on app server 2 and banner on app server 3.

Note: Validation will try to run the playbook using command ansible-playbook -i inventory playbook.yml, so please make sure the playbook works this way without passing any extra arguments.


## 1. Create the inventory
`cd ~/playbook`  
`ll`  
```console
total 0
```

`vi inventory`  
```ansible
stapp01 ansible_user=tony ansible_ssh_pass=Ir0nM@n 
stapp02 ansible_user=steve ansible_ssh_pass=Am3ric@
stapp03 ansible_user=banner ansible_ssh_pass=BigGr33n
```


## 2. Create the playbook
`vi playbook.yml`  
```yaml
- hosts: all
  become: yes
  tasks:
  - name: Create blank file
    file:
      path: /tmp/web.txt
      state: touch
      owner: "{{ ansible_user }}"
      group: "{{ ansible_user }}"
      mode: "0755"
```


## 3. Run the playbook
`ansible-playbook -i inventory playbook.yml`  
```ansible
PLAY [all] **********************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************
ok: [stapp02]
ok: [stapp03]
ok: [stapp01]

TASK [Create blank file] ********************************************************************************************************************************************************************
changed: [stapp01]
changed: [stapp03]
changed: [stapp02]

PLAY RECAP **********************************************************************************************************************************************************************************
stapp01                    : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
stapp02                    : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
stapp03                    : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```


## 4. Validate the task
`ssh tony@stapp01`  
```console
tony@stapp01's password: 
Last login: Thu Oct  6 16:16:01 2022 from jump_host.devops-ansible-file-v2_app_net
[tony@stapp01 ~]$ ll /tmp/
total 4
-rwx------ 1 root root 836 Aug  1  2019 ks-script-rnBCJB
-rwxr-xr-x 1 tony tony   0 Oct  6 16:16 web.txt
-rw------- 1 root root   0 Aug  1  2019 yum.log
[tony@stapp01 ~]$ cat /tmp/web.txt
[tony@stapp01 ~]$
```


---

```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:633e9a0b7709388fbeb3bcb9
```
