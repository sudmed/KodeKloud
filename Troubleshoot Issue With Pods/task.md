# Troubleshoot Issue With Pods

One of the junior DevOps team members was working on to deploy a stack on Kubernetes cluster. Somehow the pod is not coming up and its failing with some errors. We need to fix this as soon as possible. Please look into it.  
There is a pod named webserver and the container under it is named as httpd-container. It is using image httpd:latest.  
There is a sidecar container as well named sidecar-container which is using ubuntu:latest image.  
Look into the issue and fix it, make sure pod is in running state and you are able to access the app.  
Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.  


## 1. Configure kubectl
`kubectl get pods`
```console
NAME        READY   STATUS             RESTARTS   AGE
webserver   1/2     ImagePullBackOff   0          28s
```


## 2. Let's see the problem
`kubectl describe pod webserver`
```console
Name:         webserver
Namespace:    default
Priority:     0
Node:         kodekloud-control-plane/172.17.0.2
Start Time:   Tue, 19 Jul 2022 12:32:20 +0000
Labels:       app=web-app
Annotations:  <none>
Status:       Pending
IP:           10.244.0.5
IPs:
  IP:  10.244.0.5
Containers:
  httpd-container:
    Container ID:   
    Image:          httpd:latests
    Image ID:       
    Port:           <none>
    Host Port:      <none>
    State:          Waiting
      Reason:       ErrImagePull
    Ready:          False
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/log/httpd from shared-logs (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-46b8c (ro)
  sidecar-container:
    Container ID:  containerd://e9ea6dc314f1a270ee784b310a0592237bcb6addf43cc37e2b17209ddda8325d
    Image:         ubuntu:latest
    Image ID:      docker.io/library/ubuntu@sha256:b6b83d3c331794420340093eb706a6f152d9c1fa51b262d9bf34594887c2c7ac
    Port:          <none>
    Host Port:     <none>
    Command:
      sh
      -c
      while true; do cat /var/log/httpd/access.log /var/log/httpd/error.log; sleep 30; done
    State:          Running
      Started:      Tue, 19 Jul 2022 12:32:31 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/log/httpd from shared-logs (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-46b8c (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             False 
  ContainersReady   False 
  PodScheduled      True 
Volumes:
  shared-logs:
    Type:       EmptyDir (a temporary directory that shares a pod's lifetime)
    Medium:     
    SizeLimit:  <unset>
  default-token-46b8c:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-46b8c
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                 node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type     Reason     Age                From               Message
  ----     ------     ----               ----               -------
  Normal   Scheduled  44s                default-scheduler  Successfully assigned default/webserver to kodekloud-control-plane
  Normal   Pulling    41s                kubelet            Pulling image "ubuntu:latest"
  Normal   Pulled     35s                kubelet            Successfully pulled image "ubuntu:latest" in 6.442003872s
  Normal   Created    35s                kubelet            Created container sidecar-container
  Normal   Started    33s                kubelet            Started container sidecar-container
  Normal   Pulling    17s (x2 over 42s)  kubelet            Pulling image "httpd:latests"
  Warning  Failed     16s (x2 over 41s)  kubelet            Failed to pull image "httpd:latests": rpc error: code = NotFound desc = failed to pull and unpack image "docker.io/library/httpd:latests": failed to resolve reference "docker.io/library/httpd:latests": docker.io/library/httpd:latests: not found
  Warning  Failed     16s (x2 over 41s)  kubelet            Error: ErrImagePull
  Normal   BackOff    5s (x3 over 33s)   kubelet            Back-off pulling image "httpd:latests"
  Warning  Failed     5s (x3 over 33s)   kubelet            Error: ImagePullBackOff
```


## 3. Resolve images issue
`kubectl edit pod webserver`
#### there was a typo "httpd:latests"
```console
# Please edit the object below. Lines beginning with a '#' will be ignored,
# and an empty file will abort the edit. If an error occurs while saving this file will be
# reopened with the relevant failures.
#
apiVersion: v1
kind: Pod
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"v1","kind":"Pod","metadata":{"annotations":{},"labels":{"app":"web-app"},"name":"webserver","namespace":"default"},"spec":{"containers":[{"image":"httpd:latests","name":"httpd-container","volumeMounts":[{"mountPath":"/var/log/httpd","name":"shared-logs"}]},{"command":["sh","-c","while true; do cat /var/log/httpd/access.log /var/log/httpd/error.log; sleep 30; done"],"image":"ubuntu:latest","name":"sidecar-container","volumeMounts":[{"mountPath":"/var/log/httpd","name":"shared-logs"}]}],"volumes":[{"emptyDir":{},"name":"shared-logs"}]}}
  creationTimestamp: "2022-07-19T12:32:20Z"
  labels:
    app: web-app
  name: webserver
  namespace: default
  resourceVersion: "15523"
  uid: ef34984c-86fd-40a9-90d9-15410b2ba0cc
spec:
  containers:
  - image: httpd:latest
    imagePullPolicy: IfNotPresent
    name: httpd-container
    resources: {}
    terminationMessagePath: /dev/termination-log
    terminationMessagePolicy: File
    volumeMounts:
    - mountPath: /var/log/httpd
      name: shared-logs
    - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
      name: default-token-46b8c
      readOnly: true
  - command:
    - sh
    - -c
    - while true; do cat /var/log/httpd/access.log /var/log/httpd/error.log; sleep
      30; done
    image: ubuntu:latest
    imagePullPolicy: Always
    name: sidecar-container
    resources: {}
    terminationMessagePath: /dev/termination-log
    terminationMessagePolicy: File
    volumeMounts:
    - mountPath: /var/log/httpd
      name: shared-logs
    - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
```


## 4. Get running status
`kubectl get pods`
```console
NAME        READY   STATUS    RESTARTS   AGE
webserver   2/2     Running   0          2m50s
```

`kubectl describe pod webserver`
```console
Name:         webserver
Namespace:    default
Priority:     0
Node:         kodekloud-control-plane/172.17.0.2
Start Time:   Tue, 19 Jul 2022 12:32:20 +0000
Labels:       app=web-app
Annotations:  <none>
Status:       Running
IP:           10.244.0.5
IPs:
  IP:  10.244.0.5
Containers:
  httpd-container:
    Container ID:   containerd://f574518ea7163b5601385aa8382bce8faa78055cf0fbfc6f69a6d3aaf79c4055
    Image:          httpd:latest
    Image ID:       docker.io/library/httpd@sha256:75d370e19ec2a456b6c80110fe30694ffcd98fc85151a578e14334a51eb94578
    Port:           <none>
    Host Port:      <none>
    State:          Running
      Started:      Tue, 19 Jul 2022 12:33:49 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/log/httpd from shared-logs (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-46b8c (ro)
  sidecar-container:
    Container ID:  containerd://e9ea6dc314f1a270ee784b310a0592237bcb6addf43cc37e2b17209ddda8325d
    Image:         ubuntu:latest
    Image ID:      docker.io/library/ubuntu@sha256:b6b83d3c331794420340093eb706a6f152d9c1fa51b262d9bf34594887c2c7ac
    Port:          <none>
    Host Port:     <none>
    Command:
      sh
      -c
      while true; do cat /var/log/httpd/access.log /var/log/httpd/error.log; sleep 30; done
    State:          Running
      Started:      Tue, 19 Jul 2022 12:32:31 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/log/httpd from shared-logs (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-46b8c (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             True 
  ContainersReady   True 
  PodScheduled      True 
Volumes:
  shared-logs:
    Type:       EmptyDir (a temporary directory that shares a pod's lifetime)
    Medium:     
    SizeLimit:  <unset>
  default-token-46b8c:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-46b8c
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                 node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type     Reason     Age                   From               Message
  ----     ------     ----                  ----               -------
  Normal   Scheduled  3m4s                  default-scheduler  Successfully assigned default/webserver to kodekloud-control-plane
  Normal   Pulling    3m2s                  kubelet            Pulling image "ubuntu:latest"
  Normal   Pulled     2m56s                 kubelet            Successfully pulled image "ubuntu:latest" in 6.442003872s
  Normal   Created    2m56s                 kubelet            Created container sidecar-container
  Normal   Started    2m54s                 kubelet            Started container sidecar-container
  Normal   Pulling    2m15s (x3 over 3m3s)  kubelet            Pulling image "httpd:latests"
  Warning  Failed     2m14s (x3 over 3m2s)  kubelet            Failed to pull image "httpd:latests": rpc error: code = NotFound desc = failed to pull and unpack image "docker.io/library/httpd:latests": failed to resolve reference "docker.io/library/httpd:latests": docker.io/library/httpd:latests: not found
  Warning  Failed     2m14s (x3 over 3m2s)  kubelet            Error: ErrImagePull
  Normal   BackOff    110s (x5 over 2m54s)  kubelet            Back-off pulling image "httpd:latests"
  Warning  Failed     110s (x5 over 2m54s)  kubelet            Error: ImagePullBackOff
  Normal   Pulling    106s                  kubelet            Pulling image "httpd:latest"
  Normal   Pulled     96s                   kubelet            Successfully pulled image "httpd:latest" in 10.015774768s
```


 
```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:62d5cabc13e7f3b983976565
```
