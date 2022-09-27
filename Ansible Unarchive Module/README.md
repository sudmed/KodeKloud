# Ansible Unarchive Module

One of the DevOps team members has created an ZIP archive on jump host in Stratos DC that needs to be extracted and copied over to all app servers in Stratos DC itself. Because this is a routine task, the Nautilus DevOps team has suggested automating it. We can use Ansible since we have been using it for other automation tasks. Below you can find more details about the task:  
- We have an inventory file under /home/thor/ansible directory on jump host, which should have all the app servers added already.  
- There is a ZIP archive /usr/src/itadmin/nautilus.zip on jump host.  
- Create a playbook.yml under /home/thor/ansible/ directory on jump host itself to perform the below given tasks.  
- Unzip /usr/src/itadmin/nautilus.zip archive in /opt/itadmin/ location on all app servers.  
- Make sure the extracted data must has the respective sudo user as their user and group owner, i.e tony for app server 1, steve for app server 2, banner for app server 3.  
- The extracted data permissions must be 0644.  

Note: Validation will try to run the playbook using command ansible-playbook -i inventory playbook.yml so please make sure playbook works this way, without passing any extra arguments.  



## 1. Reconnaissance on the server
`uname -a`
```console
Linux jump_host.stratos.xfusioncorp.com 5.4.0-1087-gcp #95~18.04.1-Ubuntu SMP Mon Aug 22 03:26:39 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
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

`cd  /home/thor/ansible/`  
`ll`  
```console
total 8
-rw-r--r-- 1 thor thor  36 Sep 27 18:11 ansible.cfg
-rw-r--r-- 1 thor thor 237 Sep 27 18:11 inventory
```

`cat inventory`  
```ansible
stapp01 ansible_host=172.16.238.10 ansible_ssh_pass=Ir0nM@n ansible_user=tony
stapp02 ansible_host=172.16.238.11 ansible_ssh_pass=Am3ric@ ansible_user=steve
stapp03 ansible_host=172.16.238.12 ansible_ssh_pass=BigGr33n ansible_user=banner
```

`cat ansible.cfg`  
```console
[defaults]
host_key_checking = False
```

`ansible all -a "ls -ltr /opt/itadmin/" -i inventory`  
```ansible
stapp03 | CHANGED | rc=0 >>
total 0
stapp01 | CHANGED | rc=0 >>
total 0
stapp02 | CHANGED | rc=0 >>
total 0
```

`ll /usr/src/itadmin/`  
```console
total 4
-rw-r--r-- 1 root root 367 Sep 27 18:12 nautilus.zip
```

## 2. Create the playbook
`vi playbook.yml`  
```yaml
- name: Unarchive an archive
  hosts: stapp01, stapp02, stapp03
  become: yes
  tasks:
    - name: Extract the archive and set the owner/permissions
      unarchive:
        src: /usr/src/itadmin/nautilus.zip
        dest: /opt/itadmin/
        owner: "{{ ansible_user }}"
        group: "{{ ansible_user }}"
        mode: "0644"
```


## 3. Run the playbook
`ansible-playbook -i inventory playbook.yml`  
```ansible
PLAY [Extract archive] **********************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************
ok: [stapp02]
ok: [stapp03]
ok: [stapp01]

TASK [Extract the archive and set the owner/permissions] ************************************************************************************************************************************
changed: [stapp03]
changed: [stapp02]
changed: [stapp01]

PLAY RECAP **********************************************************************************************************************************************************************************
stapp01                    : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
stapp02                    : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
stapp03                    : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```


## 4. Validate the task
`ansible all -a "ls -ltr /opt/itadmin/" -i inventory`  
```ansible
stapp01 | CHANGED | rc=0 >>
total 4
drw-r--r-- 2 tony tony 4096 Sep 27 18:12 unarchive
stapp02 | CHANGED | rc=0 >>
total 4
drw-r--r-- 2 steve steve 4096 Sep 27 18:12 unarchive
stapp03 | CHANGED | rc=0 >>
total 4
drw-r--r-- 2 banner banner 4096 Sep 27 18:12 unarchive
```

---

```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:63333b0a71ef6a3364359241
```
