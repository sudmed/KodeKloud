# Create a Cron Job

: 'The Nautilus system admins team has prepared scripts to automate several day-to-day tasks. 
They want them to be deployed on all app servers in Stratos DC on a set schedule. 
Before that they need to test similar functionality with a sample cron job. 
Therefore, perform the steps below:
a. Install cronie package on all Nautilus app servers and start crond service.
b. Add a cron */5 * * * * echo hello > /tmp/cron_text for root user.
'


yum install cronie -y
systemctl enable crond
systemctl start crond
systemctl status crond
crontab -e
crontab -l
  */5 * * * * echo hello > /tmp/cron_text
ll /tmp/
