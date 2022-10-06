# Ansible File Module



cd ~/playbook
thor@jump_host ~/playbook$ ll 
total 0
thor@jump_host ~/playbook$ vi inventory
thor@jump_host ~/playbook$ cat inventory
stapp01 ansible_user=tony ansible_ssh_pass=Ir0nM@n 
stapp02 ansible_user=steve ansible_ssh_pass=Am3ric@
stapp03 ansible_user=banner ansible_ssh_pass=BigGr33n

thor@jump_host ~/playbook$ vi ~/playbook/playbook.yml
thor@jump_host ~/playbook$ cat ~/playbook/playbook.yml
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



ansible-playbook -i inventory playbook.yml
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



ssh tony@stapp01
tony@stapp01's password: 
Last login: Thu Oct  6 16:16:01 2022 from jump_host.devops-ansible-file-v2_app_net
[tony@stapp01 ~]$ ll /tmp/
total 4
-rwx------ 1 root root 836 Aug  1  2019 ks-script-rnBCJB
-rwxr-xr-x 1 tony tony   0 Oct  6 16:16 web.txt
-rw------- 1 root root   0 Aug  1  2019 yum.log
[tony@stapp01 ~]$ cat /tmp/web.txt
[tony@stapp01 ~]$



CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:633e9a0b7709388fbeb3bcb9
