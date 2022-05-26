# Creating Soft Links Using Ansible
: '
The Nautilus DevOps team is practicing some of the Ansible modules and creating and testing different Ansible playbooks to accomplish tasks. Recently they started testing an Ansible file module to create soft links on all app servers. Below you can find more details about it.
Write a playbook.yml under /home/thor/ansible directory on jump host, an inventory file is already present under /home/thor/ansible directory on jump host itself. Using this playbook accomplish below given tasks:
Create an empty file /opt/devops/blog.txt on app server 1; its user owner and group owner should be tony. Create a symbolic link of source path /opt/devops to destination /var/www/html.
Create an empty file /opt/devops/story.txt on app server 2; its user owner and group owner should be steve. Create a symbolic link of source path /opt/devops to destination /var/www/html.
Create an empty file /opt/devops/media.txt on app server 3; its user owner and group owner should be banner. Create a symbolic link of source path /opt/devops to destination /var/www/html.
Note: Validation will try to run the playbook using command ansible-playbook -i inventory playbook.yml so please make sure playbook works this way without passing any extra arguments.
'


# create playbook
vi /home/thor/ansible/playbook.yml

---
- hosts: stapp01
  gather_facts: false
  become: true
  tasks:
  - name: Create file
    file:
        path: /opt/devops/blog.txt
        state: touch
        owner: tony
        group: tony

  - name: Create simlink
    file:
        src: /opt/devops
        dest: /var/www/html
        state: link

- hosts: stapp02
  gather_facts: false
  become: true
  tasks:
  - name: Create file
    file:
        path: /opt/devops/story.txt
        state: touch
        owner: steve
        group: steve

  - name: Create simlink
    file:
        src: /opt/devops
        dest: /var/www/html
        state: link

- hosts: stapp03
  gather_facts: false
  become: true
  tasks:
  - name: Create file
    file:
        path: /opt/devops/media.txt
        state: touch
        owner: banner
        group: banner

  - name: Create simlink
    file:
        src: /opt/devops
        dest: /var/www/html
        state: link


# execute playbook
ansible-playbook  -i inventory playbook.yml

# validate
ansible all -a "ls -ltr /opt/devops" -i inventory
		
		
		
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:628feb295cba4772b79c6c9e
