# Persistent Volumes in Kubernetes

The Nautilus DevOps team is working on a Kubernetes template to deploy a web application on the cluster. There are some requirements to create/use persistent volumes to store the application code, and the template needs to be designed accordingly. Please find more details below:  
Create a PersistentVolume named as pv-devops. Configure the spec as storage class should be manual, set capacity to 3Gi, set access mode to ReadWriteOnce, volume type should be hostPath and set path to /mnt/dba (this directory is already created, you might not be able to access it directly, so you need not to worry about it).  
Create a PersistentVolumeClaim named as pvc-devops. Configure the spec as storage class should be manual, request 1Gi of the storage, set access mode to ReadWriteOnce.  
Create a pod named as pod-devops, mount the persistent volume you created with claim name pvc-devops at document root of the web server, the container within the pod should be named as container-devops using image httpd with latest tag only (remember to mention the tag i.e httpd:latest).  
Create a node port type service named web-devops using node port 30008 to expose the web server running within the pod.  
Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.  


## 1. Reconnaissance on the server
**kubectl get services**
```console
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   39m
```

**kubectl get pods**
```console
No resources found in default namespace.
```

**kubectl get pvc**
```console
No resources found in default namespace.
```

## 2. Create YAML file
**vi /tmp/httpd.yaml**
```yaml
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-nautilus
spec:
  capacity:
    storage: 5Gi
  accessModes:
    - ReadWriteOnce
  storageClassName: manual
  hostPath:
    path: /mnt/data
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-nautilus
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: manual
  resources:
    requests:
      storage: 1Gi
---
apiVersion: v1
kind: Pod
metadata:
  name: pod-nautilus
  labels:
     app: httpd
spec:
  volumes:
    - name: storage-devops
      persistentVolumeClaim:
        claimName: pvc-nautilus
  containers:
    - name: container-nautilus
      image: httpd:latest
      ports:
        - containerPort: 80
      volumeMounts:
        - name: storage-devops
          mountPath:  /usr/local/apache2/htdocs/
---
apiVersion: v1
kind: Service
metadata:
  name: web-nautilus
spec:
   type: NodePort
   selector:
     app: httpd
   ports:
     - port: 80
       targetPort: 80
       nodePort: 30008
```


## 3. Run YAML file
**kubectl apply -f /tmp/httpd.yaml**
```console
persistentvolume/pv-devops created
persistentvolumeclaim/pvc-devops created
pod/pod-devops created
service/web-devops created
```


## 4. Check status
**kubectl get pods**
```console
NAME         READY   STATUS    RESTARTS   AGE
pod-devops   1/1     Running   0          12s
```

**kubectl get pvc**
```console
NAME           STATUS   VOLUME        CAPACITY   ACCESS MODES   STORAGECLASS   AGE
pvc-nautilus   Bound    pv-nautilus   5Gi        RWO            manual         46s
```

**kubectl describe pvc pvc-nautilus**
```console
Name:          pvc-devops
Namespace:     default
StorageClass:  manual
Status:        Bound
Volume:        pv-devops
Labels:        <none>
Annotations:   pv.kubernetes.io/bind-completed: yes
               pv.kubernetes.io/bound-by-controller: yes
Finalizers:    [kubernetes.io/pvc-protection]
Capacity:      3Gi
Access Modes:  RWO
VolumeMode:    Filesystem
Mounted By:    pod-devops
Events:        <none>
```

**kubectl get all**
```console
NAME               READY   STATUS    RESTARTS   AGE
pod/pod-nautilus   1/1     Running   0          2m19s

NAME                   TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
service/kubernetes     ClusterIP   10.96.0.1      <none>        443/TCP        119m
service/web-nautilus   NodePort    10.96.199.70   <none>        80:30008/TCP   2m19s
```

**kubectl get pv**
```console
NAME          CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                  STORAGECLASS   REASON   AGE
pv-nautilus   5Gi        RWO            Retain           Bound    default/pvc-nautilus   manual                  3m8s
```

---


```console
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:62a484a013b4d4d4ba5b0f21
```
