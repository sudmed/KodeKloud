# Create Deployments in Kubernetes Cluster

The Nautilus DevOps team has started practicing some pods, and services deployment on Kubernetes platform, as they are planning to migrate most of their applications on Kubernetes. Recently one of the team members has been assigned a task to create a deploymnt as per details mentioned below:
- Create a deployment named httpd to deploy the application httpd using the image httpd:latest (remember to mention the tag as well)

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
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   79m   <none>
```

`kubectl get ns`  
```console
NAME                 STATUS   AGE
default              Active   79m
kube-node-lease      Active   79m
kube-public          Active   79m
kube-system          Active   79m
local-path-storage   Active   79m
```

`kubectl get no`  
```console
NAME                      STATUS   ROLES                  AGE   VERSION
kodekloud-control-plane   Ready    control-plane,master   79m   v1.20.5-rc.0.18+c4af4684437b37
```

`kubectl get po`  
```console
No resources found in default namespace.
```

`kubectl get deploy`  
```console
No resources found in default namespace.
```


## 2. Create the deployment
`kubectl create deploy httpd --image httpd:latest`  
```console
deployment.apps/httpd created
```

`kubectl get deploy`  
```console
NAME    READY   UP-TO-DATE   AVAILABLE   AGE
httpd   1/1     1            1           23s
```


## 3. Validate the task
`kubectl get po`  
```console
NAME                    READY   STATUS    RESTARTS   AGE
httpd-84898796c-hfx2m   1/1     Running   0          33s
```

`kubectl describe pod httpd-84898796c-hfx2m`  
```console
Name:         httpd-84898796c-hfx2m
Namespace:    default
Priority:     0
Node:         kodekloud-control-plane/172.17.0.2
Start Time:   Mon, 24 Oct 2022 19:23:27 +0000
Labels:       app=httpd
              pod-template-hash=84898796c
Annotations:  <none>
Status:       Running
IP:           10.244.0.5
IPs:
  IP:           10.244.0.5
Controlled By:  ReplicaSet/httpd-84898796c
Containers:
  httpd:
    Container ID:   containerd://08b3d13d890ed22b796dffaa7051fe2a076575064043bc43b6fc51e890a44ff8
    Image:          httpd:latest
    Image ID:       docker.io/library/httpd@sha256:4400fb49c9d7d218d3c8109ef721e0ec1f3897028a3004b098af587d565f4ae5
    Port:           <none>
    Host Port:      <none>
    State:          Running
      Started:      Mon, 24 Oct 2022 19:23:39 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-9jwj7 (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             True 
  ContainersReady   True 
  PodScheduled      True 
Volumes:
  default-token-9jwj7:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-9jwj7
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                 node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  51s   default-scheduler  Successfully assigned default/httpd-84898796c-hfx2m to kodekloud-control-plane
  Normal  Pulling    50s   kubelet            Pulling image "httpd:latest"
  Normal  Pulled     39s   kubelet            Successfully pulled image "httpd:latest" in 10.765580138s
  Normal  Created    39s   kubelet            Created container httpd
  Normal  Started    39s   kubelet            Started container httpd
```

`kubectl exec -it httpd-84898796c-hfx2m -- curl -I localhost`  
```console
HTTP/1.1 200 OK
Date: Mon, 24 Oct 2022 19:26:53 GMT
Server: Apache/2.4.54 (Unix)
Last-Modified: Mon, 11 Jun 2007 18:53:14 GMT
ETag: "2d-432a5e4a73a80"
Accept-Ranges: bytes
Content-Length: 45
Content-Type: text/html
```

`kubectl exec -it httpd-84898796c-hfx2m -- curl localhost`  
```html
<html><body><h1>It works!</h1></body></html>
```

---

```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:6356b7685b6b326941261a96
```
