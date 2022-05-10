# Linux Postfix Mail Server

### postfix
yum install postfix -y
vi /etc/postfix/main.cf
-#myhostname = virtual.domain.ltd
+myhostname = stmail01.stratos.xfusioncorp.com
-#mydomain = virtual.domain.ltd
+mydomain = stratos.xfusioncorp.com
-#myorigin = $mydomain
+myorigin = $mydomain
-inet_interfaces = localhost
+#inet_interfaces = localhost
-#inet_interfaces = all
+inet_interfaces = all
-mydestination = $myhostname, localhost.$mydomain, localhost
+#mydestination = $myhostname, localhost.$mydomain, localhost
-#mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain
+mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain
-#mynetworks = 168.100.189.0/28, 127.0.0.0/8
+mynetworks = 172.16.238.0/24, 127.0.0.0/8
-#home_mailbox = Maildir/
+home_mailbox = Maildir/

systemctl start postfix
systemctl status postfix

useradd ammar
passwd ammar
cat /etc/passwd | grep ammar
ll /home/ammar/

# validate the postfix by telnet command
telnet stmail01 25
>EHLO localhost
250-...
>mail from:john@stratos.xfusioncorp.com
250-... OK
>rcpt to:john@stratos.xfusioncorp.com
250-... OK
>DATA
354...
>test mail
250 ... OK
>quit

su - ammar
mailq
cd Maildir/
cat new/...
	test mail
# exit from user ammar
exit

### dovecot
yum install dovecot -y
vi /etc/dovecot/dovecot.conf
-#protocols = imap pop3 lmtp
+protocols = imap pop3 lmtp

vi /etc/dovecot/conf.d/10-mail.conf
-# mail_location = maildir:~/Maildir
+ mail_location = maildir:~/Maildir

vi /etc/dovecot/conf.d/10-auth.conf
-#disable_plaintext_auth = yes
+disable_plaintext_auth = yes
-#auth_mechanisms = plain
+auth_mechanisms = plain login

vi /etc/dovecot/conf.d/10-master.conf
-#user =
+user = postfix
-#group =
+group = postfix

systemctl start dovecot
systemctl status dovecot

# validate dovecot with telnet
telnet atmail01 110
	+OK
>user ammar
	+OK
> pass TmPcZjtRQx
	+OK Logged in.
>retr 1
	+OK 513 octets
>quit
	+OK Loggin out.
	
ss -tulnp
# тут будут показаны открытые порты почты
