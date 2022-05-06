# Disable Root Login
: '
After doing some security audits of servers, xFusionCorp Industries security team has implemented some new security policies. 
One of them is to disable direct root login through SSH.
Disable direct SSH root login on all app servers in Stratos Datacenter.
'


sudo vi /etc/ssh/sshd_config

# PermitRootLogin yes
# Remove the "#" and change "yes" to "no" at line

PermitRootLogin no
sudo systemctl restart sshd


# You forgot to remove the hash sign #
```bash
#PermitRootLogin no
```
So the entered value remained commented out.
