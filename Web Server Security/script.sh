# Web Server Security
: '
During a recent security audit, the application security team of xFusionCorp Industries found security issues with the Apache web server on Nautilus App Server 1 server in Stratos DC. They have listed several security issues that need to be fixed on this server. Please apply the security settings below:
a. On Nautilus App Server 1 it was identified that the Apache web server is exposing the version number. Ensure this server has the appropriate settings to hide the version number of the Apache web server.
b. There is a website hosted under /var/www/html/media on App Server 1. It was detected that the directory /media lists all of its contents while browsing the URL. Disable the directory browser listing in Apache config.
c. Also make sure to restart the Apache service after making the changes.
'


systemctl status httpd
	inactive (dead)

vi /etc/httpd/conf/httpd.conf
+ServerTokens Prod
+ServerSignature Off
-Options Indexes FollowSymLinks
+Options FollowSymLinks

systemctl start httpd
systemctl status httpd
	active (running) 

# Validate Apache httpd running
curl -I http://stapp01:8080
curl -I http://stapp01:8080/media/
