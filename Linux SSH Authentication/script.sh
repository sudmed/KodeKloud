# Linux SSH Authentication
: '
The system admins team of xFusionCorp Industries has set up some scripts on jump host that run on regular intervals and perform operations on all app servers in Stratos Datacenter. To make these scripts work properly we need to make sure thor user on jump host has password-less SSH access to all app servers through their respective sudo users. Based on the requirements, perform the following:
Set up a password-less authentication from user thor on jump host to all app servers through their respective sudo users.
'


ssh-keygen -t rsa -b 4096 -C "thor"

ssh-copy-id tony@172.16.238.10
	# Ir0nM@n

ssh-copy-id steve@172.16.238.11
	# Am3ric@

ssh-copy-id banner@172.16.238.12
	# BigGr33n
  
