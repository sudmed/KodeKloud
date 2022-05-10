# Kubernetes Redis Deployment
: '
The Nautilus application development team observed some performance issues with one of the application that is deployed in Kubernetes cluster. 
After looking into number of factors, the team has suggested to use some in-memory caching utility for DB service. After number of discussions, 
they have decided to use Redis. Initially they would like to deploy Redis on kubernetes cluster for testing and later they will move it to production. 
Please find below more details about the task:
Create a redis deployment with following parameters:
Create a config map called my-redis-config having maxmemory 2mb in redis-config.
Name of the deployment should be redis-deployment, it should use redis:alpine image and container name should be redis-container. 
Also make sure it has only 1 replica.
The container should request for 1 CPU.
Mount 2 volumes:
a. An Empty directory volume called data at path /redis-master-data.
b. A configmap volume called redis-config at path /redis-master.
c. The container should expose the port 6379.
Finally, redis-deployment should be in an up and running state.
Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.
'


# Check existing running Pods
kubectl get pods
	No resources found in default namespace.

# Check existing running Services
kubectl get all
kubectl get services
	kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   13m
	
# Create a YAML file
vi /tmp/redis.yml
################## start ##################
---
kind: ConfigMap
apiVersion: v1
metadata:
  name: my-redis-config
data:
  maxmemory: 2mb
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redis
  template:
    metadata:
      labels:
        app: redis
    spec:
      containers:
        - name: redis-container
          image: redis:alpine
          ports:
            - containerPort: 6379
          resources:
            requests:
              cpu: "1000m"
          volumeMounts:
            - mountPath: /redis-master-data
              name: data
            - mountPath: /redis-master
              name: redis-config
      volumes:
      - name: data
        emptyDir: {}
      - name: redis-config
        configMap:
          name: my-redis-config

################## end ##################

cubectl create -f /tmp/redis.yml

cubectl get all

### wait 1 minute ###

cubectl get configmap

cubectl describe configmap
