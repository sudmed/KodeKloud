# Troubleshoot Deployment issues in Kubernetes

Last week, the Nautilus DevOps team deployed a redis app on Kubernetes cluster, which was working fine so far.  
This morning one of the team members was making some changes in this existing setup, but he made some mistakes and the app went down.  
We need to fix this as soon as possible. Please take a look.  
The deployment name is redis-deployment. The pods are not in running state right now, so please look into the issue and fix the same.  
Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.  


## 1. Check existing running deployment and pods 
`kubectl get deployment`  
```shell
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
redis-deployment   0/1     1            0           22s
```

`kubectl get pods`  
```shell
NAME                               READY   STATUS              RESTARTS   AGE
redis-deployment-76cc9c56f-54xx8   0/1     ContainerCreating   0          33s
```

`kubectl get configmap`  
```shell
NAME               DATA   AGE
kube-root-ca.crt   1      43m
redis-config       2      44s
```


## 2. Describe the configuration of the deployment
`kubectl describe deployment`  
```shell
Name:                   redis-deployment
Namespace:              default
CreationTimestamp:      Wed, 17 Aug 2022 15:02:39 +0000
Labels:                 app=redis
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app=redis
Replicas:               1 desired | 1 updated | 1 total | 0 available | 1 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=redis
  Containers:
   redis-container:
    Image:      redis:alpin
    Port:       6379/TCP
    Host Port:  0/TCP
    Requests:
      cpu:        300m
    Environment:  <none>
    Mounts:
      /redis-master from config (rw)
      /redis-master-data from data (rw)
  Volumes:
   data:
    Type:       EmptyDir (a temporary directory that shares a pod's lifetime)
    Medium:     
    SizeLimit:  <unset>
   config:
    Type:      ConfigMap (a volume populated by a ConfigMap)
    Name:      redis-cofig
    Optional:  false
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      False   MinimumReplicasUnavailable
  Progressing    True    ReplicaSetUpdated
OldReplicaSets:  redis-deployment-76cc9c56f (1/1 replicas created)
NewReplicaSet:   <none>
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  54s   deployment-controller  Scaled up replica set redis-deployment-76cc9c56f to 1
```

`kubectl describe configmap`  
```shell
Name:         kube-root-ca.crt
Namespace:    default
Labels:       <none>
Annotations:  <none>

Data
====
ca.crt:
----
-----BEGIN CERTIFICATE-----
MIIC5zCCAc+gAwIBAgIBADANBgkqhkiG9w0BAQsFADAVMRMwEQYDVQQDEwprdWJl
cm5ldGVzMB4XDTIyMDgxNzE0MTgzMFoXDTMyMDgxNDE0MTgzMFowFTETMBEGA1UE
AxMKa3ViZXJuZXRlczCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBANIv
vNzJc7edUkcOLzjdH8FmQlzGwK4atxZoSGwSywoUVZzPiNvWiYdv/3t9QJX0H+HC
UJo8nBxHt+DzeUdLSTAeSUhfM5MmqdLp9+DiFuKLxirhjgc0hLon7dOWmc2AyG6N
Q29x2Pis7dEyMtObav7JaHg1mPI9VO4f//4HakJz3WNdHayyiymt3foH9m6++Blp
7L6PQwT/crj368uSygPF9mebAsHSML5G6B9YfmVwcnuEpT4kOBBii+3zf+ncvDnN
6VTCJpQH0T+R+7fXCc8cQ5u7mfPuwQlK38XL9YnXJS+1vTO1dZNy2PTHNFcCx6Ap
IWdjP2+AM0VGmY2NPO0CAwEAAaNCMEAwDgYDVR0PAQH/BAQDAgKkMA8GA1UdEwEB
/wQFMAMBAf8wHQYDVR0OBBYEFA3iwMFShsj0LgtuMnYyxUr2PKawMA0GCSqGSIb3
DQEBCwUAA4IBAQAm8nlbfY60Yjfeh9Lo/R8OXDfkqOVlm7TFmgiIzMNt4mzdFrLd
xUsiD6mPYZLzSDk3x0fZi3Jgk6HAswVAe/YSx+B7PMjiMoP67f0gB8HjZ68ZWUF2
J1gH/CA/X/sqmGt2xy3GMmiy9lCFD80a7IouOSXIa54UF1vuxQHuTo94EKq0dW+c
O2akplOj5Lr6SmTAOuCUAaMj5EZibPGIS1RIJiX7hGxuLGCXj6dWXCTZjOoidIX1
F74WGYpJ3A/wHLJlCX33N8kp7NYECi2pgva1rPDzU3s9CHh6HN/0XFj6n9AThqXR
+OYIN/BKF3LprMfHavD88e78hMVJU9Lp6xc0
-----END CERTIFICATE-----

Events:  <none>


Name:         redis-config
Namespace:    default
Labels:       <none>
Annotations:  <none>

Data
====
maxmemory-policy:
----
allkeys-lru
maxmemory:
----
2mb
Events:  <none>
```

`kubectl describe pods`  
```shell
Name:           redis-deployment-76cc9c56f-54xx8
Namespace:      default
Priority:       0
Node:           kodekloud-control-plane/172.17.0.2
Start Time:     Wed, 17 Aug 2022 15:02:39 +0000
Labels:         app=redis
                pod-template-hash=76cc9c56f
Annotations:    <none>
Status:         Pending
IP:             
IPs:            <none>
Controlled By:  ReplicaSet/redis-deployment-76cc9c56f
Containers:
  redis-container:
    Container ID:   
    Image:          redis:alpin
    Image ID:       
    Port:           6379/TCP
    Host Port:      0/TCP
    State:          Waiting
      Reason:       ContainerCreating
    Ready:          False
    Restart Count:  0
    Requests:
      cpu:        300m
    Environment:  <none>
    Mounts:
      /redis-master from config (rw)
      /redis-master-data from data (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-7z6km (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             False 
  ContainersReady   False 
  PodScheduled      True 
Volumes:
  data:
    Type:       EmptyDir (a temporary directory that shares a pod's lifetime)
    Medium:     
    SizeLimit:  <unset>
  config:
    Type:      ConfigMap (a volume populated by a ConfigMap)
    Name:      redis-cofig
    Optional:  false
  default-token-7z6km:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-7z6km
    Optional:    false
QoS Class:       Burstable
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                 node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type     Reason       Age                From               Message
  ----     ------       ----               ----               -------
  Normal   Scheduled    92s                default-scheduler  Successfully assigned default/redis-deployment-76cc9c56f-54xx8 to kodekloud-control-plane
  Warning  FailedMount  28s (x8 over 92s)  kubelet            MountVolume.SetUp failed for volume "config" : configmap "redis-cofig" not found
```  


## 3. Fix the issue
`kubectl edit deployment`  
```shell
deployment.apps/redis-deployment edited
```
```bash
--- redis-cofig  
+++ redis-config  
--- redis:alpin  
+++ redis:alpine  
```


## 4. Validate the fix
`kubectl get deploy`  
```shell
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
redis-deployment   1/1     1            1           4m8s
```

`kubectl get pods`  
```shell
NAME                                READY   STATUS    RESTARTS   AGE
redis-deployment-5bb6dd57fd-2p2vs   1/1     Running   0          23s
```

---

```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:62f6ce4f9c4ef352c4733f12
```
