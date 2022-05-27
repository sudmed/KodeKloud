# IPtables Installation And Configuration
: '
We have one of our websites up and running on our Nautilus infrastructure in Stratos DC. Our security team has raised a concern that right now 
Apache’s port i.e 3001 is open for all since there is no firewall installed on these hosts. So we have decided to add some security layer for these hosts 
and after discussions and recommendations we have come up with the following requirements:
Install iptables and all its dependencies on each app host.
Block incoming port 3001 on all apps for everyone except for LBR host.
Make sure the rules remain, even after system reboot.
'


sudo -i
yum install iptables-services -y
systemctl start iptables
systemctl enable iptables
systemctl status iptables

iptables -R INPUT 5 -p tcp --dport 3001 -s 172.16.238.14 -j ACCEPT
iptables -A INPUT -p tcp --dport 3001 -j DROP
service iptables save
systemctl enable --now iptables

# validate the task from LBP server
curl -Ik 172.16.238.10:3001
curl -Ik 172.16.238.11:3001
curl -Ik 172.16.238.12:3001


CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:628961abd7baf4c4b496bffe



# Change the order and the method of adding rules based on when you started iptables service.
```bash
systemctl start iptables && systemctl enable iptables
iptables -I INPUT -p tcp --dport 5000 -j DROP
iptables -I INPUT -p tcp --dport 5000 -s 172.16.238.14 -j ACCEPT
```
Then save and do for other servers. Good luck on retry. Be mindful adding the correct port.
