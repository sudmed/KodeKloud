# Deploy Nginx and Phpfpm on Kubernetes

The Nautilus Application Development team is planning to deploy one of the php-based application on Kubernetes cluster.  
As per discussion with DevOps team they have decided to use nginx and phpfpm. Additionally, they shared some custom configuration requirements.  
Below you can find more details. Please complete the task as per requirements mentioned below:  
1) Create a service to expose this app, the service type must be NodePort, nodePort should be 30012.  
2) Create a config map nginx-config for nginx.conf as we want to add some custom settings for nginx.conf.  
a) Change default port 80 to 8097 in nginx.conf.  
b) Change default document root /usr/share/nginx to /var/www/html in nginx.conf.  
c) Update directory index to index index.html index.htm index.php in nginx.conf.  
3) Create a pod named nginx-phpfpm.  
b) Create a shared volume shared-files that will be used by both containers (nginx and phpfpm) also it should be a emptyDir volume.  
c) Map the ConfigMap we declared above as a volume for nginx container. Name the volume as nginx-config-volume, mount path should be /etc/nginx/nginx.conf and subPath should be nginx.conf.  
d) Nginx container should be named as nginx-container and it should use nginx:latest image. PhpFPM container should be named as php-fpm-container and it should use php:7.2-fpm image.  
e) The shared volume shared-files should be mounted at /var/www/html location in both containers. Copy /opt/index.php from jump host to the nginx document root inside nginx container, once done you can access the app using App button on the top bar.  
Before clicking on finish button always make sure to check if all pods are in running state.  
You can use any labels as per your choice.  
Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.  


## 1. Get configuration
`kubectl get configmap`  
```console
NAME               DATA   AGE
kube-root-ca.crt   1      132m
```

`kubectl get all`  
```console
NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   133m
```

`kubectl get pods`  
```console
No resources found in default namespace.
```


## 2. Create YAML file
`vi /tmp/nginx.yaml`  

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-config
data:
  nginx.conf: |
    events {} 
    http {
      server {
        listen 8097;
        index index.html index.htm index.php;
        root  /var/www/html;
        location ~ \.php$ {
          include fastcgi_params;
          fastcgi_param REQUEST_METHOD $request_method;
          fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
          fastcgi_pass 127.0.0.1:9000;
        }
      }
    }
---
apiVersion: v1
kind: Pod
metadata:
  name: nginx-phpfpm
  labels:
    app: nginx-phpfpm
spec:
  volumes:
    - name: shared-files
      emptyDir: {}
    - name: nginx-config-volume
      configMap:
        name: nginx-config
  containers:
    - name: nginx-container
      image: nginx:latest
      volumeMounts:
        - name: shared-files
          mountPath: /var/www/html
        - name: nginx-config-volume
          mountPath: /etc/nginx/nginx.conf
          subPath: nginx.conf
    - name: php-fpm-container
      image: php:7.2-fpm
      volumeMounts:
        - name: shared-files
          mountPath: /var/www/html
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-phpfpm
spec:
   type: NodePort
   selector:
     app: nginx-phpfpm
   ports:
     - port: 8097
       targetPort: 8097
       nodePort: 30012
```


## 3. Create a pod
`kubectl apply -f /tmp/nginx.yaml`
```console
configmap/nginx-config created
pod/nginx-phpfpm created
service/nginx-phpfpm created
```

`kubectl get pods`  
```console
NAME           READY   STATUS    RESTARTS   AGE
nginx-phpfpm   2/2     Running   0          56s
```


## 4. Validate the task
`kubectl cp /opt/index.php nginx-phpfpm:/var/www/html/ --container=nginx-container`  

`kubectl exec -it nginx-phpfpm -- /bin/bash`  
`> echo "<?phpinfo();?>" > /var/www/html/index.php`  
`> curl http://localhost:8097`  


---

```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:63170d09597469c3a52e4cfa
```
