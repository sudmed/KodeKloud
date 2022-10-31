# Ansible Inventory Update

The Nautilus DevOps team has started testing their Ansible playbooks on different servers within the stack. They have placed some playbooks under /home/thor/playbook/ directory on jump host which they want to test. Some of these playbooks have already been tested on different servers, but now they want to test them on app server 2 in Stratos DC. However, they first need to create an inventory file so that Ansible can connect to the respective app. Below are some requirements:  
- a. Create an ini type Ansible inventory file /home/thor/playbook/inventory on jump host.  
- b. Add App Server 2 in this inventory along with required variables that are needed to make it work.  
- c. The inventory hostname of the host should be the server name as per the wiki, for example stapp01 for app server 1 in Stratos DC.  

Note: Validation will try to run the playbook using command ansible-playbook -i inventory playbook.yml so please make sure the playbook works this way without passing any extra arguments.  


## 1. Check the playbook file
`ls /home/thor/playbook/`  
```console
ansible.cfg  playbook.yml
```

`cat /home/thor/playbook/playbook.yml `  
```yaml
---
- hosts: all
  become: yes
  become_user: root
  tasks:
    - name: Install httpd package    
      yum: 
        name: httpd 
        state: installed
    
    - name: Start service httpd
      service:
        name: httpd
        state: started
```

`cat /home/thor/playbook/ansible.cfg`  
```yaml
[defaults]
host_key_checking = False
```


## 2. Create an inventory file
`vi /home/thor/playbook/inventory`  
```yaml
stapp02 ansible_host=172.16.238.11 ansible_ssh_pass=Am3ric@  ansible_user=steve
```


## 3. Run the playbook
`ansible-playbook  -i inventory playbook.yml`  
```ansible
PLAY [all] **********************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************
ok: [stapp02]

TASK [Install httpd package] ****************************************************************************************************************************************************************
changed: [stapp02]

TASK [Start service httpd] ******************************************************************************************************************************************************************
changed: [stapp02]

PLAY RECAP **********************************************************************************************************************************************************************************
stapp02                    : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```


---

```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:631520df429c137159736a55
```

---
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:635b8d05541041a80e0dca90
```bash

```
