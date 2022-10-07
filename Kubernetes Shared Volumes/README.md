# Kubernetes Shared Volumes

We are working on an application that will be deployed on multiple containers within a pod on Kubernetes cluster. There is a requirement to share a volume among the containers to save some temporary data. The Nautilus DevOps team is developing a similar template to replicate the scenario. Below you can find more details about it.  
- Create a pod named volume-share-xfusion.
- For the first container, use image ubuntu with latest tag only and remember to mention the tag i.e ubuntu:latest, container should be named as volume-container-xfusion-1, and run a sleep command for it so that it remains in running state. Volume volume-share should be mounted at path /tmp/ecommerce.
- For the second container, use image ubuntu with the latest tag only and remember to mention the tag i.e ubuntu:latest, container should be named as volume-container-xfusion-2, and again run a sleep command for it so that it remains in running state. Volume volume-share should be mounted at path /tmp/cluster.
- Volume name should be volume-share of type emptyDir.
- After creating the pod, exec into the first container i.e volume-container-xfusion-1, and just for testing create a file ecommerce.txt with any content under the mounted path of first container i.e /tmp/ecommerce.

The file ecommerce.txt should be present under the mounted path /tmp/cluster on the second container volume-container-xfusion-2 as well, since they are using a shared volume.  
Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.


## 1. Reconnaissance on the server
`kubectl cluster-info`  
```console
Kubernetes master is running at https://kodekloud-control-plane:6443
KubeDNS is running at https://kodekloud-control-plane:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

`kubectl get all -o wide`  
```console
NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE   SELECTOR
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   90m   <none>
```

`kubectl get ns`  
```console
NAME                 STATUS   AGE
default              Active   90m
kube-node-lease      Active   90m
kube-public          Active   90m
kube-system          Active   90m
local-path-storage   Active   90m
```

`kubectl get svc -o wide`  
```console
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE   SELECTOR
kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   90m   <none>
```

`kubectl get no -o wide`  
```console
NAME                      STATUS   ROLES                  AGE   VERSION                          INTERNAL-IP   EXTERNAL-IP   OS-IMAGE       KERNEL-VERSION   CONTAINER-RUNTIME
kodekloud-control-plane   Ready    control-plane,master   91m   v1.20.5-rc.0.18+c4af4684437b37   172.17.0.2    <none>        Ubuntu 20.10   5.4.0-1089-gcp   containerd://1.5.0-beta.0-69-gb3f240206
```

`kubectl get po`  
```console
No resources found in default namespace.
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
default-token-q8t87   kubernetes.io/service-account-token   3      91m
```


## 2. Create yaml  file
`vi /tmp/volume-share.yaml`  
```yaml
---
apiVersion: v1
kind: Pod
metadata:
  name: volume-share-xfusion
  labels:
    name: myapp
spec:
  volumes:
    - name: volume-share
      emptyDir: {}
  containers:
    - name: volume-container-xfusion-1
      image: ubuntu:latest
      command: ["/bin/bash", "-c", "sleep 10000"]
      volumeMounts:
        - name: volume-share
          mountPath: /tmp/ecommerce
    - name: volume-container-xfusion-2
      image: ubuntu:latest
      command: ["/bin/bash", "-c", "sleep 10000"]
      volumeMounts:
        - name: volume-share
          mountPath: /tmp/cluster
```


## 3. Run yaml  file
`kubectl apply -f /tmp/volume-share.yaml`  
```console
pod/volume-share-xfusion created
```

`kubectl get pods`  
```console
NAME                   READY   STATUS    RESTARTS   AGE
volume-share-xfusion   2/2     Running   0          10s
```


## 4. Validate the task
### Exec to container `volume-container-xfusion-1`:  
`kubectl exec -it volume-share-xfusion --container volume-container-xfusion-1 -- bash`  
```console
root@volume-share-xfusion:/# cd /tmp/ecommerce
root@volume-share-xfusion:/tmp/ecommerce# ll
total 8
drwxrwxrwx 2 root root 4096 Oct  7 20:00 ./
drwxrwxrwt 1 root root 4096 Oct  7 20:01 ../
root@volume-share-xfusion:/tmp/ecommerce# touch ecommerce.txt
root@volume-share-xfusion:/tmp/ecommerce# vi ecommerce.txt
bash: vi: command not found
root@volume-share-xfusion:/tmp/ecommerce# vim ecommerce.txt
bash: vim: command not found
root@volume-share-xfusion:/tmp/ecommerce# echo 123 > ecommerce.txt
root@volume-share-xfusion:/tmp/ecommerce# cat ecommerce.txt
123
root@volume-share-xfusion:/tmp/ecommerce# 
```


### Exec to container `volume-container-xfusion-2`:  
`kubectl exec -it volume-share-xfusion --container volume-container-xfusion-2 -- bash`  
```console
root@volume-share-xfusion:/# cd /tmp/cluster
root@volume-share-xfusion:/tmp/cluster# ll
total 12
drwxrwxrwx 2 root root 4096 Oct  7 20:03 ./
drwxrwxrwt 1 root root 4096 Oct  7 20:01 ../
-rw-r--r-- 1 root root    4 Oct  7 20:03 ecommerce.txt
root@volume-share-xfusion:/tmp/cluster# cat ecommerce.txt 
123
root@volume-share-xfusion:/tmp/cluster#
```


---

```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:63405bf3bef409d6685b7392
```
