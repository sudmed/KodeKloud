# Managing Jinja2 Templates Using Ansible
: ' One of the Nautilus DevOps team members is working on to develop a role for httpd installation and configuration. Work is almost completed, 
however there is a requirement to add a jinja2 template for index.html file. Additionally, the relevant task needs to be added inside the role. 
The inventory file ~/ansible/inventory is already present on jump host that can be used. Complete the task as per details mentioned below:
a. Update ~/ansible/playbook.yml playbook to run the httpd role on App Server 3.
b. Create a jinja2 template index.html.j2 under /home/thor/ansible/role/httpd/templates/ directory and add a line This file was created using Ansible 
on <respective server> (for example This file was created using Ansible on stapp01 in case of App Server 1). Also please make sure not to hard code 
the server name inside the template. Instead, use inventory_hostname variable to fetch the correct value.
c. Add a task inside /home/thor/ansible/role/httpd/tasks/main.yml to copy this template on App Server 3 under /var/www/html/index.html. Also make sure 
that /var/www/html/index.html file's permissions are 0744.
d. The user/group owner of /var/www/html/index.html file must be respective sudo user of the server (for example tony in case of stapp01).
Note: Validation will try to run the playbook using command ansible-playbook -i inventory playbook.yml so please make sure the playbook works this way 
without passing any extra arguments.
'


cd  ~/ansible/

vi playbook.yml
---
---- hosts:
+++- hosts: stapp03
  become: yes
  become_user: root
  roles:
    - role/httpd

vi /home/thor/ansible/role/httpd/templates/index.html.j2
+++This file was created using Ansible on {{ ansible_hostname }}

vi /home/thor/ansible/role/httpd/tasks/main.yml
+++- name: copy template to stapp03
+++  template:
+++    src: /home/thor/ansible/role/httpd/templates/index.html.j2
+++    dest: /var/www/html/index.html
+++    mode: "0744"
+++    owner: "{{ ansible_user }}"
+++    group: "{{ ansible_user }}"

ansible-playbook  -i inventory playbook.yml

ansible stapp02 -a "cat /var/www/html/index.html" -i inventory
