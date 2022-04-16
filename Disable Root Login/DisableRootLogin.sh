sudo vi /etc/ssh/sshd_config

# PermitRootLogin yes
# Remove the "#" and change "yes" to "no" at line

PermitRootLogin no
sudo systemctl restart sshd
