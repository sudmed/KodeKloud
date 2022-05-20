# Linux Postfix Mail Server
: '
xFusionCorp Industries has planned to set up a common email server in Stork DC. After several meetings and recommendations they have decided to use 
postfix as their mail transfer agent and dovecot as an IMAP/POP3 server. We would like you to perform the following steps:
Install and configure postfix on Stork DC mail server.
Create an email account mark@stratos.xfusioncorp.com identified by B4zNgHA7Ya.
Set its mail directory to /home/mark/Maildir.
Install and configure dovecot on the same server.
'


ssh groot@stmail01
sudo -i

useradd mark
passwd mark

yum install -y postfix dovecot

vi /etc/postfix/main.cf

# line 76
---#myhostname = virtual.domain.ltd
+++myhostname = stmail01.stratos.xfusioncorp.com

# line 83
---#mydomain = domain.ltd
+++mydomain = stratos.xfusioncorp.com

# line 99
---#myorogin = $mydomain
+++myorogin = $mydomain

# line 116
---inet_interfaces = localhost
+++#inet_interfaces = localhost

# line 113
---#inet_interfaces = all
+++inet_interfaces = all

# line 164
---mydestination = $myhostname, localhost.$mydomain, localhost
+++#mydestination = $myhostname, localhost.$mydomain, localhost

# line 165
---#mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain
+++mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain

# line 264
---#mynetworks = 168.100.189.0/28, 127.0.0.1/8
+++mynetworks = 172.16.238.0/24, 127.0.0.1/8

# line 419
---#home_mailbox = Maildir/
+++home_mailbox = Maildir/


systemctl start postfix
systemctl status postfix

telnet stmail01 25
	EHLO localhost
	mail from:mark@stratos.xfusioncorp.com
	rcpt to:mark@stratos.xfusioncorp.com
	DATA
	test mail
	.
	quit

su - mark
# mailq
cd ~/Maildir
cat new/...file...
	...
	test mail
exit	

# as root again
vi /etc/dovecot/dovecot.conf
# line 24
---#protocols = imap pop3 lmtp
+++protocols = imap pop3 lmtp

vi /etc/dovecot/conf.d/10-mail.conf
# line 24
---#mail_location = maildir:~/Maildir
+++mail_location = maildir:~/Maildir

vi /etc/dovecot/conf.d/10-auth.conf
# line 10
---#disable_plaintext_auth = yes
+++disable_plaintext_auth = yes

# line 100
---auth_mechanisms = plain
+++auth_mechanisms = plain login

vi /etc/dovecot/conf.d/10-master.conf
# line 91
---#user =
+++user = postfix

# line 92
---#group =
+++group = postfix

systemctl start dovecot
systemctl status dovecot

telnet stmail01 110
	user mark
	pass ...
	retr 1
	quit
	
ss -tulnp



CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:6287f411f640a366098d6420
