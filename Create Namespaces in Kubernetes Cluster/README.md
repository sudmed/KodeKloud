# Create Namespaces in Kubernetes Cluster



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
