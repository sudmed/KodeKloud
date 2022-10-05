# Deploy Nginx Web Server on Kubernetes Cluster

Some of the Nautilus team developers are developing a static website and they want to deploy it on Kubernetes cluster. They want it to be highly available and scalable. Therefore, based on the requirements, the DevOps team has decided to create a deployment for it with multiple replicas. Below you can find more details about it:  
- Create a deployment using nginx image with latest tag only and remember to mention the tag i.e nginx:latest. Name it as nginx-deployment. The container should be named as nginx-container, also make sure replica counts are 3.  
- Create a NodePort type service named nginx-service. The nodePort should be 30011.  

Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.



## 1. Reconnaissance on the server
`kubectl cluster-info`  
```console
Kubernetes master is running at https://kodekloud-control-plane:6443
KubeDNS is running at https://kodekloud-control-plane:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

`kubectl get all`  
```console
NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   161m
```

`kubectl get namespace`  
```console
NAME                 STATUS   AGE
default              Active   161m
kube-node-lease      Active   161m
kube-public          Active   161m
kube-system          Active   161m
local-path-storage   Active   161m
```

`kubectl get no`  
```console
NAME                      STATUS   ROLES                  AGE    VERSION
kodekloud-control-plane   Ready    control-plane,master   161m   v1.20.5-rc.0.18+c4af4684437b37
```

`kubectl get po`  
```console
No resources found in default namespace.
```

`kubectl get svc`  
```console
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   162m
```

`kubectl get pvc`  
```console
No resources found in default namespace.
```

`kubectl get secret`  
```console
NAME                  TYPE                                  DATA   AGE
default-token-hlvm5   kubernetes.io/service-account-token   3      162m
```


## 2.  Create YAML file
`vi /tmp/nginx.yml`  
```yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
    type: frontend
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
      type: frontend
  template:
    metadata:
      labels:
        app: nginx
        type: frontend
    spec:
      containers:
        - name: nginx-container
          image: nginx:latest

---
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  type: NodePort
  selector:
    app: nginx
    type: frontend
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30011
```


## 3. Run YAML file
`kubectl apply -f /tmp/nginx.yml`  
```console
deployment.apps/nginx-deployment created
service/nginx-service created
```

`kubectl get po`  
```console
NAME                               READY   STATUS    RESTARTS   AGE
nginx-deployment-69c8468d7-2w7t9   1/1     Running   0          16s
nginx-deployment-69c8468d7-75ltt   1/1     Running   0          16s
nginx-deployment-69c8468d7-gn4p5   1/1     Running   0          16s
```


## 4. Validate the task
`kubectl exec nginx-deployment-69c8468d7-2w7t9 -- curl -I http://localhost`  
```console  
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0HTTP/1.1 200 OK
Server: nginx/1.23.1
Date: Wed, 05 Oct 2022 08:17:31 GMT
Content-Type: text/html
Content-Length: 615
Last-Modified: Tue, 19 Jul 2022 14:05:27 GMT
Connection: keep-alive
ETag: "62d6ba27-267"
Accept-Ranges: bytes

  0   615    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
```


`kubectl exec nginx-deployment-69c8468d7-2w7t9 -- curl http://localhost`  
```console  
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   615  100   615    0     0   300k      0 --:--:-- --:--:-- --:--:--  600k
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```

---

```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:633c6785b020001fa820ae42
```
