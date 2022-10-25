# Deploy Apache Web Server on Kubernetes CLuster

There is an application that needs to be deployed on Kubernetes cluster under Apache web server.  
The Nautilus application development team has asked the DevOps team to deploy it. We need to develop a template as per requirements mentioned below:  
- Create a namespace named as httpd-namespace-devops.  
- Create a deployment named as httpd-deployment-devops under newly created namespace. For the deployment use httpd image with latest tag only and remember to mention the tag i.e httpd:latest, and make sure replica counts are 2.  
- Create a service named as httpd-service-devops under same namespace to expose the deployment, nodePort should be 30004.  
Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.  


## 1. Create a namespace
`kubectl get namespace`  
```shell
NAME                 STATUS   AGE
default              Active   18m
kube-node-lease      Active   18m
kube-public          Active   18m
kube-system          Active   18m
local-path-storage   Active   17m
```


`kubectl create namespace httpd-namespace-devops`  
```shell
namespace/httpd-namespace-devops created
```

`kubectl get namespace`  
```shell
NAME                     STATUS   AGE
default                  Active   18m
httpd-namespace-devops   Active   9s
kube-node-lease          Active   18m
kube-public              Active   18m
kube-system              Active   18m
local-path-storage       Active   18m
```

`kubectl get pods -n httpd-namespace-devops`  
```shell
No resources found in httpd-namespace-devops namespace.
```

`kubectl get service -n httpd-namespace-devops`  
```shell
No resources found in httpd-namespace-devops namespace.
```


## 2. Create yaml  file
`vi /tmp/http.yaml`  
```yaml
apiVersion: v1
kind: Service
metadata:
  name: httpd-service-devops
  namespace: httpd-namespace-devops
spec:
  type: NodePort
  selector:
    app: httpd_app_devops
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30004
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: httpd-deployment-devops
  namespace: httpd-namespace-devops
  labels:
    app: httpd_app_devops
spec:
  replicas: 2
  selector:
    matchLabels:
      app: httpd_app_devops
  template:
    metadata:
      labels:
        app: httpd_app_devops
    spec:
      containers:
        - name: httpd-container-devops
          image: httpd:latest
          ports:
            - containerPort: 80
```


## 3. Create a pod
`kubectl create -f /tmp/http.yaml`  
```shell
service/httpd-service-devops created
deployment.apps/httpd-deployment-devops created
```


## 4. Check pod and service
`kubectl get pods -n httpd-namespace-devops`  
```shell
NAME                                      READY   STATUS    RESTARTS   AGE
httpd-deployment-devops-867b499f4-cnjxk   1/1     Running   0          20s
httpd-deployment-devops-867b499f4-fpllb   1/1     Running   0          20s
```

`kubectl get service -n httpd-namespace-devops`  
```shell
NAME                   TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
httpd-service-devops   NodePort   10.96.16.105   <none>        80:30004/TCP   32s
```


# Web preview port selector
`https://30004-port-5646458470f34c90.labs.kodekloud.com/`  
```shell
It works!
```

---

```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:630203225497e86344fe8346
```
