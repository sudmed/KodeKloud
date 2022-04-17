systemctl status postfix
journalctl -xe -u postfix
vi /etc/postfix/main.cf
	#inet_interfaces = localhost	
systemctl restart postfix
