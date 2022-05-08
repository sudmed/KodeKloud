# Linux Services Troubleshooting

# install IPtables service
yum install  -y squid

# Start & enable the squid service
systemctl enable squid
systemctl start squid

# Validate the squid service status
systemctl status squid

# You should execute 3 commands only:
```bash
yum install -y squid
systemctl enable squid
systemctl start squid
```
