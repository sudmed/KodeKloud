# Linux LogRotate

# Install the package as per the given task
yum install -y squid
# or yum install -y haproxy

# Navigate to logrotate folder and check existing folder
/etc/logrotate.d/
cat /etc/logrotate.d/squid
# or cat /etc/logrotate.d/haproxy

# As per the task edit log file & save the file
vi /etc/logrotate.d/squid
# or sudo vi /etc/logrotate.d/haproxy

/var/log/squid/*.log {
# or /var/log/haproxy.log {
    monthly
    rotate 3
    compress
    notifempty
    missingok
    nocreate
    sharedscripts
    postrotate
      # Asks squid to reopen its logs. (logfile_rotate 0 is set in squid.conf)
      # errors redirected to make it silent if squid is not running
      /usr/sbin/squid -k rotate 2>/dev/null
      # Wait a little to allow Squid to catch up before the logs is compressed
      sleep 1
    endscript
}


# Start services & check the status
systemctl start squid && systemctl status squid
# or systemctl start haproxy && systemctl status haproxy
