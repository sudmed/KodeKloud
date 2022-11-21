# Apache Redirects

The Nautilus devops team got some requirements related to some Apache config changes. They need to setup some redirects for some URLs. There might be some more changes need to be done. Below you can find more details regarding that:
- httpd is already installed on app server 2. 
- Configure Apache to listen on port 5003.  
- Configure Apache to add some redirects as mentioned below:  
	- a) Redirect http://stapp02.stratos.xfusioncorp.com:<Port>/ to http://www.stapp02.stratos.xfusioncorp.com:<Port>/ i.e non www to www. This must be a permanent redirect i.e 301.  
	- b) Redirect http://www.stapp02.stratos.xfusioncorp.com:<Port>/blog/ to http://www.stapp02.stratos.xfusioncorp.com:<Port>/news/. This must be a temporary redirect i.e 302.  


## 1. Check if httpd is already installed 
`rpm -qa | grep httpd`  
```console
httpd-tools-2.4.6-90.el7.centos.x86_64
httpd-2.4.6-90.el7.centos.x86_64
```


## 2. Configure Apache to listen on port 5003
`cat /etc/httpd/conf/httpd.conf | grep Listen`  
```console
-Listen 8080
+Listen 5003
```

## 3. Configure Apache to add some redirects
`cat /etc/httpd/conf/httpd.conf | grep redirect`  
```console
# 1) plain text 2) local redirects 3) external redirects
```

`vi /etc/httpd/conf/httpd.conf`  
```console
Listen 5003
```

`vi /etc/httpd/conf.d/main.conf`  
```console
<VirtualHost *:5003>
ServerName stapp02.stratos.xfusioncorp.com
Redirect 301 / http://www.stapp02.stratos.xfusioncorp.com:5003/
</VirtualHost>
<VirtualHost *:5003>
ServerName www.stapp02.stratos.xfusioncorp.com:5003/blog/
Redirect 302 /blog/ http://www.stapp02.stratos.xfusioncorp.com:5003/news/
</VirtualHost>
```

`systemctl restart httpd`  
`systemctl status  httpd`  

	
## 4. Validate the task
`curl http://stapp02.stratos.xfusioncorp.com:5003/`  
```console
The document has moved <a href="http://www.stapp02.stratos.xfusioncorp.com:5003/">here</a>
```

`curl http://www.stapp02.stratos.xfusioncorp.com:5003`  
```console
The document has moved <a href="http://www.stapp02.stratos.xfusioncorp.com:5003/news/">here</a>
```	

`curl http://www.stapp02.stratos.xfusioncorp.com:5003/news/`  
```console
404 Not Found
```  

#### Try to use ServerName directive without http:// scheme.
