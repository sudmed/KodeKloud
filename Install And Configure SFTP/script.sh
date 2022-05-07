# Install And Configure SFTP
: '
Some of the developers from Nautilus project team have asked for SFTP access to at least one of the app server in Stratos DC. 
After going through the requirements, the system admins team has decided to configure the SFTP server on App Server 1 server in Stratos Datacenter. 
Please configure it as per the following instructions:
a. Create an SFTP user mark and set its password to BruCStnMT5.
b. Password authentication should be enabled for this user.
c. Set its ChrootDirectory to /var/www/appdata.
d. SFTP user should only be allowed to make SFTP connections.
'


sudo -i
useradd mark                                                                                                             
passwd mark
# Password: BruCStnMT5

mkdir -p /var/www/appdata
ll -lsd /var/www/appdata/

chown root:root /var/www
chmod -R 755 /var/www
ll -lsd /var/www/

vi /etc/ssh/sshd_config
-subsystem sftp /usr/libexec/openssh/sftp-server
+Subsystem sftp internal-sftp
+Match User mark
+ForceCommand internal-sftp
+PasswordAuthentication yes
+ChrootDirectory /var/www/appdata
+PermitTunnel no
+AllowTcpForwarding no
+X11Forwarding no
+AllowAgentForwarding no

systemctl restart sshd
systemctl status sshd

# Validate the task by below commands from the jump server
thor@jump_host ~$ sftp mark@stapp01

# Validate the task by below commands from the localhost
[root@stapp03 ~]# sftp mark@localhost

