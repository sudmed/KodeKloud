# Ansible Archive Module

The Nautilus DevOps team has some data on jump host in Stratos DC that they want to copy on all app servers in the same data center. However, they want to create an archive of data and copy it to the app servers. Additionally, there are some specific requirements for each server. Perform the task using Ansible playbook as per requirements mentioned below:  
- Create a playbook.yml under /home/thor/ansible on jump host, an inventory file is already placed under /home/thor/ansible/ on Jump Server itself.
- Create an archive apps.tar.gz (make sure archive format is tar.gz) of /usr/src/devops/ directory ( present on each app server ) and copy it to /opt/devops/ directory on all app servers. The user and group owner of archive apps.tar.gz should be tony for App Server 1, steve for App Server 2 and banner for App Server 3.  

Note: Validation will try to run playbook using command ansible-playbook -i inventory playbook.yml so please make sure playbook works this way, without passing any extra arguments.  


## 1. Reconnaissance on the server
`cd /home/thor/ansible/`  
`ll`  
```console
total 8
-rw-r--r-- 1 thor thor  36 Sep 17 17:55 ansible.cfg
-rw-r--r-- 1 thor thor 237 Sep 17 17:55 inventory
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

`ansible --version`  
```console
ansible 2.9.9
  config file = /home/thor/ansible/ansible.cfg
  configured module search path = [u'/home/thor/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python2.7/site-packages/ansible
  executable location = /bin/ansible
  python version = 2.7.5 (default, Jun 20 2019, 20:27:34) [GCC 4.8.5 20150623 (Red Hat 4.8.5-36)]
```

`ansible all -a "ls /opt/devops/" -i inventory`  
```ansible
stapp01 | CHANGED | rc=0 >>
stapp02 | CHANGED | rc=0 >>
stapp03 | CHANGED | rc=0 >>
```


## 2. Create the playbook
`vi playbook.yml`  

```yaml
---
- name: 'Ansible Archive Module'
  hosts: all
  become: true
  tasks:
  
  - name: 'Create archive'
    archive:
      path: /usr/src/devops/
      dest: /opt/devops/apps.tar.gz
      owner: "{{ ansible_user }}"
      group: "{{ ansible_user }}"
```


## 3. Run the playbook
`ansible-playbook -i inventory playbook.yml`  
```ansible
PLAY [Ansible Archive Module] ***************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************
ok: [stapp02]
ok: [stapp01]
ok: [stapp03]

TASK [Create archive] ***********************************************************************************************************************************************************************
changed: [stapp01]
changed: [stapp03]
changed: [stapp02]

PLAY RECAP **********************************************************************************************************************************************************************************
stapp01                    : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
stapp02                    : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
stapp03                    : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```


## 4. Validate the task
`ansible all -a "ls /opt/devops/" -i inventory`  
```ansible
stapp01 | CHANGED | rc=0 >>
apps.tar.gz
stapp03 | CHANGED | rc=0 >>
apps.tar.gz
stapp02 | CHANGED | rc=0 >>
apps.tar.gz
```

---

```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:632571571da11b53193e756f
```
