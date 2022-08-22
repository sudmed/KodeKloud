# Kubernetes Redis Deployment

The Nautilus application development team observed some performance issues with one of the application that is deployed in Kubernetes cluster.  
After looking into number of factors, the team has suggested to use some in-memory caching utility for DB service.  
After number of discussions, they have decided to use Redis. Initially they would like to deploy Redis on kubernetes cluster for testing and later they will move it to production.  
Please find below more details about the task:
- Create a redis deployment with following parameters:
- Create a config map called my-redis-config having maxmemory 2mb in redis-config.
Name of the deployment should be redis-deployment, it should use redis:alpine image and container name should be redis-container. Also make sure it has only 1 replica.  The container should request for 1 CPU.  Mount 2 volumes:
a. An Empty directory volume called data at path /redis-master-data.
b. A configmap volume called redis-config at path /redis-master.
c. The container should expose the port 6379.
Finally, redis-deployment should be in an up and running state.  
Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.  


## 1. Check existing pods and services
`kubectl get pods`  
```console
No resources found in default namespace.
```

`kubectl get services`  
```console
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   13m
```

`kubectl get all`  
```console
NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   13m
```


## 2. Create YAML file
`vi /tmp/redis.yml`  
```yaml
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-redis-config
data:
  maxmemory: 2mb

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis-deployment
  labels:
    app: redis
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
      volumes:
        - name: data
          emptyDir: {}
        - name: my-redis-config
          configMap:
            name: my-redis-config
      containers:
        - name: redis-container
          image: redis:alpine
          ports:
          - containerPort: 6379
            resources:
              requests:
                cpu: "1"
          volumeMounts:
          - name: my-redis-config
            mountPath: /redis-master
          - mountPath: /redis-master-data
            name: data
```


## 3. 
`kubectl create -f /tmp/redis.yml`  
```console
configmap/my-redis-config created
deployment.apps/redis-deployment created
```

`kubectl get all`  
```console
NAME                                    READY   STATUS    RESTARTS   AGE
pod/redis-deployment-645569f6f4-gbpr7   1/1     Running   0          28s

NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   26m

NAME                               READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/redis-deployment   1/1     1            1           28s

NAME                                          DESIRED   CURRENT   READY   AGE
replicaset.apps/redis-deployment-645569f6f4   1         1         1       28s
```

`kubectl get configmap`  
```console
NAME               DATA   AGE
kube-root-ca.crt   1      26m
my-redis-config    1      43s
```

`kubectl describe configmap`  
```console
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
cm5ldGVzMB4XDTIyMDgyMjE4MzUxNVoXDTMyMDgxOTE4MzUxNVowFTETMBEGA1UE
AxMKa3ViZXJuZXRlczCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAL8Y
rxbM2vtdNQiDtGgkqS55ExB6/lRS2pf++9APO/UfX3QoMA7muU+KiWynfM+MqOSe
8Xv+oR2YXtlGV1Z/tcxn27krK17VtPvNWJuE5qgEuAvNu393UhUlZ7tcPTiZ4Nvd
/7JZzwQd6JvRE74PIcuWecnjeedZonPiex3A6nHCZ087zOn9gKmieKMIoyT3i1aS
0uDYisnZ22/Gob+AKyKfmsOFCiyDZQK7FCL6wh/rE0+FTDvCDzaglF1Brl6tftSL
+3wRV3BodVOWBK8TlZvND9Z+2RkLOw0Ud/Xq6P20DcZkJZ8gGk5Mvz2IBmkYlZtj
ixV/GZx+/AsJlLCbWJcCAwEAAaNCMEAwDgYDVR0PAQH/BAQDAgKkMA8GA1UdEwEB
/wQFMAMBAf8wHQYDVR0OBBYEFKwk0IQ2dpnMn0ZkPCQ6IkVIgZrwMA0GCSqGSIb3
DQEBCwUAA4IBAQAxHbwjPCwTT+/dt38jD9DQ+OuysWTt89jcJEkbmhQmt+OhjaF9
WvkwZlvlHn12RfHVG88tz4R8YBxUSguZu5NXb9UkcvntG4juatui65czdbbVmDIs
JZcv+wS6py/3GCZuGrF9guIkpHHsmDbEgsBhAlwNSEMi3HLsLS07l9/VeelZQMR7
mAFm9iMSJ+k5c6xEW30bjaOh6yN5Mg4JrkIMTV6xxAYWVwed5BdKqOs91RUtjlGU
n8lpI/rPUp/JqRNSmuLi7vfwpv6/Mef5/tN7dDyF7DBY+oIkNt4pxDmzi31J+C2k
3Xaxmt1kN9tWCXmCqsvUKVnEwufjjxwqIzX1
-----END CERTIFICATE-----

Events:  <none>


Name:         my-redis-config
Namespace:    default
Labels:       <none>
Annotations:  <none>

Data
====
maxmemory:
----
2mb
Events:  <none>
```

`kubectl get deployments --all-namespaces`  
```console
NAMESPACE            NAME                     READY   UP-TO-DATE   AVAILABLE   AGE
default              redis-deployment         1/1     1            1           69s
kube-system          coredns                  2/2     2            2           27m
local-path-storage   local-path-provisioner   1/1     1            1           27m
```

---

```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:630362fff8a52481194d3b28
```
