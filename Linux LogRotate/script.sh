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

# haproxy task: check if  the haproxy.log exists
ls -l /var/log/haproxy.log
    ls: cannot access /var/log/haproxy.log: No such file or directory

###  by default  there's  no haproxy.log  in /var/log
# to have these messages end up in /var/log/haproxy.log you will
# need to configure  /etc/sysconfig/rsyslog  and   /etc/rsyslog.conf

# edit  /etc/sysconfig/rsyslog:
vi /etc/sysconfig/rsyslog
   #   configure rsyslog to accept network log events.  This is done
   #    add  '-r' option to the SYSLOGD_OPTIONS  
 
# edit  /etc/rsyslog.conf:
vi /etc/rsyslog.conf
    # 1) configure local2 events to go to the /var/log/haproxy.log file
    #  Add  the following line at the end of /etc/rsyslog.conf:
    #    local2.*                       /var/log/haproxy.log
    # 2) uncomment the  following lines(s) preceded  by the line " # Provides UDP syslog reception":   
    #$ModLoad imudp                                                                                                                                       
    #$UDPServerRun 514     

# restart  rsyslog:
systemctl restart rsyslog

# Restart  haproxy  service:
systemctl restart haproxy

# check  haproxy.log again:
ls -l /var/log/haproxy.log
    -rw-------. 1 root root 1553 Jul 31 18:02 /var/log/haproxy.log

# execute logrotate  for  haproxy  with (-v)  option:
logrotate -v  /etc/logrotate.d/haproxy 

Allocating hash table for state file, size 15360 B
Handling 1 logs
rotating pattern: /var/log/haproxy.log  monthly (3 rotations)
empty log files are not rotated, old logs are removed
considering log /var/log/haproxy.log
  log does not need rotating (log has been rotated at 2021-7-31 17:0, that is not month ago yet)
not running postrotate script, since no logs were rotated
set default create context
