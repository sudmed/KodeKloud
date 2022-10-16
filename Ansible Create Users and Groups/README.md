# Ansible Create Users and Groups

Several new developers and DevOps engineers just joined the xFusionCorp industries. They have been assigned the Nautilus project, and as per the onboarding process we need to create user accounts for new joinees on at least one of the app servers in Stratos DC. We also need to create groups and make new users members of those groups. We need to accomplish this task using Ansible. Below you can find more information about the task.  
There is already an inventory file ~/playbooks/inventory on jump host.  
On jump host itself there is a list of users in ~/playbooks/data/users.yml file and there are two groups — admins and developers —that have list of different users. Create a playbook ~/playbooks/add_users.yml on jump host to perform the following tasks on app server 1 in Stratos DC.  
- a. Add all users given in the users.yml file on app server 1.
- b. Also add developers and admins groups on the same server.
- c. As per the list given in the users.yml file, make each user member of the respective group they are listed under.
- d. Make sure home directory for all of the users under developers group is /var/www (not the default i.e /var/www/{USER}). Users under admins group should use the default home directory (i.e /home/devid for user devid).
- e. Set password TmPcZjtRQx for all of the users under developers group and TmPcZjtRQx for of the users under admins group. Make sure to use the password given in the ~/playbooks/secrets/vault.txt file as Ansible vault password to encrypt the original password strings. You can use ~/playbooks/secrets/vault.txt file as a vault secret file while running the playbook (make necessary changes in ~/playbooks/ansible.cfg file).
- f. All users under admins group must be added as sudo users. To do so, simply make them member of the wheel group as well.  

Note: Validation will try to run the playbook using command ansible-playbook -i inventory add_users.yml so please make sure playbook works this way, without passing any extra arguments.  



## 1. Reconnaissance on the server
`ansible --version`  
```console
ansible 2.9.9
  config file = /home/thor/playbooks/ansible.cfg
  configured module search path = [u'/home/thor/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python2.7/site-packages/ansible
  executable location = /bin/ansible
  python version = 2.7.5 (default, Jun 20 2019, 20:27:34) [GCC 4.8.5 20150623 (Red Hat 4.8.5-36)]
```

`cd ~/playbooks/`  
`ll`  
```console
total 16
-rw-r--r-- 1 thor thor   36 Oct 16 17:01 ansible.cfg
drwxr-xr-x 2 thor thor 4096 Oct 16 15:14 data
-rw-r--r-- 1 thor thor  237 Oct 16 17:01 inventory
drwxr-xr-x 2 thor thor 4096 Oct 16 17:01 secrets
```

`cat inventory`  
```console
stapp01 ansible_host=172.16.238.10 ansible_ssh_pass=Ir0nM@n ansible_user=tony
stapp02 ansible_host=172.16.238.11 ansible_ssh_pass=Am3ric@ ansible_user=steve
stapp03 ansible_host=172.16.238.12 ansible_ssh_pass=BigGr33n ansible_user=banner
```

`cat data/users.yml`  
```console
admins:
  - rob
  - david
  - joy

developers:
  - tim
  - ray
  - jim
  - mark
```

`cat secrets/vault.txt`  
```console
P@ss3or432
```

`cat ansible.cfg`  
```console
[defaults]
host_key_checking = False
```


## 2. Add vault in the ansible configuration file
`vi ansible.cfg`  
```console
[defaults]
host_key_checking = False
vault_password_file = /home/thor/playbooks/secrets/vault.txt
```

## 3. Create the playbook
`vi add_users.yml`  
```yaml
---
- name: Add user and groups
  hosts: stapp01
  become: yes
  tasks:
  - name: Create admins group
    group:
      name:
        admins
      state: present
  - name: Create developers group
    group:
      name:
        developers
      state: present
  - name: Create users of admins group
    user:
      name: "{{ item }}"
      password: "{{ 'TmPcZjtRQx' | password_hash ('sha512') }}"
      groups: admins,wheel
      state: present
    loop:
    - rob
    - david
    - joy
  - name: Create users of developers group
    user:
      name: "{{ item }}"
      password: "{{ 'TmPcZjtRQx' | password_hash ('sha512') }}"
      home: "/var/www/{{ item }}"
      group: developers
      state: present
    loop:
    - tim
    - ray
    - jim
    - mark
```


## 4. Check users before applying playbook
`ansible stapp01 -a "cat /etc/passwd" -i inventory`  
```absible
stapp01 | CHANGED | rc=0 >>
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
adm:x:3:4:adm:/var/adm:/sbin/nologin
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
sync:x:5:0:sync:/sbin:/bin/sync
shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
halt:x:7:0:halt:/sbin:/sbin/halt
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
operator:x:11:0:operator:/root:/sbin/nologin
games:x:12:100:games:/usr/games:/sbin/nologin
ftp:x:14:50:FTP User:/var/ftp:/sbin/nologin
nobody:x:99:99:Nobody:/:/sbin/nologin
systemd-network:x:192:192:systemd Network Management:/:/sbin/nologin
dbus:x:81:81:System message bus:/:/sbin/nologin
sshd:x:74:74:Privilege-separated SSH:/var/empty/sshd:/sbin/nologin
ansible:x:1000:1000::/home/ansible:/bin/bash
tony:x:1001:1001::/home/tony:/bin/bash
```


## 5. Run the playbook
`ansible-playbook -i inventory add_users.yml`  
```absible
PLAY [Add user and groups] ******************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************
ok: [stapp01]

TASK [Create admins group] ******************************************************************************************************************************************************************
changed: [stapp01]

TASK [Create developers group] **************************************************************************************************************************************************************
changed: [stapp01]

TASK [Create users of admins group] *********************************************************************************************************************************************************
changed: [stapp01] => (item=rob)
changed: [stapp01] => (item=david)
changed: [stapp01] => (item=joy)

TASK [Create users of developers group] *****************************************************************************************************************************************************
changed: [stapp01] => (item=tim)
changed: [stapp01] => (item=ray)
changed: [stapp01] => (item=jim)
changed: [stapp01] => (item=mark)

PLAY RECAP **********************************************************************************************************************************************************************************
stapp01                    : ok=5    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```


## 6. Check users after applying playbook
`ansible stapp01 -a "cat /etc/passwd" -i inventory`  
```absible
stapp01 | CHANGED | rc=0 >>
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
adm:x:3:4:adm:/var/adm:/sbin/nologin
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
sync:x:5:0:sync:/sbin:/bin/sync
shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
halt:x:7:0:halt:/sbin:/sbin/halt
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
operator:x:11:0:operator:/root:/sbin/nologin
games:x:12:100:games:/usr/games:/sbin/nologin
ftp:x:14:50:FTP User:/var/ftp:/sbin/nologin
nobody:x:99:99:Nobody:/:/sbin/nologin
systemd-network:x:192:192:systemd Network Management:/:/sbin/nologin
dbus:x:81:81:System message bus:/:/sbin/nologin
sshd:x:74:74:Privilege-separated SSH:/var/empty/sshd:/sbin/nologin
ansible:x:1000:1000::/home/ansible:/bin/bash
tony:x:1001:1001::/home/tony:/bin/bash
rob:x:1002:1004::/home/rob:/bin/bash
david:x:1003:1005::/home/david:/bin/bash
joy:x:1004:1006::/home/joy:/bin/bash
tim:x:1005:1003::/var/www/tim:/bin/bash
ray:x:1006:1003::/var/www/ray:/bin/bash
jim:x:1007:1003::/var/www/jim:/bin/bash
mark:x:1008:1003::/var/www/mark:/bin/bash
```

---

```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:634b203be93d21b175d33bf2
```
