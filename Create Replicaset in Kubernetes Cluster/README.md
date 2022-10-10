# Create Replicaset in Kubernetes Cluster

The Nautilus DevOps team is going to deploy some applications on kubernetes cluster as they are planning to migrate some of their existing applications there. Recently one of the team members has been assigned a task to write a template as per details mentioned below:
- Create a ReplicaSet using nginx image with latest tag only and remember to mention tag i.e nginx:latest and name it as nginx-replicaset.
- Labels app should be nginx_app, labels type should be front-end. The container should be named as nginx-container; also make sure replicas counts are 4.

Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.



## 1. Reconnaissance on the server
`kubectl cluster-info`  
```console
Kubernetes master is running at https://kodekloud-control-plane:6443
KubeDNS is running at https://kodekloud-control-plane:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

`kubectl get all -o wide`  
```console
NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE   SELECTOR
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   99m   <none>
```

`kubectl get ns`  
```console
NAME                 STATUS   AGE
default              Active   99m
kube-node-lease      Active   99m
kube-public          Active   99m
kube-system          Active   99m
local-path-storage   Active   99m
```

`kubectl get svc -o wide`  
```console
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE   SELECTOR
kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   99m   <none>
```

`kubectl get no -o wide`  
```console
NAME                      STATUS   ROLES                  AGE    VERSION                          INTERNAL-IP   EXTERNAL-IP   OS-IMAGE       KERNEL-VERSION   CONTAINER-RUNTIME
kodekloud-control-plane   Ready    control-plane,master   100m   v1.20.5-rc.0.18+c4af4684437b37   172.17.0.2    <none>        Ubuntu 20.10   5.4.0-1089-gcp   containerd://1.5.0-beta.0-69-gb3f240206
```

`kubectl get po`  
```console
No resources found in default namespace.
```

`kubectl get pv`  
```console
No resources found
```

`kubectl get pvc`  
```console
No resources found in default namespace.
```

`kubectl get deploy`  
```console
No resources found in default namespace.
```

`kubectl get secret`  
```console
NAME                  TYPE                                  DATA   AGE
default-token-2dpc6   kubernetes.io/service-account-token   3      100m
```


## 2. Create YAML file
`vi /tmp/nginx.yaml`  
```yaml
---
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: nginx-replicaset
  labels:
    app: nginx_app
    type: front-end
spec:
  replicas: 4
  selector:
    matchLabels:
      app: nginx_app
  template:
    metadata:
      labels:
        app: nginx_app
        type: front-end
    spec:
      containers:
        - name: nginx-container
          image: nginx:latest
```


## 3. Run YAML file
`kubectl apply -f /tmp/nginx.yaml`  
```console
replicaset.apps/nginx-replicaset created
```

`kubectl get pods`  
```console
NAME                     READY   STATUS    RESTARTS   AGE
nginx-replicaset-8z7zl   1/1     Running   0          21s
nginx-replicaset-clw5p   1/1     Running   0          21s
nginx-replicaset-pqnbs   1/1     Running   0          21s
nginx-replicaset-q5bgr   1/1     Running   0          21s
```

## 4. Validate the task
`kubectl exec nginx-replicaset-q5bgr -- curl -I localhost`  
```console  
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0   615    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
HTTP/1.1 200 OK
Server: nginx/1.23.1
Date: Mon, 10 Oct 2022 16:20:39 GMT
Content-Type: text/html
Content-Length: 615
Last-Modified: Tue, 19 Jul 2022 14:05:27 GMT
Connection: keep-alive
ETag: "62d6ba27-267"
Accept-Ranges: bytes
```

`kubectl exec nginx-replicaset-q5bgr -- curl -k localhost`  
```console
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0<!DOCTYPE html>
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
100   615  100   615    0     0   600k      0 --:--:-- --:--:-- --:--:--  600k
```

`kubectl exec nginx-replicaset-q5bgr -- curl -Is localhost`  
```console
HTTP/1.1 200 OK
Server: nginx/1.23.1
Date: Mon, 10 Oct 2022 16:24:38 GMT
Content-Type: text/html
Content-Length: 615
Last-Modified: Tue, 19 Jul 2022 14:05:27 GMT
Connection: keep-alive
ETag: "62d6ba27-267"
Accept-Ranges: bytes
```

`kubectl exec nginx-replicaset-q5bgr -- curl -Is localhost | head -n 2`  
```console
HTTP/1.1 200 OK
Server: nginx/1.23.1
```


---

```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:6344426855ffc92b9363b5d8
```
