# Rolling Updates And Rolling Back Deployments in Kubernetes
: 'There is a production deployment planned for next week. The Nautilus DevOps team wants to test the deployment update and rollback on Dev environment 
first so that they can identify the risks in advance. Below you can find more details about the plan they want to execute.
Create a namespace devops. Create a deployment called httpd-deploy under this new namespace, It should have one container called httpd, use httpd:2.4.25 image 
and 4 replicas. The deployment should use RollingUpdate strategy with maxSurge=1, and maxUnavailable=2. Also create a NodePort type service named httpd-service 
and expose the deployment on nodePort: 30008.
Now upgrade the deployment to version httpd:2.4.43 using a rolling update.
Finally, once all pods are updated undo the recent update and roll back to the previous/original version.
Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.
'


#  from jump server
kubectl get all
: '
NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   31m
'


kubectl get namespace
: '
NAME                 STATUS   AGE
default              Active   32m
kube-node-lease      Active   32m
kube-public          Active   32m
kube-system          Active   32m
local-path-storage   Active   32m
'


# Create namespace
kubectl create namespace devops
: '
namespace/devops created
'


# Create yaml  file with all the parameters
vi devops.yaml
: '
apiVersion: apps/v1
kind: Deployment
metadata:
  name: httpd-deploy
  namespace: devops
spec:
  replicas: 4
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 2
  selector:
    matchLabels:
      app: httpd
  template:
    metadata:
      labels:
        app: httpd
    spec:
      containers:
        - name: httpd
          image: httpd:2.4.28
---                                                                                                           
apiVersion: v1                                                                                                
kind: Service                                                                                                 
metadata:                                                                                                     
  name: httpd-service  
  namespace: devops  
spec:                                                                                                         
   type: NodePort                                                                                             
   selector:                                                                                                  
     app: httpd                                                                                     
   ports:                                                                                                     
     - port: 80                                                                                               
       targetPort: 80                                                                                         
       nodePort: 30008
'


# create pod
kubectl create -f devops.yaml
: '
deployment.apps/httpd-deploy created
service/httpd-service created
'


# Wait for  pods to get running status
kubectl get all -n devops
: '
NAME                                READY   STATUS    RESTARTS   AGE
pod/httpd-deploy-594f986d57-7z7bn   1/1     Running   0          41s
pod/httpd-deploy-594f986d57-jg99m   1/1     Running   0          41s
pod/httpd-deploy-594f986d57-vktch   1/1     Running   0          41s
pod/httpd-deploy-594f986d57-x8z9b   1/1     Running   0          41s
NAME                    TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
service/httpd-service   NodePort   10.96.240.197   <none>        80:30008/TCP   41s
NAME                           READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/httpd-deploy   4/4     4            4           41s
NAME                                      DESIRED   CURRENT   READY   AGE
replicaset.apps/httpd-deploy-594f986d57   4         4         4       41s
'


# validete deployment
# click Apache button UI
    # It works!


# Perform  rolling update
kubectl describe deploy httpd-deploy -n devops
: '
Name:                   httpd-deploy
Namespace:              devops
CreationTimestamp:      Thu, 09 Jun 2022 08:44:08 +0000
Labels:                 <none>
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app=httpd
Replicas:               4 desired | 4 updated | 4 total | 4 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  2 max unavailable, 1 max surge
Pod Template:
  Labels:  app=httpd
  Containers:
   httpd:
    Image:        httpd:2.4.25
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
NewReplicaSet:   httpd-deploy-594f986d57 (4/4 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  102s  deployment-controller  Scaled up replica set httpd-deploy-594f986d57 to 4
'

    
kubectl set image deployment httpd-deploy httpd=httpd:2.4.43 --namespace devops --record=true
: '
deployment.apps/httpd-deploy image updated
'


kubectl get deployment -n devops
 : '
 NAME           READY   UP-TO-DATE   AVAILABLE   AGE
 httpd-deploy   4/4     4            4           3m7s
 '


kubectl get pods -n devops
: '
NAME                            READY   STATUS    RESTARTS   AGE
httpd-deploy-7bb4d96457-7mwgd   1/1     Running   0          32s
httpd-deploy-7bb4d96457-g4cjz   1/1     Running   0          50s
httpd-deploy-7bb4d96457-prxqt   1/1     Running   0          50s
httpd-deploy-7bb4d96457-vk5pb   1/1     Running   0          50s
'


kubectl describe deploy httpd-deploy -n devops
: '
Name:                   httpd-deploy
Namespace:              devops
CreationTimestamp:      Thu, 09 Jun 2022 08:44:08 +0000
Labels:                 <none>
Annotations:            deployment.kubernetes.io/revision: 2
                        kubernetes.io/change-cause: kubectl set image deployment httpd-deploy httpd=httpd:2.4.43 --namespace=devops --record=true
Selector:               app=httpd
Replicas:               4 desired | 4 updated | 4 total | 4 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  2 max unavailable, 1 max surge
Pod Template:
  Labels:  app=httpd
  Containers:
   httpd:
    Image:        httpd:2.4.43
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
NewReplicaSet:   httpd-deploy-7bb4d96457 (4/4 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  4m7s  deployment-controller  Scaled up replica set httpd-deploy-594f986d57 to 4
  Normal  ScalingReplicaSet  90s   deployment-controller  Scaled up replica set httpd-deploy-7bb4d96457 to 1
  Normal  ScalingReplicaSet  90s   deployment-controller  Scaled down replica set httpd-deploy-594f986d57 to 2
  Normal  ScalingReplicaSet  90s   deployment-controller  Scaled up replica set httpd-deploy-7bb4d96457 to 3
  Normal  ScalingReplicaSet  72s   deployment-controller  Scaled down replica set httpd-deploy-594f986d57 to 1
  Normal  ScalingReplicaSet  72s   deployment-controller  Scaled up replica set httpd-deploy-7bb4d96457 to 4
  Normal  ScalingReplicaSet  70s   deployment-controller  Scaled down replica set httpd-deploy-594f986d57 to 0
'
    

# Rollback the deployment
kubectl rollout undo deployment httpd-deploy -n devops
: '
deployment.apps/httpd-deploy rolled back
'


# validate roll out status
kubectl get pods -n devops
: '
NAME                            READY   STATUS    RESTARTS   AGE
httpd-deploy-594f986d57-2nt8n   1/1     Running   0          21s
httpd-deploy-594f986d57-584jj   1/1     Running   0          27s
httpd-deploy-594f986d57-qz7ll   1/1     Running   0          26s
httpd-deploy-594f986d57-rxxxz   1/1     Running   0          26s
'


# click Apache button UI
    # It works!


kubectl describe deploy httpd-deploy -n devops
: '
Name:                   httpd-deploy
Namespace:              devops
CreationTimestamp:      Thu, 09 Jun 2022 08:44:08 +0000
Labels:                 <none>
Annotations:            deployment.kubernetes.io/revision: 3
Selector:               app=httpd
Replicas:               4 desired | 4 updated | 4 total | 4 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  2 max unavailable, 1 max surge
Pod Template:
  Labels:  app=httpd
  Containers:
   httpd:
    Image:        httpd:2.4.25
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
NewReplicaSet:   httpd-deploy-594f986d57 (4/4 replicas created)
Events:
  Type    Reason             Age                From                   Message
  ----    ------             ----               ----                   -------
  Normal  ScalingReplicaSet  5m47s              deployment-controller  Scaled up replica set httpd-deploy-594f986d57 to 4
  Normal  ScalingReplicaSet  3m10s              deployment-controller  Scaled up replica set httpd-deploy-7bb4d96457 to 1
  Normal  ScalingReplicaSet  3m10s              deployment-controller  Scaled down replica set httpd-deploy-594f986d57 to 2
  Normal  ScalingReplicaSet  3m10s              deployment-controller  Scaled up replica set httpd-deploy-7bb4d96457 to 3
  Normal  ScalingReplicaSet  2m52s              deployment-controller  Scaled down replica set httpd-deploy-594f986d57 to 1
  Normal  ScalingReplicaSet  2m52s              deployment-controller  Scaled up replica set httpd-deploy-7bb4d96457 to 4
  Normal  ScalingReplicaSet  2m50s              deployment-controller  Scaled down replica set httpd-deploy-594f986d57 to 0
  Normal  ScalingReplicaSet  53s                deployment-controller  Scaled up replica set httpd-deploy-594f986d57 to 1
  Normal  ScalingReplicaSet  53s                deployment-controller  Scaled down replica set httpd-deploy-7bb4d96457 to 2
  Normal  ScalingReplicaSet  44s (x4 over 53s)  deployment-controller  (combined from similar events): Scaled down replica set httpd-deploy-7bb4d96457 to 0
'


: '
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:629f14d2275782c716576202
'
