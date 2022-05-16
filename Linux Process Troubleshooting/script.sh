# Linux Process Troubleshooting
: '
The production support team of xFusionCorp Industries has deployed some of the latest monitoring tools to keep an eye on every service, 
application, etc. running on the systems. One of the monitoring systems reported about Apache service unavailability on one of the app 
servers in Stratos DC.
Identify the faulty app host and fix the issue. Make sure Apache service is up and running on all app hosts. They might not hosted any 
code yet on these servers so you need not to worry about if Apache isn't serving any pages or not, just make sure service is up and running. 
Also, make sure Apache is running on port 8087 on all app servers.
'


# At first identify the app server which has issue
telnet stapp01 8087
telnet stapp02 8087
telnet stapp03 8087

# telnet: connect to address 172.16.238.10: Connection refused
# okay, let's repair stapp01

# login on app server
ssh tony@stapp01
sudo -i

# check the existing Apache HTTPd service
systemctl status httpd
	# Address already in use: AH00072: make_sock: could not bind to address 0.0.0.0:8087

# check which service is using your port and whats is PID
netstat -tulnp
	# tcp	0	0 127.0.0.1:8087	0.0.0.0:*	LISTEN	615/sendmail: accep

# kill sendmail
kill 615

# check if it is still running
ps -ef  |grep sendmail

# start apache
systemctl start httpd
systemctl status  httpd
	# Active: active (running) 

# Validate Apache is running as at first
telnet stapp01 8087
	# Trying 172.16.238.10...
	# Connected to stapp01.




48:48
You check 'systemctl status httpd' and start 'systemctl start tomcat' instead of 'systemctl start httpd'. 
