# Deploy Tomcat App on Kubernetes
```
A new java-based application is ready to be deployed on a Kubernetes cluster. The development team had a meeting with the DevOps team to share the requirements and application scope. The team is ready to setup an application stack for it under their existing cluster. 
Below you can find the details for this:
- Create a namespace named tomcat-namespace-datacenter.
- Create a deployment for tomcat app which should be named as tomcat-deployment-datacenter under the same namespace you created. 
- Replica count should be 1, the container should be named as tomcat-container-datacenter, its image should be gcr.io/kodekloud/centos-ssh-enabled:tomcat and its container port should be 8080.
- Create a service for tomcat app which should be named as tomcat-service-datacenter under the same namespace you created.
- Service type should be NodePort and nodePort should be 32227.

Before clicking on Check button please make sure the application is up and running. You can use any labels as per your choice.  
Note: The kubectl on jump_host has been configured to work with the kubernetes cluster.
```


## 1. Reconnaissance on the server
`kubectl get namespace`  
```console
NAME                 STATUS   AGE
default              Active   99m
kube-node-lease      Active   99m
kube-public          Active   99m
kube-system          Active   99m
local-path-storage   Active   99m
```

`kubectl get pods`  
```console
No resources found in default namespace.
```


## 2. Create new namespace
`kubectl create namespace tomcat-namespace-datacenter`  
```console
namespace/tomcat-namespace-datacenter created
```

`kubectl get namespace`  
```console
NAME                          STATUS   AGE
default                       Active   100m
kube-node-lease               Active   100m
kube-public                   Active   100m
kube-system                   Active   100m
local-path-storage            Active   100m
tomcat-namespace-datacenter   Active   15s
```


## 3. Create YAML file
`vi /tmp/tomcat.yaml`  
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: tomcat-deployment-datacenter
  namespace: tomcat-namespace-datacenter
  labels:
    app: tomcat-deployment-datacenter
spec:
  replicas: 1
  selector:
    matchLabels:
      app: tomcat-deployment-datacenter
  template:
    metadata:
      labels:
        app: tomcat-deployment-datacenter
    spec:
      containers:
      - name: tomcat-container-datacenter
        image: gcr.io/kodekloud/centos-ssh-enabled:tomcat
        ports:
        - containerPort: 8080
---        
apiVersion: v1
kind: Service
metadata:
  name: tomcat-service-datacenter
  namespace: tomcat-namespace-datacenter
spec:
  type: NodePort
  selector:
    app: tomcat-deployment-datacenter
  ports:
    - port: 80
      protocol: TCP
      targetPort: 8080
      nodePort: 32227
```


## 4. Run YAML file
`kubectl create -f /tmp/deploy.yaml`  
```console
deployment.apps/tomcat-deployment-datacenter created
service/tomcat-service-datacenter created
```


## 5. Validate the task
`kubectl get pods --all-namespaces`  
```console
NAMESPACE                     NAME                                              READY   STATUS    RESTARTS   AGE
kube-system                   coredns-74ff55c5b-nz56x                           1/1     Running   0          105m
kube-system                   coredns-74ff55c5b-qk8tz                           1/1     Running   0          105m
kube-system                   etcd-kodekloud-control-plane                      1/1     Running   0          105m
kube-system                   kindnet-wjb2f                                     1/1     Running   0          105m
kube-system                   kube-apiserver-kodekloud-control-plane            1/1     Running   1          105m
kube-system                   kube-controller-manager-kodekloud-control-plane   1/1     Running   0          105m
kube-system                   kube-proxy-2qhcj                                  1/1     Running   0          105m
kube-system                   kube-scheduler-kodekloud-control-plane            1/1     Running   0          105m
local-path-storage            local-path-provisioner-78776bfc44-fvccw           1/1     Running   0          105m
tomcat-namespace-datacenter   tomcat-deployment-datacenter-97fc9fcd8-p9l8r      1/1     Running   0          88s
```

`kubectl get svc --all-namespaces`  
```console
NAMESPACE                     NAME                        TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                  AGE
default                       kubernetes                  ClusterIP   10.96.0.1       <none>        443/TCP                  105m
kube-system                   kube-dns                    ClusterIP   10.96.0.10      <none>        53/UDP,53/TCP,9153/TCP   105m
tomcat-namespace-datacenter   tomcat-service-datacenter   NodePort    10.96.153.237   <none>        80:32227/TCP             61s
```

`kubectl get deployments --all-namespaces`  
```console
NAMESPACE                     NAME                           READY   UP-TO-DATE   AVAILABLE   AGE
kube-system                   coredns                        2/2     2            2           105m
local-path-storage            local-path-provisioner         1/1     1            1           105m
tomcat-namespace-datacenter   tomcat-deployment-datacenter   1/1     1            1           77s
```

`kubectl get pods -n tomcat-namespace-datacenter`  
```console
NAME                                           READY   STATUS    RESTARTS   AGE
tomcat-deployment-datacenter-97fc9fcd8-p9l8r   1/1     Running   0          2m20s
```

`kubectl exec tomcat-deployment-datacenter-97fc9fcd8-p9l8r -n tomcat-namespace-datacenter -- curl http://localhost:8080`  
```console  
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0<!DOCTYPE html>
<!--
To change this license header, choose License Headers in Project Properties.
To change this template file, choose Tools | Templates
and open the template in the editor.
-->
<html>
    <head>
        <title>SampleWebApp</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
    </head>
    <body>
        <h2>Welcome to xFusionCorp Industries!</h2>
        <br>
    
    </body>
</html>
100   471  100   471    0     0   1618      0 --:--:-- --:--:-- --:--:--  1618
```

---


```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:62a30a135e6ef78f668a6083
```
