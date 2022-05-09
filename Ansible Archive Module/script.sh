# Ansible Archive Module
: '
The Nautilus DevOps team has some data on jump host in Stratos DC that they want to copy on all app servers in the same data center. 
However, they want to create an archive of data and copy it to the app servers. Additionally, there are some specific requirements for each server. 
Perform the task using Ansible playbook as per requirements mentioned below:
Create a playbook.yml under /home/thor/ansible on jump host, an inventory file is already placed under /home/thor/ansible/ on Jump Server itself.
Create an archive apps.tar.gz (make sure archive format is tar.gz) of /usr/src/sysops/ directory ( present on each app server ) and 
copy it to /opt/sysops/ directory on all app servers. The user and group owner of archive apps.tar.gz should be tony for App Server 1, 
steve for App Server 2 and banner for App Server 3.
Note: Validation will try to run playbook using command ansible-playbook -i inventory playbook.yml so please make sure playbook works this way, 
without passing any extra arguments.
'


# At first ansible inventory file is working properly and doesn't have any file exist from jump server to all the app server's
cd /home/thor/ansible/
ansible all -a "ls -ltr /opt/sysops" -i inventory
stapp01 | CHANGED | rc=0 >>
total 0
stapp03 | CHANGED | rc=0 >>
total 0
stapp02 | CHANGED | rc=0 >>
total 0

# cat inventory                                                                       
stapp01 ansible_host=172.16.238.10 ansible_ssh_pass=Ir0nM@n ansible_user=tony                                 
stapp02 ansible_host=172.16.238.11 ansible_ssh_pass=Am3ric@ ansible_user=steve                                
stapp03 ansible_host=172.16.238.12 ansible_ssh_pass=BigGr33n ansible_user=banner

# If you see above output then create playbook file
vi /home/thor/ansible/playbook.yml

- name: Task create archive and copy to host
  hosts: stapp01, stapp02, stapp03
  become: yes
  tasks:
    - name: As per the task create the archive file and set the owner
      archive:
        path: /usr/src/sysops/
        dest: /opt/sysops/beta.tar.gz
        format: gz
        force_archive: true
        owner: "{{ ansible_user }}"
        group: "{{ ansible_user }}"


# Run below command to execute the task
ansible-playbook  -i inventory playbook.yml

# ansible all -a "ls -ltr /opt/sysops" -i inventory


# In your playbook destination file is wrong: beta.tar.gz instead apps.tar.gz
