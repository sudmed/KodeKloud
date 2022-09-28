# Deploy Nagios on Kubernetes

The Nautilus DevOps team is planning to set up a Nagios monitoring tool to monitor some applications, services etc. They are planning to deploy it on Kubernetes cluster. Below you can find more details.  
1) Create a deployment nagios-deployment for Nagios core. The container name must be nagios-container and it must use jasonrivers/nagios image.
2) Create a user and password for the Nagios core web interface, user must be xFusionCorp and password must be LQfKeWWxWD. (you can manually perform this step after deployment)
3) Create a service nagios-service for Nagios, which must be of targetPort type. nodePort must be 30008.

You can use any labels as per your choice.  
Note: The kubectl on jump_host has been configured to work with the kubernetes cluster.



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
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   50m
```

`kubectl get pods`  
```console
No resources found in default namespace.
```

`kubectl get deploy`  
```console
No resources found in default namespace.
```

`kubectl get services`  
```console
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   50m
```


## 2. Create YAML file
`vi nagios.yaml`  

```yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nagios-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nagios-core
  template:
    metadata:
      labels:
        app: nagios-core
    spec:
      containers:
        - name: nagios-container
          image: jasonrivers/nagios
---
apiVersion: v1
kind: Service
metadata:
  name: nagios-service
spec:
  type: NodePort
  selector:
    app: nagios-core
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30008
```


## 3. Run YAML file
`kubectl apply -f nagios.yaml`  
```console
deployment.apps/nagios-deployment created
service/nagios-service created
```


## 4. Get running status
`kubectl get deploy`  
```console
NAME                READY   UP-TO-DATE   AVAILABLE   AGE
nagios-deployment   1/1     1            1           44s
```

`kubectl get pods`  
```console
NAME                                 READY   STATUS    RESTARTS   AGE
nagios-deployment-6674945696-7xlqb   1/1     Running   0          54s
```

`kubectl describe pods`  
```console
Name:         nagios-deployment-6674945696-7xlqb
Namespace:    default
Priority:     0
Node:         kodekloud-control-plane/172.17.0.2
Start Time:   Wed, 28 Sep 2022 19:53:25 +0000
Labels:       app=nagios-core
              pod-template-hash=6674945696
Annotations:  <none>
Status:       Running
IP:           10.244.0.5
IPs:
  IP:           10.244.0.5
Controlled By:  ReplicaSet/nagios-deployment-6674945696
Containers:
  nagios-container:
    Container ID:   containerd://46b0b5110bcaf31cb92bb23d7cdb31af1a410d2cdf9542f4957987ca62d69eba
    Image:          jasonrivers/nagios
    Image ID:       docker.io/jasonrivers/nagios@sha256:d7696a34ac0508268ddd104a9ddc102c198c9ce567531ad6e876e9572c0a64fb
    Port:           <none>
    Host Port:      <none>
    State:          Running
      Started:      Wed, 28 Sep 2022 19:54:02 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-vvkhp (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             True 
  ContainersReady   True 
  PodScheduled      True 
Volumes:
  default-token-vvkhp:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-vvkhp
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                 node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  109s  default-scheduler  Successfully assigned default/nagios-deployment-6674945696-7xlqb to kodekloud-control-plane
  Normal  Pulling    108s  kubelet            Pulling image "jasonrivers/nagios"
  Normal  Pulled     72s   kubelet            Successfully pulled image "jasonrivers/nagios" in 35.847447514s
  Normal  Created    72s   kubelet            Created container nagios-container
  Normal  Started    72s   kubelet            Started container nagios-container
```


## 5. Set user & password for Nagios on pod
`kubectl exec -it nagios-deployment-6674945696-7xlqb -- bash`  

`cat /opt/nagios/etc/htpasswd.users`  
```console
nagiosadmin:{SHA}/i0Kels0lRtuw8RhhPHtPq4ZRZ0=
```

`htpasswd /opt/nagios/etc/htpasswd.users xFusionCorp`  
```console
# enter new password: LQfKeWWxWD
```

`cat /opt/nagios/etc/htpasswd.users`  
```console
nagiosadmin:{SHA}/i0Kels0lRtuw8RhhPHtPq4ZRZ0=
xFusionCorp:$apr1$.DN2NhUh$fGE5p1fbprjA38WWV/Xb1/
```


## 7. Validate the task
```console
curl -I https://30008-port-8bfccd7ef0a54aac.labs.kodekloud.com/
HTTP/2 401 
content-type: text/html; charset=iso-8859-1
www-authenticate: Basic realm="Nagios Access"
x-cloud-trace-context: 6635c3b77a1aa5be1b6b20312cc67629
date: Wed, 28 Sep 2022 19:59:32 GMT
server: Google Frontend
via: 1.1 google
alt-svc: h3=":443"; ma=2592000,h3-29=":443"; ma=2592000
```

`curl -I https://xFusionCorp:LQfKeWWxWD@30008-port-8bfccd7ef0a54aac.labs.kodekloud.com/`  
```console
HTTP/2 200 
content-type: text/html; charset=UTF-8
date: Wed, 28 Sep 2022 20:00:48 GMT
server: Google Frontend
via: 1.1 google
alt-svc: h3=":443"; ma=2592000,h3-29=":443"; ma=2592000
```

```console
Nagios® Core™
Version 4.4.7
April 14, 2022
```

`curl -I -u xFusionCorp:LQfKeWWxWD https://30008-port-8bfccd7ef0a54aac.labs.kodekloud.com/`  
```console
HTTP/2 200 
content-type: text/html; charset=UTF-8
date: Wed, 28 Sep 2022 20:04:42 GMT
server: Google Frontend
via: 1.1 google
alt-svc: h3=":443"; ma=2592000,h3-29=":443"; ma=2592000
```

---

```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:63349aa1a5a5192d391bcff5
```
