# Linux Bash Scripts
: '
The production support team of xFusionCorp Industries is working on developing some bash scripts to automate different day to day tasks. 
One is to create a bash script for taking websites backup. They have a static website running on App Server 1 in Stratos Datacenter, and they 
need to create a bash script named ecommerce_backup.sh which should accomplish the following tasks. (Also remember to place the script 
under /scripts directory on App Server 1)
a. Create a zip archive named xfusioncorp_ecommerce.zip of /var/www/html/ecommerce directory.
b. Save the archive in /backup/ on App Server 1. This is a temporary storage, as backups from this location will be clean on weekly basis. 
Therefore, we also need to save this backup archive on Nautilus Backup Server.
c. Copy the created archive to Nautilus Backup Server server in /backup/ location.
d. Please make sure script won't ask for password while copying the archive file. Additionally, the respective server user 
(for example, tony in case of App Server 1) must be able to run it.
'


# Go to the scripts folder and create a backup script
cd /scripts
ll
vi /scripts/ecommerce_backup.sh
+#!/bin/bash
+zip -r /backup/xfusioncorp_ecommerce.zip /var/www/html/ecommerce
+scp /backup/xfusioncorp_ecommerce.zip clint@stbkp01:/backup/

# Create a keygen and copy the key to the backup server so that the bash script will not require any password
ssh-keygen

# Copy the key on the backup server & cross-check login without password prompt
ssh-copy-id clint@stbkp01

# Check
ssh clint@stbkp01

# Go to scripts folder and run the bash scripts by this command
cd /scripts
ll
chmod +x ecommerce_backup.sh
ll
sh ecommerce_backup.sh

# Check the backup folder for the zip file on both app02 and backup server. If you find the zip file then it should be done.
ll /backup
ssh clint@stbkp01
	total 4
	-rw-rw-r-- 1 clint clint 623 May  8 18:33 xfusioncorp_ecommerce.zip
