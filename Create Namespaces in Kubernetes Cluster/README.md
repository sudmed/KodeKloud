# Create Namespaces in Kubernetes Cluster

The Nautilus DevOps team is planning to deploy some micro services on Kubernetes platform. The team has already set up a Kubernetes cluster and now they want set up some namespaces, deployments etc. Based on the current requirements, the team has shared some details as below:
Create a namespace named dev and create a POD under it; name the pod dev-nginx-pod and use nginx image with latest tag only and remember to mention tag i.e nginx:latest.
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
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   98m
```

`kubectl get ns`  
```console
NAME                 STATUS   AGE
default              Active   98m
kube-node-lease      Active   98m
kube-public          Active   98m
kube-system          Active   98m
local-path-storage   Active   98m
```

`kubectl get no`  
```console
NAME                      STATUS   ROLES                  AGE   VERSION
kodekloud-control-plane   Ready    control-plane,master   99m   v1.20.5-rc.0.18+c4af4684437b37
```

`kubectl get po`  
```console
No resources found in default namespace.
```


## 2. Create new namespace
`kubectl create ns dev`  
```console
namespace/dev created
```

`kubectl get ns`  
```console
NAME                 STATUS   AGE
default              Active   100m
dev                  Active   26s
kube-node-lease      Active   100m
kube-public          Active   100m
kube-system          Active   100m
local-path-storage   Active   100m
```


## 3. Create YAML file
`vi /tmp/pod.yaml`  

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: dev-nginx-pod
  namespace: dev
spec:
  containers:
    - name: nginx-container
      image: nginx:latest
      ports:
        - name: web
          containerPort: 80
          protocol: TCP
```


## 4. Run YAML file
`kubectl apply -f /tmp/pod.yaml`  
```console
pod/dev-nginx-pod created
```


## 5. Validate the task
`kubectl get po -n dev`  
```console
NAME            READY   STATUS    RESTARTS   AGE
dev-nginx-pod   1/1     Running   0          55s
```

`kubectl describe po dev-nginx-pod -n dev`  
```console
Name:         dev-nginx-pod
Namespace:    dev
Priority:     0
Node:         kodekloud-control-plane/172.17.0.2
Start Time:   Wed, 14 Sep 2022 16:46:45 +0000
Labels:       <none>
Annotations:  <none>
Status:       Running
IP:           10.244.0.5
IPs:
  IP:  10.244.0.5
Containers:
  nginx-container:
    Container ID:   containerd://9b1f13f5ccd73f7ed47f133cb78971aba4e66aa2cec1dd891303a9aea458c550
    Image:          nginx:latest
    Image ID:       docker.io/library/nginx@sha256:0b970013351304af46f322da1263516b188318682b2ab1091862497591189ff1
    Port:           80/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Wed, 14 Sep 2022 16:46:57 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-lsvwn (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             True 
  ContainersReady   True 
  PodScheduled      True 
Volumes:
  default-token-lsvwn:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-lsvwn
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                 node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age    From               Message
  ----    ------     ----   ----               -------
  Normal  Scheduled  2m57s  default-scheduler  Successfully assigned dev/dev-nginx-pod to kodekloud-control-plane
  Normal  Pulling    2m56s  kubelet            Pulling image "nginx:latest"
  Normal  Pulled     2m46s  kubelet            Successfully pulled image "nginx:latest" in 10.013783178s
  Normal  Created    2m46s  kubelet            Created container nginx-container
  Normal  Started    2m45s  kubelet            Started container nginx-container
```


---
## A job well-done congratulations:
### Experience cost: 500


```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:6321ed3f00d6ef2dcfd99474
```

---

```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:638f75df5da940a495c310e7
```
