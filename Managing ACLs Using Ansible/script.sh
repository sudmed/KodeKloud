# Managing ACLs Using Ansible
: '
There are some files that need to be created on all app servers in Stratos DC. The Nautilus DevOps team want these files to be owned by user root only; 
however, they also want that app-specific user to have a set of permissions to these files. All tasks must be done using Ansible only, so they need 
to create a playbook. Below you can find more information about the task.
Create a playbook.yml under /home/thor/ansible on jump host, an inventory file is already present under /home/thor/ansible on Jump Server itself.
Create an empty file blog.txt under /opt/sysops/ directory on app server 1. Set some acl properties for this file. Using acl provide read '(r)' permissions 
to group tony (i.e entity is tony and etype is group).
Create an empty file story.txt under /opt/sysops/ directory on app server 2. Set some acl properties for this file. Using acl provide read + write '(rw)' 
permissions to user steve (i.e entity is steve and etype is user).
Create an empty file media.txt under /opt/sysops/ on app server 3. Set some acl properties for this file. Using acl provide read + write '(rw)' permissions 
to group banner (i.e entity is banner and etype is group).
Note: Validation will try to run playbook using command ansible-playbook -i inventory playbook.yml so please make sure playbook works this way, 
without passing any extra arguments.
'


cd /home/thor/ansible/
ll
cat inventory
cat ansible.cfg

# Check the existing file  
ansible all -a "ls -ltr /opt/sysops/" -i inventory

# Create a playbook
vi playbook.yml

- name: Create file and set ACL in Host 1
  hosts: stapp01
  become: yes
  tasks:
    - name: Create the blog.txt on stapp01
      file:
        path: /opt/sysops/blog.txt
        state: touch
    - name: Set ACL for blog.txt
      acl:
        path: /opt/sysops/blog.txt
        entity: tony
        etype: group
        permissions: r
        state: present
- name: Create file and set ACL in Host 2
  hosts: stapp02
  become: yes
  tasks:
    - name: Create the story.txt on stapp02
      file:
        path: /opt/sysops/story.txt
        state: touch
    - name: Set ACL for story.txt
      acl:
        path: /opt/sysops/story.txt
        entity: steve
        etype: user
        permissions: rw
        state: present
- name: Create file and set ACL in Host 3
  hosts: stapp03
  become: yes
  tasks:
    - name: Create the media.txt on stapp03
      file:
        path: /opt/sysops/media.txt
        state: touch
    - name: Set ACL for media.txt
      acl:
        path: /opt/sysops/media.txt
        entity: banner
        etype: group
        permissions: rw
        state: present
		

# execute playbook
ansible-playbook  -i inventory playbook.yml

# validate the task
ansible all -a "ls -ltr /opt/sysops/" -i inventory



####################################################
```bash
- name: Create file and set ACL for Host2                                                                         
  hosts: stapp02                                                                                                  
  become: yes                                                                                                     
  tasks:                                                                                                          
    - name: Create story.txt on stapp02                                                                           
      file:                                                                                                       
        path: /opt/dba/story.txt                                                                                  
        state: touch                                                                                              
    - name: Set ACL for story.txt                                                                                 
      acl:                                                                                                        
        path: /opt/dba/story.txt                                                                                  
        entity: steve                                                                                             
        etype: group 
```
You wrote 'etype: group' instead 'etype: user'.
