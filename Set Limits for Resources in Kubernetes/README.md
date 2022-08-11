# Set Limits for Resources in Kubernetes

Recently some of the performance issues were observed with some applications hosted on Kubernetes cluster. The Nautilus DevOps team has observed some resources constraints, where some of the applications are running out of resources like memory, cpu etc., and some of the applications are consuming more resources than needed. Therefore, the team has decided to add some limits for resources utilization. Below you can find more details.
Create a pod named httpd-pod and a container under it named as httpd-container, use httpd image with latest tag only and remember to mention tag i.e httpd:latest and set the following limits:
Requests: Memory: 15Mi, CPU: 100m
Limits: Memory: 20Mi, CPU: 100m
Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.


## 1. Configure kubectl utility
`kubectl get namespace`  
```shell
NAME                 STATUS   AGE
default              Active   38m
kube-node-lease      Active   38m
kube-public          Active   38m
kube-system          Active   38m
local-path-storage   Active   38m
```

`kubectl get pods`
```shell
No resources found in default namespace.
```


## 2. Create yaml file
`vi /tmp/limit.yaml`  

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: httpd-pod
spec:
  containers:
  - name: httpd-container
    image: httpd:latest
    resources:
      requests:
        memory: "15Mi"
        cpu: "100m"
      limits:
        memory: "20Mi"
        cpu: "100m"
```


## 3. Create a pod
`kubectl create -f /tmp/limit.yaml`  
```shell
pod/httpd-pod created
```

`kubectl get pods`  
```shell
httpd-pod   1/1     Running   0          27s
```


## 4. Validate the task
`kubectl describe pods httpd-pod`  
```shell
Name:         httpd-pod
Namespace:    default
Priority:     0
Node:         kodekloud-control-plane/172.17.0.2
Start Time:   Thu, 11 Aug 2022 21:01:53 +0000
Labels:       <none>
Annotations:  <none>
Status:       Running
IP:           10.244.0.5
IPs:
  IP:  10.244.0.5
Containers:
  httpd-container:
    Container ID:   containerd://58a62b1f69c45bbdd7b873dd1a6203c8a2f460cce8932f09e0c36696262eeba5
    Image:          httpd:latest
    Image ID:       docker.io/library/httpd@sha256:343452ec820a5d59eb3ab9aaa6201d193f91c3354f8c4f29705796d9353d4cc6
    Port:           <none>
    Host Port:      <none>
    State:          Running
      Started:      Thu, 11 Aug 2022 21:02:12 +0000
    Ready:          True
    Restart Count:  0
    Limits:
      cpu:     100m
      memory:  20Mi
    Requests:
      cpu:        100m
      memory:     15Mi
    Environment:  <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-6fs5s (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             True 
  ContainersReady   True 
  PodScheduled      True 
Volumes:
  default-token-6fs5s:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-6fs5s
    Optional:    false
QoS Class:       Burstable
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                 node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  30s   default-scheduler  Successfully assigned default/httpd-pod to kodekloud-control-plane
  Normal  Pulling    27s   kubelet            Pulling image "httpd:latest"
  Normal  Pulled     12s   kubelet            Successfully pulled image "httpd:latest" in 15.44026759s
  Normal  Created    12s   kubelet            Created container httpd-container
  Normal  Started    11s   kubelet            Started container httpd-container
```

---

```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:62eed731abbd44f127bd999c
```
