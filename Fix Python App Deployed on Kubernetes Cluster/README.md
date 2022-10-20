# Fix Python App Deployed on Kubernetes Cluster

One of the DevOps engineers was trying to deploy a python app on Kubernetes cluster. Unfortunately, due to some mis-configuration, the application is not coming up. Please take a look into it and fix the issues.  
- Application should be accessible on the specified nodePort.  
- The deployment name is python-deployment-datacenter, its using poroko/flask-demo-appimage.  
- The deployment and service of this app is already deployed.  
- nodePort should be 32345 and targetPort should be python flask app's default port.  

Note: The kubectl on jump_host has been configured to work with the kubernetes cluster.  


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
default              Active   121m
kube-node-lease      Active   121m
kube-public          Active   121m
kube-system          Active   121m
local-path-storage   Active   121m
```

`kubectl get all -o wide`  
```console
NAME                                                READY   STATUS             RESTARTS   AGE   IP           NODE                      NOMINATED NODE   READINESS GATES
pod/python-deployment-datacenter-5f448c9b8d-6bwv9   0/1     ImagePullBackOff   0          82s   10.244.0.5   kodekloud-control-plane   <none>           <none>

NAME                                TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)          AGE    SELECTOR
service/kubernetes                  ClusterIP   10.96.0.1     <none>        443/TCP          121m   <none>
service/python-service-datacenter   NodePort    10.96.0.219   <none>        8080:32345/TCP   82s    app=python_app

NAME                                           READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS                    IMAGES                  SELECTOR
deployment.apps/python-deployment-datacenter   0/1     1            0           83s   python-container-datacenter   poroko/flask-app-demo   app=python_app

NAME                                                      DESIRED   CURRENT   READY   AGE   CONTAINERS                    IMAGES                  SELECTOR
replicaset.apps/python-deployment-datacenter-5f448c9b8d   1         1         0       82s   python-container-datacenter   poroko/flask-app-demo   app=python_app,pod-template-hash=5f448c9b8d
```

`kubectl get svc -o wide`  
```console
NAME                        TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)          AGE    SELECTOR
kubernetes                  ClusterIP   10.96.0.1     <none>        443/TCP          121m   <none>
python-service-datacenter   NodePort    10.96.0.219   <none>        8080:32345/TCP   103s   app=python_app
```

`kubectl get no -o wide`  
```console
NAME                      STATUS   ROLES                  AGE    VERSION                          INTERNAL-IP   EXTERNAL-IP   OS-IMAGE       KERNEL-VERSION   CONTAINER-RUNTIME
kodekloud-control-plane   Ready    control-plane,master   122m   v1.20.5-rc.0.18+c4af4684437b37   172.17.0.2    <none>        Ubuntu 20.10   5.4.0-1089-gcp   containerd://1.5.0-beta.0-69-gb3f240206
```

`kubectl get po`  
```console
NAME                                            READY   STATUS             RESTARTS   AGE
python-deployment-datacenter-5f448c9b8d-6bwv9   0/1     ImagePullBackOff   0          2m2s
```

`kubectl get deploy`  
```console
NAME                           READY   UP-TO-DATE   AVAILABLE   AGE
python-deployment-datacenter   0/1     1            0           2m14s
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
default-token-rxjth   kubernetes.io/service-account-token   3      122m
```

`kubectl describe deploy`  
```console
Name:                   python-deployment-datacenter
Namespace:              default
CreationTimestamp:      Thu, 20 Oct 2022 06:59:51 +0000
Labels:                 <none>
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app=python_app
Replicas:               1 desired | 1 updated | 1 total | 0 available | 1 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=python_app
  Containers:
   python-container-datacenter:
    Image:        poroko/flask-app-demo
    Port:         5000/TCP
    Host Port:    0/TCP
    Environment:  <none>
    Mounts:       <none>
  Volumes:        <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      False   MinimumReplicasUnavailable
  Progressing    True    ReplicaSetUpdated
OldReplicaSets:  <none>
NewReplicaSet:   python-deployment-datacenter-5f448c9b8d (1/1 replicas created)
Events:
  Type    Reason             Age    From                   Message
  ----    ------             ----   ----                   -------
  Normal  ScalingReplicaSet  2m58s  deployment-controller  Scaled up replica set python-deployment-datacenter-5f448c9b8d to 1
```


## 2. Read logs
`kubectl logs python-deployment-datacenter-5f448c9b8d-6bwv9`  
```console
Error from server (BadRequest): container "python-container-datacenter" in pod "python-deployment-datacenter-5f448c9b8d-6bwv9" is waiting to start: trying and failing to pull image
```


## 3. Edit the deployment
`kubectl edit deploy`  
```bash
    flask-app-demo  -> flask-demo-app
    flask-app-demo  -> flask-demo-app
```
```console
deployment.apps/python-deployment-datacenter edited
```

`kubectl get deploy`  
```console
NAME                           READY   UP-TO-DATE   AVAILABLE   AGE
python-deployment-datacenter   1/1     1            1           6m59s
```

`kubectl get po`  
```console
NAME                                            READY   STATUS    RESTARTS   AGE
python-deployment-datacenter-5b7b447d4d-skcrp   1/1     Running   0          66s
```

`kubectl logs python-deployment-datacenter-5b7b447d4d-skcrp`  
```console
 * Serving Flask app "app.py"
 * Environment: production
   WARNING: Do not use the development server in a production environment.
   Use a production WSGI server instead.
 * Debug mode: off
 * Running on http://0.0.0.0:5000/ (Press CTRL+C to quit)
```


## 4. Edit the service
`kubectl get svc -o wide`  
```console
NAME                        TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)          AGE     SELECTOR
kubernetes                  ClusterIP   10.96.0.1     <none>        443/TCP          128m    <none>
python-service-datacenter   NodePort    10.96.0.219   <none>        8080:32345/TCP   8m13s   app=python_app
```

`kubectl edit svc`  
```bash
    port 8080  -> 5000
    port 8080  -> 5000
    targetport 8080  -> 5000
```
```console
kubectl edit svc
service/kubernetes skipped
service/python-service-datacenter edited
```

`kubectl get svc -o wide`  
```console
NAME                        TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)          AGE     SELECTOR
kubernetes                  ClusterIP   10.96.0.1     <none>        443/TCP          129m    <none>
python-service-datacenter   NodePort    10.96.0.219   <none>        5000:32345/TCP   9m43s   app=python_app
```


## 5. Validate the task
https://32345-port-41e1f7c303854eeb.labs.kodekloud.com/
```html
Hello World Pyvo 1!
```

`kubectl exec -it python-deployment-datacenter-5b7b447d4d-skcrp -- curl localhost:5000`  
```console
Hello World Pyvo 1!
```


---


```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:6350583f951c8ea1049fb8c3
```
