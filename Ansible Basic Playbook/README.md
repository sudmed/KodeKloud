# Ansible Basic Playbook

One of the Nautilus DevOps team members was working on to test an Ansible playbook on jump host. However, he was only able to create the inventory, and due to other priorities that came in he has to work on other tasks. Please pick up this task from where he left off and complete it. Below are more details about the task:  
- The inventory file /home/thor/ansible/inventory seems to be having some issues, please fix them. The playbook needs to be run on App Server 1 in Stratos DC, so inventory file needs to be updated accordingly.  
- Create a playbook /home/thor/ansible/playbook.yml and add a task to create an empty file /tmp/file.txt on App Server 1.  

Note: Validation will try to run the playbook using command ansible-playbook -i inventory playbook.yml so please make sure the playbook works this way without passing any extra arguments.


## 1. Reconnaissance on the server
`ansible --version`  
```console
ansible 2.9.9
  config file = /etc/ansible/ansible.cfg
  configured module search path = [u'/home/thor/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python2.7/site-packages/ansible
  executable location = /bin/ansible
  python version = 2.7.5 (default, Jun 20 2019, 20:27:34) [GCC 4.8.5 20150623 (Red Hat 4.8.5-36)]
```

`cat /home/thor/ansible/inventory`  
```console
stapp02 ansible_host=172.238.16.204 ansible_user=steve
```


## 2. Fix the inventory
`vi /home/thor/ansible/inventory`  
```console
stapp01 ansible_host=172.16.238.10 ansible_user=tony ansible_password=Ir0nM@n
```


## 3. Create the playbook
`vi /home/thor/ansible/playbook.yml`  
```yaml
---
- name: Ansible Basic Playbook
  hosts: stapp01
  become: yes
  tasks:
    - name: Create an empty file
      file:
        path: /tmp/file.txt
        state: touch
```




## 4. Check if file exists before applying playbook
`ansible all -a "ls -ltr /tmp/" -i inventory`  
```ansible
stapp01 | CHANGED | rc=0 >>
total 8
-rw------- 1 root root    0 Aug  1  2019 yum.log
-rwx------ 1 root root  836 Aug  1  2019 ks-script-rnBCJB
drwx------ 2 tony tony 4096 Oct 18 19:46 ansible_command_payload_MNu9tc
```


## 5. Run the playbook
`ansible-playbook -i inventory playbook.yml`  
```ansible
PLAY [Ansible Basic Playbook] ***************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************
ok: [stapp01]

TASK [Create an empty file] *****************************************************************************************************************************************************************
changed: [stapp01]

PLAY RECAP **********************************************************************************************************************************************************************************
stapp01                    : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```


## 6. Check if file exists after applying playbook
```ansible
ansible all -a "ls -ltr /tmp/" -i inventory
stapp01 | CHANGED | rc=0 >>
total 8
-rw------- 1 root root    0 Aug  1  2019 yum.log
-rwx------ 1 root root  836 Aug  1  2019 ks-script-rnBCJB
-rw-r--r-- 1 root root    0 Oct 18 19:46 file.txt
drwx------ 2 tony tony 4096 Oct 18 19:47 ansible_command_payload_Lnm5aS
```


## 7. Check if file is empty
```ansible
ansible all -a "cat /tmp/file.txt" -i inventory
stapp01 | CHANGED | rc=0 >>
  
```


---


```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:634d9911142c422e4c9c5dbc
```
