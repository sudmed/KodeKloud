# Ansible Ping Module Usage

The Nautilus DevOps team is planning to test several Ansible playbooks on different app servers in Stratos DC. Before that, some pre-requisites must be met.  
Essentially, the team needs to set up a password-less SSH connection between Ansible controller and Ansible managed nodes.  
One of the tickets is assigned to you; please complete the task as per details mentioned below:  
- a. Jump host is our Ansible controller, and we are going to run Ansible playbooks through thor user on jump host.  
- b.Make appropriate changes on jump host so that user thor on jump host can SSH into App Server 3 through its respective sudo user. (for example tony for app server 1).  
- c. There is an inventory file /home/thor/ansible/inventory on jump host. Using that inventory file test Ansible ping from jump host to App Server 3, make sure ping works.  


## 1.  Check the inventory file
`cat /home/thor/ansible/inventory`  
```console
stapp01 ansible_host=172.16.238.10 ansible_ssh_pass=Ir0nM@n ansible_user=tony
stapp02 ansible_host=172.16.238.11 ansible_ssh_pass=Am3ric@ ansible_user=steve
stapp03 ansible_host=172.16.238.12 ansible_ssh_pass=BigGr33n ansible_user=banner
```


## 2. Generate a SSH key
`ssh-keygen -t rsa -b 2048`  
```console
Generating public/private rsa key pair.
Enter file in which to save the key (/home/thor/.ssh/id_rsa): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/thor/.ssh/id_rsa.
Your public key has been saved in /home/thor/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:kjOjDXqt0luK4iyqKrxoVQKMvWSud+TOEqcpgr31mrk thor@jump_host.stratos.xfusioncorp.com
The key's randomart image is:
+---[RSA 2048]----+
|o.               |
|.o+              |
| +..             |
|  o... .         |
| . o+ * S        |
|. oo+= =         |
|oooX+ +          |
|Xo*++B           |
|#*++E+.          |
+----[SHA256]-----+
```


## 3. Copy SSH key to the host
`ssh-copy-id banner@stapp03`  
```console
/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/thor/.ssh/id_rsa.pub"
The authenticity of host 'stapp03 (172.16.238.12)' can't be established.
ECDSA key fingerprint is SHA256:JUIIT4P6QDf4lNaB6Hq2Gi3DCc8Ji3mGr7og+vbgFuw.
ECDSA key fingerprint is MD5:e9:85:a7:1e:c6:82:92:7b:6a:8f:f1:34:07:a9:ba:e4.
Are you sure you want to continue connecting (yes/no)? yes
/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
banner@stapp03's password: 
Number of key(s) added: 1
Now try logging into the machine, with:   "ssh 'banner@stapp03'"
and check to make sure that only the key(s) you wanted were added.
```


## 4. Validate the task
`ansible stapp03 -m ping -i /home/thor/ansible/inventory -v`  
```console
Using /etc/ansible/ansible.cfg as config file
stapp03 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    }, 
    "changed": false, 
    "ping": "pong"
}
```


---


```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:6311020c7feb7f3feb68a1d1
```

---
```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:6368f45006e401382abb5a60
```
