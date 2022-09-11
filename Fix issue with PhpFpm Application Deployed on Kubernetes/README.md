# Fix issue with PhpFpm Application Deployed on Kubernetes

We deployed a Nginx and PHPFPM based application on Kubernetes cluster last week and it had been working fine. This morning one of the team members was troubleshooting an issue with this stack and he was supposed to run Nginx welcome page for now on this stack till issue with phpfpm is fixed but he made a change somewhere which caused some issue and the application stopped working. Please look into the issue and fix the same:  
The deployment name is nginx-phpfpm-dp and service name is nginx-service. Figure out the issues and fix them. FYI Nginx is configured to use default http port, node port is 30008 and copy index.php under /tmp/index.php to deployment under /var/www/html. Please do not try to delete/modify any other existing components like deployment name, service name etc.  
Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.  


## 1. Check existing nodes, pods, deployment, configmap, services
`kubectl cluster-info`  
```console
Kubernetes master is running at https://kodekloud-control-plane:6443
KubeDNS is running at https://kodekloud-control-plane:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

`kubectl get nodes`  
```console
NAME                      STATUS   ROLES                  AGE   VERSION
kodekloud-control-plane   Ready    control-plane,master   75m   v1.20.5-rc.0.18+c4af4684437b37
```

`kubectl get pods`  
```console
NAME                               READY   STATUS    RESTARTS   AGE
nginx-phpfpm-dp-5cccd45499-8kzws   2/2     Running   0          108s
```

`kubectl get deploy`  
```console
NAME              READY   UP-TO-DATE   AVAILABLE   AGE
nginx-phpfpm-dp   1/1     1            1           119s
```

`kubectl get cm`  
```console
NAME               DATA   AGE
kube-root-ca.crt   1      75m
nginx-config       1      2m11s
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
    listen 80 default_server;
    listen [::]:80 default_server;

    # Set nginx to serve files from the shared volume!
    root /var/www/html;
    index  index.html index.htm;
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

`kubectl get svc`  
```console
NAME            TYPE           CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
kubernetes      ClusterIP      10.96.0.1      <none>        443/TCP          77m
nginx-service   LoadBalancer   10.96.56.146   <pending>     8098:30008/TCP   3m33s
```

`kubectl describe services`  
```console
Name:              kubernetes
Namespace:         default
Labels:            component=apiserver
                   provider=kubernetes
Annotations:       <none>
Selector:          <none>
Type:              ClusterIP
IP:                10.96.0.1
Port:              https  443/TCP
TargetPort:        6443/TCP
Endpoints:         172.17.0.2:6443
Session Affinity:  None
Events:            <none>


Name:                     nginx-service
Namespace:                default
Labels:                   app=nginx-fpm
Annotations:              <none>
Selector:                 app=nginx-fpm,tier=frontend
Type:                     LoadBalancer
IP:                       10.96.56.146
Port:                     <unset>  8098/TCP
TargetPort:               8098/TCP
NodePort:                 <unset>  30008/TCP
Endpoints:                10.244.0.5:8098
Session Affinity:         None
External Traffic Policy:  Cluster
Events:                   <none>
```

`kubectl logs nginx-phpfpm-dp-5cccd45499-8kzws -c nginx-container`  
```console
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
```

`kubectl logs nginx-phpfpm-dp-5cccd45499-8kzws -c php-fpm-container`  
```console
[11-Sep-2022 20:28:27] NOTICE: fpm is running, pid 1
[11-Sep-2022 20:28:27] NOTICE: ready to handle connections
```


## 2. Edit errors in service (change container port from 8092 to 80)
`kubectl edit service nginx-service`  
service/nginx-service edited


## 3. Edit error in configmap (add index.php into default_server)
`kubectl edit cm nginx-config`  
```console
# Please edit the object below. Lines beginning with a '#' will be ignored,
# and an empty file will abort the edit. If an error occurs while saving this file will be
# reopened with the relevant failures.
#
apiVersion: v1
data:
  nginx.conf: |
    events {
    }
    http {
      server {
        listen 80 default_server;
        listen [::]:80 default_server;

        # Set nginx to serve files from the shared volume!
        root /var/www/html;
        index index.php index.html index.htm;
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
kind: ConfigMap
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"v1","data":{"nginx.conf":"events {\n}\nhttp {\n  server {\n    listen 80 default_server;\n    listen [::]:80 default_server;\n\n    # Set nginx to serve files from the shared volume!\n    root /var/www/html;\n    index  index.html index.htm;\n    server_name _;\n    location / {\n      try_files $uri $uri/ =404;\n    }\n    location ~ \\.php$ {\n      include fastcgi_params;\n      fastcgi_param REQUEST_METHOD $request_method;\n      fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;\n      fastcgi_pass 127.0.0.1:9000;\n    }\n  }\n}\n"},"kind":"ConfigMap","metadata":{"annotations":{},"name":"nginx-config","namespace":"default"}}
  creationTimestamp: "2022-09-11T20:48:25Z"
  name: nginx-config
  namespace: default
  resourceVersion: "10475"
  uid: eedf8c8b-726f-4e9c-a1ac-731aff54ee68
```  


## 4. Delete old pod for recreate it
`kubectl delete pod nginx-phpfpm-dp-5cccd45499-8kzws`  
```console
pod "nginx-phpfpm-dp-5cccd45499-8kzws" deleted
```

`kubectl get pods`  
```console
NAME                               READY   STATUS    RESTARTS   AGE
nginx-phpfpm-dp-5cccd45499-z9hrq   2/2     Running   0          37s
```


## 5. Copy php file in nginx container
`kubectl cp /tmp/index.php nginx-phpfpm-dp-5cccd45499-z9hrq:/var/www/html -c nginx-container`  


## 6. Validate the task
`kubectl exec -it nginx-phpfpm-dp-5cccd45499-8kzws -c nginx-container -- bash`  
```console
# ls /var/www/html  
index.php  

cat /var/www/html/index.php
```console
<?php

// Show all information, defaults to INFO_ALL
phpinfo();

// Show just the module information.
// phpinfo(8) yields identical results.
phpinfo(INFO_MODULES);

?>
```


---

```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:631e311bca40a0aa6a21a076
```
