# IPtables Installation And Configuration

: '
We have one of our websites up and running on our Nautilus infrastructure in Stratos DC. 
Our security team has raised a concern that right now Apache’s port i.e 8081 is open for all since there is no firewall installed on these hosts. 
So we have decided to add some security layer for these hosts and after discussions and recommendations we have come up with the following requirements:
Install iptables and all its dependencies on each app host.
Block incoming port 8081 on all apps for everyone except for LBR host.
Make sure the rules remain, even after system reboot.
'

sudo -i
yum install iptables-services -y
systemctl start iptables
systemctl enable iptables

# iptables -A INPUT -p tcp --destination-port 8081 -s 172.16.238.14 -j ACCEPT
# iptables -A INPUT -p tcp --destination-port 8081 -j DROP
# iptables -L --line-numbers
# iptables -R INPUT 5 -p icmp -j REJECT
# service iptables save
# systemctl restart iptables && systemctl status iptables

iptables -A INPUT -p TCP --dport 8081 -j DROP
iptables -A INPUT -p TCP --source stlb01 --dport 8081 -j ACCEPT
service iptables save
systemctl enable --now iptables


# Do drop, then accept.
iptables -A INPUT -p TCP --dport 8081 -j DROP
iptables -A INPUT -p TCP --source stlb01 --dport 8081 -j ACCEPT
