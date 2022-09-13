# Create Pods in Kubernetes Cluster

The Nautilus DevOps team has started practicing some pods and services deployment on Kubernetes platform as they are planning to migrate most of their applications on Kubernetes platform. Recently one of the team members has been assigned a task to create a pod as per details mentioned below:  
Create a pod named pod-httpd using httpd image with latest tag only and remember to mention the tag i.e httpd:latest.  
Labels app should be set to httpd_app, also container should be named as httpd-container.  
Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.  


## 1. Reconnaissance on the server
`kubectl get all`  
```console
NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   76m
```

`kubectl get ns`  
```console
NAME                 STATUS   AGE
default              Active   76m
kube-node-lease      Active   76m
kube-public          Active   76m
kube-system          Active   76m
local-path-storage   Active   76m
```

`kubectl get nodes`  
```console
NAME                      STATUS   ROLES                  AGE   VERSION
kodekloud-control-plane   Ready    control-plane,master   76m   v1.20.5-rc.0.18+c4af4684437b37
```

`kubectl get pods`  
```console
No resources found in default namespace.
```


## 2. Create YAML file
`vi /tmp/pod.yaml`  
```yaml
apiVersion: v1
kind: Pod
metadata:
    name: pod-httpd
    labels:
      app: httpd_app
spec:
    containers:
    - name: httpd-container
      image: httpd:latest
```


## 3. Run YAML file
`kubectl apply -f /tmp/pod.yaml`  
```console
pod/pod-httpd created
```


## 4. Validate the task
`kubectl get pods`  
```console
NAME        READY   STATUS              RESTARTS   AGE
pod-httpd   0/1     ContainerCreating   0          11s
```

---


```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:631facd35bc665127cd04ffb
```
