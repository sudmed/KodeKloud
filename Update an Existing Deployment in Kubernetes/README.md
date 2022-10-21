# Update an Existing Deployment in Kubernetes

There is an application deployed on Kubernetes cluster. Recently, the Nautilus application development team developed a new version of the application that needs to be deployed now. As per new updates some new changes need to be made in this existing setup. So update the deployment and service as per details mentioned below:

We already have a deployment named nginx-deployment and service named nginx-service. Some changes need to be made in this deployment and service, make sure not to delete the deployment and service.
1.) Change the service nodeport from 30008 to 32165
2.) Change the replicas count from 1 to 5
3.) Change the image from nginx:1.17 to nginx:latest
Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.



## 1. Reconnaissance on the server
`kubectl cluster-info`  
```console
Kubernetes master is running at https://kodekloud-control-plane:6443
KubeDNS is running at https://kodekloud-control-plane:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

`kubectl version`  
```console
Client Version: version.Info{Major:"1", Minor:"19", GitVersion:"v1.19.3", GitCommit:"1e11e4a2108024935ecfcb2912226cedeafd99df", GitTreeState:"clean", BuildDate:"2020-10-14T12:50:19Z", GoVersion:"go1.15.2", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{Major:"1", Minor:"20+", GitVersion:"v1.20.5-rc.0.18+c4af4684437b37", GitCommit:"c4af4684437b378b9becf4c9cfb0e6ec276f69dc", GitTreeState:"clean", BuildDate:"2021-03-09T17:20:53Z", GoVersion:"go1.15.8", Compiler:"gc", Platform:"linux/amd64"}
```

`kubectl get ns`  
```console
NAME                 STATUS   AGE
default              Active   92m
kube-node-lease      Active   92m
kube-public          Active   92m
kube-system          Active   92m
local-path-storage   Active   92m
```

`kubectl get all -o wide`  
```console
NAME                                    READY   STATUS    RESTARTS   AGE   IP           NODE                      NOMINATED NODE   READINESS GATES
pod/nginx-deployment-576b8f48fb-wplcr   1/1     Running   0          57s   10.244.0.5   kodekloud-control-plane   <none>           <none>

NAME                    TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE   SELECTOR
service/kubernetes      ClusterIP   10.96.0.1       <none>        443/TCP        92m   <none>
service/nginx-service   NodePort    10.96.186.203   <none>        80:30008/TCP   57s   app=nginx-app

NAME                               READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS        IMAGES       SELECTOR
deployment.apps/nginx-deployment   1/1     1            1           57s   nginx-container   nginx:1.17   app=nginx-app

NAME                                          DESIRED   CURRENT   READY   AGE   CONTAINERS        IMAGES       SELECTOR
replicaset.apps/nginx-deployment-576b8f48fb   1         1         1       57s   nginx-container   nginx:1.17   app=nginx-app,pod-template-hash=576b8f48fb
```

`kubectl get svc -o wide`  
```console
NAME            TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE   SELECTOR
kubernetes      ClusterIP   10.96.0.1       <none>        443/TCP        93m   <none>
nginx-service   NodePort    10.96.186.203   <none>        80:30008/TCP   69s   app=nginx-app
```

`kubectl get no -o wide`  
```console
NAME                      STATUS   ROLES                  AGE   VERSION                          INTERNAL-IP   EXTERNAL-IP   OS-IMAGE       KERNEL-VERSION   CONTAINER-RUNTIME
kodekloud-control-plane   Ready    control-plane,master   93m   v1.20.5-rc.0.18+c4af4684437b37   172.17.0.2    <none>        Ubuntu 20.10   5.4.0-1089-gcp   containerd://1.5.0-beta.0-69-gb3f240206
```

`kubectl get po`  
```console
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-576b8f48fb-wplcr   1/1     Running   0          91s
```

`kubectl get deploy`  
```console
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   1/1     1            1           103s
```

`kubectl get pv`  
```console
No resources found
```

`kubectl get pvc`  
```console
No resources found in default namespace.
```

`kubectl get secret`  
```console
NAME                  TYPE                                  DATA   AGE
default-token-df9w9   kubernetes.io/service-account-token   3      93m
```

`kubectl describe deploy`  
```console
Name:                   nginx-deployment
Namespace:              default
CreationTimestamp:      Fri, 21 Oct 2022 08:17:06 +0000
Labels:                 app=nginx-app
                        type=front-end
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app=nginx-app
Replicas:               1 desired | 1 updated | 1 total | 1 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=nginx-app
  Containers:
   nginx-container:
    Image:        nginx:1.17
    Port:         <none>
    Host Port:    <none>
    Environment:  <none>
    Mounts:       <none>
  Volumes:        <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  <none>
NewReplicaSet:   nginx-deployment-576b8f48fb (1/1 replicas created)
Events:
  Type    Reason             Age    From                   Message
  ----    ------             ----   ----                   -------
  Normal  ScalingReplicaSet  2m28s  deployment-controller  Scaled up replica set nginx-deployment-576b8f48fb to 1
```


## 2. Edit the service
`kubectl edit service nginx-service`  
```bash
    30008 -> 32165
    30008 -> 32165
service/nginx-service edited
```


`kubectl get service`  
```console
NAME            TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
kubernetes      ClusterIP   10.96.0.1       <none>        443/TCP        100m
nginx-service   NodePort    10.96.186.203   <none>        80:32165/TCP   8m32s
```

`kubectl get po`  
```console
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-576b8f48fb-wplcr   1/1     Running   0          8m47s
```



## 3. Edit the deployment
`kubectl get deploy`  
```console
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   1/1     1            1           10m
```

`kubectl edit deploy nginx-deployment`  
```console
    nginx:1.17 -> nginx:latest
deployment.apps/nginx-deployment edited
```

`kubectl get deploy`  
```console
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   5/5     5            5           11m
```

`kubectl get pods`  
```console
NAME                               READY   STATUS    RESTARTS   AGE
nginx-deployment-c7ff8fb84-8z75l   1/1     Running   0          22s
nginx-deployment-c7ff8fb84-r782c   1/1     Running   0          39s
nginx-deployment-c7ff8fb84-t4bf9   1/1     Running   0          39s
nginx-deployment-c7ff8fb84-th49g   1/1     Running   0          20s
nginx-deployment-c7ff8fb84-v95r6   1/1     Running   0          39s
```


`kubectl describe deploy`  
```console
Name:                   nginx-deployment
Namespace:              default
CreationTimestamp:      Fri, 21 Oct 2022 08:17:06 +0000
Labels:                 app=nginx-app
                        type=front-end
Annotations:            deployment.kubernetes.io/revision: 2
Selector:               app=nginx-app
Replicas:               5 desired | 5 updated | 5 total | 5 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=nginx-app
  Containers:
   nginx-container:
    Image:        nginx:latest
    Port:         <none>
    Host Port:    <none>
    Environment:  <none>
    Mounts:       <none>
  Volumes:        <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  <none>
NewReplicaSet:   nginx-deployment-c7ff8fb84 (5/5 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  12m   deployment-controller  Scaled up replica set nginx-deployment-576b8f48fb to 1
  Normal  ScalingReplicaSet  61s   deployment-controller  Scaled up replica set nginx-deployment-576b8f48fb to 5
  Normal  ScalingReplicaSet  61s   deployment-controller  Scaled up replica set nginx-deployment-c7ff8fb84 to 2
  Normal  ScalingReplicaSet  61s   deployment-controller  Scaled down replica set nginx-deployment-576b8f48fb to 4
  Normal  ScalingReplicaSet  61s   deployment-controller  Scaled up replica set nginx-deployment-c7ff8fb84 to 3
  Normal  ScalingReplicaSet  44s   deployment-controller  Scaled down replica set nginx-deployment-576b8f48fb to 3
  Normal  ScalingReplicaSet  44s   deployment-controller  Scaled up replica set nginx-deployment-c7ff8fb84 to 4
  Normal  ScalingReplicaSet  42s   deployment-controller  Scaled down replica set nginx-deployment-576b8f48fb to 2
  Normal  ScalingReplicaSet  42s   deployment-controller  Scaled up replica set nginx-deployment-c7ff8fb84 to 5
  Normal  ScalingReplicaSet  41s   deployment-controller  Scaled down replica set nginx-deployment-576b8f48fb to 1
  Normal  ScalingReplicaSet  38s   deployment-controller  (combined from similar events): Scaled down replica set nginx-deployment-576b8f48fb to 0
```



## 5. Validate the task
https://32165-port-8be30dd260bb4585.labs.kodekloud.com/
```html
Welcome to nginx!
```

`kubectl exec -it nginx-deployment-c7ff8fb84-8z75l -- curl -I localhost`  
```console
HTTP/1.1 200 OK
Server: nginx/1.23.2
Date: Fri, 21 Oct 2022 08:30:56 GMT
Content-Type: text/html
Content-Length: 615
Last-Modified: Wed, 19 Oct 2022 07:56:21 GMT
Connection: keep-alive
ETag: "634fada5-267"
Accept-Ranges: bytes
```console



---


```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:6352527076c439c63ea78775
```
