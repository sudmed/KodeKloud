# ReplicationController in Kubernetes

The Nautilus DevOps team wants to create a ReplicationController to deploy several pods. They are going to deploy applications on these pods, these applications need highly available infrastructure. Below you can find exact details, create the ReplicationController accordingly.  
Create a ReplicationController using nginx image, preferably with latest tag, and name it as nginx-replicationcontroller.  
Labels app should be nginx_app, and labels type should be front-end. The container should be named as nginx-container and also make sure replica counts are 3.  
All pods should be running state after deployment.  
Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.  


## 1. Check existing deployment and pods
`kubectl get namespace`
```console
NAME                 STATUS   AGE
default              Active   70m
kube-node-lease      Active   71m
kube-public          Active   71m
kube-system          Active   71m
local-path-storage   Active   70m
```

`kubectl get pods`
```console
No resources found in default namespace.
```


## 2. Create yaml file
`vi /tmp/replica.yaml`
```yaml
apiVersion: v1
kind: ReplicationController
metadata:
  name: nginx-replicationcontroller
  labels:
    app: nginx_app
    type: front-end
spec:
  replicas: 3
  selector:
    app: nginx_app
  template:
    metadata:
      name: nginx_pod
      labels:
        app: nginx_app
        type: front-end
    spec:
      containers:
      - name: nginx-container
        image: nginx:latest
        ports:
        - containerPort: 80
```


## 3. Create a pod
`kubectl create -f /tmp/replica.yaml`
```console
replicationcontroller/nginx-replicationcontroller created
```


## 4. Get pod status
`kubectl get pods`
```console
NAME                                READY   STATUS    RESTARTS   AGE
nginx-replicationcontroller-5pdg4   1/1     Running   0          34s
nginx-replicationcontroller-pzb29   1/1     Running   0          34s
nginx-replicationcontroller-rbg6r   1/1     Running   0          34s
```


## 5. Validate the task
`kubectl exec nginx-replicationcontroller-rbg6r  -- curl http://localhost`
```console
% Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   615  100   615    0     0   8092      0 --:--:-- --:--:-- --:--:--  8092
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


`kubectl exec nginx-replicationcontroller-rbg6r  -- curl -Ik http://localhost`
```console  
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0HTTP/1.1 200 OK
Server: nginx/1.23.1
Date: Mon, 01 Aug 2022 07:20:54 GMT
Content-Type: text/html
Content-Length: 615
Last-Modified: Tue, 19 Jul 2022 14:05:27 GMT
Connection: keep-alive
ETag: "62d6ba27-267"
Accept-Ranges: bytes

  0   615    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
```  
  
  
```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:62e2c163fc56cd5ef20249cb
```
