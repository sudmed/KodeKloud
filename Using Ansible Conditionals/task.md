# Using Ansible Conditionals

The Nautilus DevOps team had a discussion about, how they can train different team members to use Ansible for different automation tasks.  
There are numerous ways to perform a particular task using Ansible, but we want to utilize each aspect that Ansible offers.  
The team wants to utilise Ansible's conditionals to perform the following task:  
An inventory file is already placed under /home/thor/ansible directory on jump host, with all the Stratos DC app servers included.  
Create a playbook /home/thor/ansible/playbook.yml and make sure to use Ansible's when conditionals statements to perform the below given tasks.  
Copy blog.txt file present under /usr/src/devops directory on jump host to App Server 1 under /opt/devops directory. Its user and group owner must be user tony and its permissions must be 0655.  
Copy story.txt file present under /usr/src/devops directory on jump host to App Server 2 under /opt/devops directory. Its user and group owner must be user steve and its permissions must be 0655.  
Copy media.txt file present under /usr/src/devops directory on jump host to App Server 3 under /opt/devops directory. Its user and group owner must be user banner and its permissions must be 0655.  
NOTE: You can use ansible_nodename variable from gathered facts with when condition. Additionally, please make sure you are running the play for all hosts i.e use - hosts: all.  
Note: Validation will try to run the playbook using command ansible-playbook -i inventory playbook.yml, so please make sure the playbook works this way without passing any extra arguments.  


## 1. Create playbook
`vi /home/thor/ansible/playbook.yml`
```yaml
---
- name: Copy files to all App servers
  hosts: all
  become: yes
  tasks:
    - name: Copy blog.txt to stapp01
      copy:
        src: /usr/src/devops/blog.txt
        dest: /opt/devops/
        owner: tony
        group: tony
        mode: "0655"
      when: inventory_hostname == "stapp01"

    - name: Copy story.txt to stapp02
      copy:
        src: /usr/src/devops/story.txt
        dest: /opt/devops/
        owner: steve
        group: steve
        mode: "0655"
      when: inventory_hostname == "stapp02"

    - name: Copy media.txt to stapp03
      copy:
        src: /usr/src/devops/media.txt
        dest: /opt/devops/
        owner: banner
        group: banner
        mode: "0655"
      when: inventory_hostname == "stapp03"
```


## 2. Run playbook
`ansible-playbook -i inventory playbook.yml`

```console
PLAY [Copy files to all App servers] ********************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************
ok: [stapp02]
ok: [stapp03]
ok: [stapp01]

TASK [Copy blog.txt to stapp01] *************************************************************************************************************************************************************
skipping: [stapp02]
skipping: [stapp03]
changed: [stapp01]

TASK [Copy story.txt to stapp02] ************************************************************************************************************************************************************
skipping: [stapp01]
skipping: [stapp03]
changed: [stapp02]

TASK [Copy media.txt to stapp03] ************************************************************************************************************************************************************
skipping: [stapp01]
skipping: [stapp02]
changed: [stapp03]

PLAY RECAP **********************************************************************************************************************************************************************************
stapp01                    : ok=2    changed=1    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0   
stapp02                    : ok=2    changed=1    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0   
stapp03                    : ok=2    changed=1    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
```


# 3. Validate results
`ansible all -a "ls -ltr /opt/devops" -i inventory`

```console
stapp03 | CHANGED | rc=0 >>
total 4
-rw-r-xr-x 1 banner banner 22 Jun 24 11:20 media.txt
stapp01 | CHANGED | rc=0 >>
total 4
-rw-r-xr-x 1 tony tony 35 Jun 24 11:20 blog.txt
stapp02 | CHANGED | rc=0 >>
total 4
-rw-r-xr-x 1 steve steve 27 Jun 24 11:20 story.txt
```


```console
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:62b57e447ee42c3ed2d18c93
```
