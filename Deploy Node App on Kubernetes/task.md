# Deploy Node App on Kubernetes

The Nautilus development team has completed development of one of the node applications, which they are planning to deploy on a Kubernetes cluster. They recently had a meeting with the DevOps team to share their requirements. Based on that, the DevOps team has listed out the exact requirements to deploy the app. Find below more details:  
Create a deployment using gcr.io/kodekloud/centos-ssh-enabled:node image, replica count must be 2.  
Create a service to expose this app, the service type must be NodePort, targetPort must be 8080 and nodePort should be 30012.  
Make sure all the pods are in Running state after the deployment.  
You can check the application by clicking on NodeApp button on top bar.  
You can use any labels as per your choice.  
Note: The kubectl on jump_host has been configured to work with the kubernetes cluster.  



## 1. Get pods
`kubectl get namespace`
```console
NAME                 STATUS   AGE
default              Active   173m
kube-node-lease      Active   173m
kube-public          Active   173m
kube-system          Active   173m
local-path-storage   Active   173m
```

`kubectl get pods`
```console
No resources found in default namespace.
```


## 2. Create YAML file
`vi /tmp/node-deploy.yaml`
```yaml
apiVersion: v1
kind: Service
metadata:
  name: node-service
  namespace: default
spec:
  type: NodePort
  selector:
    app: node-app
  ports:
    - port: 80
      targetPort: 8080
      nodePort: 30012
---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: node-deployment
  namespace: default
spec:
  replicas: 2
  selector:
    matchLabels:
      app: node-app
  template:
    metadata:
      labels:
        app: node-app
    spec:
      containers:
        - name: node-container
          image: gcr.io/kodekloud/centos-ssh-enabled:node
          ports:
            - containerPort: 80
```


## 3. Apply YAML file
`kubectl apply -f node-deploy.yaml`
```console
service/node-service created
deployment.apps/node-deployment created
```


## 4. Get status
`kubectl get namespace`
```console
NAME                 STATUS   AGE
default              Active   147m
kube-node-lease      Active   147m
kube-public          Active   147m
kube-system          Active   147m
local-path-storage   Active   147m
```


`kubectl get pods`
```console
NAME                              READY   STATUS              RESTARTS   AGE
node-deployment-dd99d7b78-c794l   0/1     ContainerCreating   0          14s
node-deployment-dd99d7b78-pjwf4   0/1     ContainerCreating   0          14s
```


`kubectl describe service node-service -n default`
```console
Name:                     node-service
Namespace:                default
Labels:                   <none>
Annotations:              <none>
Selector:                 app=node-app
Type:                     NodePort
IP:                       10.96.93.245
Port:                     <unset>  80/TCP
TargetPort:               8080/TCP
NodePort:                 <unset>  30012/TCP
Endpoints:                10.244.0.5:8080,10.244.0.6:8080
Session Affinity:         None
External Traffic Policy:  Cluster
Events:                   <none>
```


```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:62dbab720615bcf6b462afa8
```
