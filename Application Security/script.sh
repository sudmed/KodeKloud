# Application Security
: '
We have a backup management application UI hosted on Nautilus's backup server in Stratos DC. 
That backup management application code is deployed under Apache on the backup server itself, and Nginx is running as a reverse proxy on the same server. 
Apache and Nginx ports are 6000 and 8094, respectively. We have iptables firewall installed on this server. 
Make the appropriate changes to fulfill the requirements mentioned below:
We want to open all incoming connections to Nginx's port and block all incoming connections to Apache's port. 
Also make sure rules are permanent.
'


# Login on Backup server &  Switch to  root user. Password: H@wk3y3
ssh clint@stbkp01
sudo -i

# Check Iptables service is running or not
systemctl status iptables

# If inactive (dead)
systemctl start iptables
systemctl status iptables

# Add these two rules
iptables -A INPUT -p tcp --dport 8094 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --dport 6000 -m conntrack --ctstate NEW -j REJECT

# Then save it by typing following command
sudo iptables-save > /etc/sysconfig/iptables

# Now, check if the rules are added or not
cat /etc/sysconfig/iptables

# Save iptable rules
service iptables save


# There is can be some default Rule 5 to Reject all request check & change to ICMP
# Checking it
iptables -L --line-numbers
# If exist that
	5    REJECT     all  --  anywhere             anywhere             reject-with icmp-host-prohibited
# Do this command
iptables -R INPUT 5 -p icmp -j REJECT
# and checking it again
iptables -L --line-numbers
	5    REJECT     icmp --  anywhere             anywhere             reject-with icmp-port-unreachable
# Save iptable rules again
service iptables save

# Validate Ngnix port reachable from JumpServer
telnet stbkp01 6000
	Trying 172.16.238.16...
	telnet: connect to address 172.16.238.16: Connection refused

# Validate Ngnix port reachable from JumpServer as per the task request
telnet stbkp01 8094
	Trying 172.16.238.16...
	Connected to stbkp01.
	Escape character is '^]'.
  
