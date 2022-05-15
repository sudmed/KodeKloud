# Add Response Headers in Apache
: '
We are working on hardening Apache web server on all app servers. As a part of this process we want to add some of the Apache response headers for security purpose. We are testing the settings one by one on all app servers. As per details mentioned below enable these headers for Apache:
Install httpd package on App Server 3 using yum and configure it to run on 8084 port, make sure to start its service.
Create an index.html file under Apache's default document root i.e /var/www/html and add below given content in it.
Welcome to the xFusionCorp Industries!
Configure Apache to enable below mentioned headers:
X-XSS-Protection header with value 1; mode=block
X-Frame-Options header with value SAMEORIGIN
X-Content-Type-Options header with value nosniff
Note: You can test using curl on the given app server as LBR URL will not work for this task.
'


sudo -i

# Install httpd
yum install httpd -y

# Edit the configuration file
vi / etc/httpd/conf/httpd.conf
+Listen 6100

# add Header at end
vi / etc/httpd/conf/httpd.conf
Header set X-XSS-Protection "1; mode=block"
Header always append X-Frame-Options SAMEORIGIN
Header set X-Content-Type-Options nosniff

# Create Index file with given content
ll /var/www/html/
vi /var/www/html/index.html
+Welcome to the xFusionCorp Industries!

# Start httpd & check the status
systemctl start httpd && systemctl status httpd

# Validate the task by Curl
curl http://localhost:8083

curl -Ik http://localhost:8083
curl -i http://localhost:8083
X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
 Welcome to the xFusionCorp Industries!
 

CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:6280ec1ab7cd263df6829b46