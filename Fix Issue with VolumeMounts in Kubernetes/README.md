# Fix Issue with VolumeMounts in Kubernetes

We deployed a Nginx and PHPFPM based setup on Kubernetes cluster last week and it had been working fine. This morning one of the team members made a change somewhere which caused some issues, and it stopped working. Please look into the issue and fix it:
- The pod name is nginx-phpfpm and configmap name is nginx-config. Figure out the issue and fix the same.
- Once issue is fixed, copy /home/thor/index.php file from jump host into nginx-container under nginx document root and you should be able to access the website using Website button on top bar.

Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.


## 1. Reconnaissance on the server
`kubectl version`  
```console
Client Version: version.Info{Major:"1", Minor:"19", GitVersion:"v1.19.3", GitCommit:"1e11e4a2108024935ecfcb2912226cedeafd99df", GitTreeState:"clean", BuildDate:"2020-10-14T12:50:19Z", GoVersion:"go1.15.2", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{Major:"1", Minor:"20+", GitVersion:"v1.20.5-rc.0.18+c4af4684437b37", GitCommit:"c4af4684437b378b9becf4c9cfb0e6ec276f69dc", GitTreeState:"clean", BuildDate:"2021-03-09T17:20:53Z", GoVersion:"go1.15.8", Compiler:"gc", Platform:"linux/amd64"}
```

`kubectl config view`  
```console
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://kodekloud-control-plane:6443
  name: kind-kodekloud
contexts:
- context:
    cluster: kind-kodekloud
    user: kind-kodekloud
  name: kind-kodekloud
current-context: kind-kodekloud
kind: Config
preferences: {}
users:
- name: kind-kodekloud
  user:
    client-certificate-data: REDACTED
    client-key-data: REDACTED
    
kubectl config get-contexts
CURRENT   NAME             CLUSTER          AUTHINFO         NAMESPACE
*         kind-kodekloud   kind-kodekloud   kind-kodekloud
```

`kubectl cluster-info`  
```console
Kubernetes master is running at https://kodekloud-control-plane:6443
KubeDNS is running at https://kodekloud-control-plane:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

`kubectl get all -o wide`  
```console
NAME               READY   STATUS    RESTARTS   AGE     IP           NODE                      NOMINATED NODE   READINESS GATES
pod/nginx-phpfpm   2/2     Running   0          2m26s   10.244.0.5   kodekloud-control-plane   <none>           <none>
NAME                    TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)          AGE     SELECTOR
service/kubernetes      ClusterIP   10.96.0.1     <none>        443/TCP          31m     <none>
service/nginx-service   NodePort    10.96.102.6   <none>        8099:30008/TCP   2m26s   app=php-app
```

`kubectl get ns`  
```console
NAME                 STATUS   AGE
default              Active   32m
kube-node-lease      Active   32m
kube-public          Active   32m
kube-system          Active   32m
local-path-storage   Active   32m
```

`kubectl get svc -o wide`  
```console
NAME            TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)          AGE     SELECTOR
kubernetes      ClusterIP   10.96.0.1     <none>        443/TCP          32m     <none>
nginx-service   NodePort    10.96.102.6   <none>        8099:30008/TCP   2m58s   app=php-app
```

`kubectl get no -o wide`  
```console
NAME                      STATUS   ROLES                  AGE   VERSION                          INTERNAL-IP   EXTERNAL-IP   OS-IMAGE       KERNEL-VERSION   CONTAINER-RUNTIME
kodekloud-control-plane   Ready    control-plane,master   32m   v1.20.5-rc.0.18+c4af4684437b37   172.17.0.2    <none>        Ubuntu 20.10   5.4.0-1089-gcp   containerd://1.5.0-beta.0-69-gb3f240206
```

`kubectl get po`  
```console
NAME           READY   STATUS    RESTARTS   AGE
nginx-phpfpm   2/2     Running   0          3m21s
```

`kubectl get deploy`  
```console
No resources found in default namespace.
```

`kubectl get secret`  
```console
NAME                  TYPE                                  DATA   AGE
default-token-j89dv   kubernetes.io/service-account-token   3      32m
```

`kubectl get pv`  
```console
No resources found
```

`kubectl get pvc`  
```console
No resources found in default namespace.
```

`kubectl get configmap`  
```console
NAME               DATA   AGE
kube-root-ca.crt   1      33m
nginx-config       1      4m38s
```

`kubectl describe configmap nginx-config`  
```console
Name:         nginx-config
Namespace:    default
Labels:       <none>
Annotations:  <none>

Data
====
nginx.conf:
----
events {
}
http {
  server {
    listen 8099 default_server;
    listen [::]:8099 default_server;

    # Set nginx to serve files from the shared volume!
    root /var/www/html;
    index  index.html index.htm index.php;
    server_name _;
    location / {
      try_files $uri $uri/ =404;
    }
    location ~ \.php$ {
      include fastcgi_params;
      fastcgi_param REQUEST_METHOD $request_method;
      fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
      fastcgi_pass 127.0.0.1:9000;
    }
  }
}

Events:  <none>
```


## 2. Get YAML file from kubectl utility
`kubectl get pod nginx-phpfpm -o yaml  > /tmp/nginx.yaml`  

### 2.1. Do change `/usr/share/nginx/html` to `/var/www/html` in 3 places



## 3. Replace YAML file
`kubectl replace -f /tmp/nginx.yaml --force`  
```console
pod "nginx-phpfpm" deleted
pod/nginx-phpfpm replaced
```

`kubectl get pods -o wide`  
```console
NAME           READY   STATUS    RESTARTS   AGE   IP           NODE                      NOMINATED NODE   READINESS GATES
nginx-phpfpm   2/2     Running   0          16s   10.244.0.6   kodekloud-control-plane   <none>           <none>
```


## 4. Copy index.php into nginx-container
`cat /home/thor/index.php`  
```console
<?php
phpinfo();
```

`kubectl cp /home/thor/index.php nginx-phpfpm:/var/www/html -c nginx-container`  


## 4. Validate the task
`kubectl exec -it nginx-phpfpm -c nginx-container -- curl -I http://localhost:8099`  
```console
HTTP/1.1 200 OK
Server: nginx/1.23.1
Date: Fri, 14 Oct 2022 20:29:55 GMT
Content-Type: text/html; charset=UTF-8
Connection: keep-alive
X-Powered-By: PHP/7.2.34
```

`(kubectl exec -it nginx-phpfpm -c nginx-container -- curl http://localhost:8099) |more`  
```console
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "DTD/xhtml1-transitional.dtd">
<...>
```

`https://30008-port-e4c260d781a8426e.labs.kodekloud.com/`
```console
PHP Version 7.2.34
System	Linux nginx-phpfpm 5.4.0-1089-gcp #97~18.04.1-Ubuntu SMP Wed Sep 28 03:32:39 UTC 2022 x86_64
Build Date	Dec 11 2020 10:55:35
Configure Command	'./configure' '--build=x86_64-linux-gnu' '--with-config-file-path=/usr/local/etc/php' '--with-config-file-scan-dir=/usr/local/etc/php/conf.d' '--enable-option-checking=fatal' '--with-mhash' '--with-pic' '--enable-ftp' '--enable-mbstring' '--enable-mysqlnd' '--with-password-argon2' '--with-sodium=shared' '--with-pdo-sqlite=/usr' '--with-sqlite3=/usr' '--with-curl' '--with-libedit' '--with-openssl' '--with-zlib' '--with-libdir=lib/x86_64-linux-gnu' '--enable-fpm' '--with-fpm-user=www-data' '--with-fpm-group=www-data' '--disable-cgi' 'build_alias=x86_64-linux-gnu'
Server API	FPM/FastCGI
Virtual Directory Support	disabled
Configuration File (php.ini) Path	/usr/local/etc/php
Loaded Configuration File	(none)
<...>
```

`kubectl describe configmap nginx-config`  
```console
Name:         nginx-config
Namespace:    default
Labels:       <none>
Annotations:  <none>

Data
====
nginx.conf:
----
events {
}
http {
  server {
    listen 8099 default_server;
    listen [::]:8099 default_server;

    # Set nginx to serve files from the shared volume!
    root /var/www/html;
    index  index.html index.htm index.php;
    server_name _;
    location / {
      try_files $uri $uri/ =404;
    }
    location ~ \.php$ {
      include fastcgi_params;
      fastcgi_param REQUEST_METHOD $request_method;
      fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
      fastcgi_pass 127.0.0.1:9000;
    }
  }
}

Events:  <none>
```

`kubectl describe configmap nginx-config`  
```console
Name:         nginx-config
Namespace:    default
Labels:       <none>
Annotations:  <none>

Data
====
nginx.conf:
----
events {
}
http {
  server {
    listen 8099 default_server;
    listen [::]:8099 default_server;

    # Set nginx to serve files from the shared volume!
    root /var/www/html;
    index  index.html index.htm index.php;
    server_name _;
    location / {
      try_files $uri $uri/ =404;
    }
    location ~ \.php$ {
      include fastcgi_params;
      fastcgi_param REQUEST_METHOD $request_method;
      fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
      fastcgi_pass 127.0.0.1:9000;
    }
  }
}

Events:  <none>
```

`kubectl logs nginx-phpfpm nginx-container`  
```console
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
::1 - - [14/Oct/2022:20:29:55 +0000] "HEAD / HTTP/1.1" 200 0 "-" "curl/7.74.0"
::1 - - [14/Oct/2022:20:30:44 +0000] "GET / HTTP/1.1" 200 87950 "-" "curl/7.74.0"
::1 - - [14/Oct/2022:20:31:18 +0000] "GET / HTTP/1.1" 200 87950 "-" "curl/7.74.0"
10.244.0.1 - - [14/Oct/2022:20:31:41 +0000] "GET / HTTP/1.1" 200 95857 "https://e4c260d781a8426e.labs.kodekloud.com/" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36"
10.244.0.1 - - [14/Oct/2022:20:31:41 +0000] "GET /robots.txt HTTP/1.1" 404 555 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36"
10.244.0.1 - - [14/Oct/2022:20:31:41 +0000] "GET /robots.txt HTTP/1.1" 404 555 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36"
```


---


```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:634917de7fafec3c8a84e802
```
