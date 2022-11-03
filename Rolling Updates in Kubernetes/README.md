# Rolling Updates in Kubernetes

We have an application running on Kubernetes cluster using nginx web server. The Nautilus application development team has pushed some of the latest changes and those changes need be deployed.  
The Nautilus DevOps team has created an image nginx:1.19 with the latest changes.  
Perform a rolling update for this application and incorporate nginx:1.19 image. The deployment name is nginx-deployment.  
Make sure all pods are up and running after the update.  
Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.


## 1. Check existing deployment and pods
`kubectl get deploy`
```console
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   3/3     3            3           22s
```

`kubectl get pods`
```console
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-74fb588559-25w5v   1/1     Running   0          32s
nginx-deployment-74fb588559-749wv   1/1     Running   0          32s
nginx-deployment-74fb588559-xf2bb   1/1     Running   0          32s
```


## 2. Set container image
`kubectl describe deployment nginx-deployment`
```console
Name:                   nginx-deployment
Namespace:              default
CreationTimestamp:      Tue, 28 Jun 2022 14:49:48 +0000
Labels:                 app=nginx-app
                        type=front-end
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app=nginx-app
Replicas:               3 desired | 3 updated | 3 total | 3 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=nginx-app
  Containers:
   nginx-container:
    Image:        nginx:1.16
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
NewReplicaSet:   nginx-deployment-74fb588559 (3/3 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  44s   deployment-controller  Scaled up replica set nginx-deployment-74fb588559 to 3
```
  
`kubectl set image deployment nginx-deployment nginx-container=nginx:1.19`
```console
deployment.apps/nginx-deployment image updated
```


## 3. Ckeck for deployment and pods are running again
`kubectl get pods`
```console
NAME                                READY   STATUS              RESTARTS   AGE
nginx-deployment-57bf6d6978-g9rmv   0/1     ContainerCreating   0          12s
nginx-deployment-74fb588559-25w5v   1/1     Running             0          76s
nginx-deployment-74fb588559-749wv   1/1     Running             0          76s
nginx-deployment-74fb588559-xf2bb   1/1     Running             0          76s
```

`kubectl describe deployment nginx-deployment`
```console
Name:                   nginx-deployment
Namespace:              default
CreationTimestamp:      Tue, 28 Jun 2022 14:49:48 +0000
Labels:                 app=nginx-app
                        type=front-end
Annotations:            deployment.kubernetes.io/revision: 2
Selector:               app=nginx-app
Replicas:               3 desired | 3 updated | 3 total | 3 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=nginx-app
  Containers:
   nginx-container:
    Image:        nginx:1.19
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
NewReplicaSet:   nginx-deployment-57bf6d6978 (3/3 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  89s   deployment-controller  Scaled up replica set nginx-deployment-74fb588559 to 3
  Normal  ScalingReplicaSet  25s   deployment-controller  Scaled up replica set nginx-deployment-57bf6d6978 to 1
  Normal  ScalingReplicaSet  10s   deployment-controller  Scaled down replica set nginx-deployment-74fb588559 to 2
  Normal  ScalingReplicaSet  10s   deployment-controller  Scaled up replica set nginx-deployment-57bf6d6978 to 2
  Normal  ScalingReplicaSet  7s    deployment-controller  Scaled down replica set nginx-deployment-74fb588559 to 1
  Normal  ScalingReplicaSet  7s    deployment-controller  Scaled up replica set nginx-deployment-57bf6d6978 to 3
  Normal  ScalingReplicaSet  4s    deployment-controller  Scaled down replica set nginx-deployment-74fb588559 to 0
```
  
`kubectl get deploy`
```console
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   3/3     3            3           105s
```


## 4. Сheck the rollout deployment status
`kubectl rollout status deployment nginx-deployment`
```console
deployment "nginx-deployment" successfully rolled out
```

`kubectl get pods`
```console
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-57bf6d6978-7785r   1/1     Running   0          61s
nginx-deployment-57bf6d6978-g9rmv   1/1     Running   0          79s
nginx-deployment-57bf6d6978-gqwhj   1/1     Running   0          64s
```


```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:62bb0a7c78bcb637027f8887
```

---

```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:6363bc125cb4b15def8680ce
```
