# Countdown job in Kubernetes

The Nautilus DevOps team is working on to create few jobs in Kubernetes cluster. They might come up with some real scripts/commands to use, but for now they are preparing the templates and testing the jobs with dummy commands.  
Please create a job template as per details given below:  
Create a job countdown-nautilus.  
The spec template should be named as countdown-nautilus (under metadata), and the container should be named as container-countdown-nautilus.  
Use image ubuntu with latest tag only and remember to mention tag i.e ubuntu:latest, and restart policy should be Never.  
Use command for i in 10 9 8 7 6 5 4 3 2 1 ; do echo $i ; done  
Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.  


## 1. Get services and pods
`kubectl get services`  
```console
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   123m
```

`kubectl get all`  
```console
NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   123m
```

`kubectl get pods`  
```console
No resources found in default namespace.
```


## 2. Create a yaml file
`vi /tmp/countdown.yaml`  

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: countdown-nautilus
spec:
  template:
    metadata:
      name: countdown-nautilus
    spec:
      containers:
      - name: container-countdown-nautilus
        image: ubuntu:latest
        command: ["/bin/bash", "-c", "for i in 10 9 8 7 6 5 4 3 2 1 ; do echo $i ; done"]
      restartPolicy: Never
```


## 3. Create a pod
`kubectl create -f /tmp/countdown.yaml`  
```console
job.batch/countdown-nautilus created
```


## 4. Get pods
`kubectl get pods`  
```console
NAME                       READY   STATUS      RESTARTS   AGE
countdown-nautilus-nndhp   0/1     Completed   0          84s
```

`kubectl get all`  
```console
NAME                           READY   STATUS      RESTARTS   AGE
pod/countdown-nautilus-nndhp   0/1     Completed   0          2m42s

NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   127m

NAME                           COMPLETIONS   DURATION   AGE
job.batch/countdown-nautilus   1/1           10s        2m42s
```

`kubectl logs countdown-nautilus-nndhp`  
```console
10
9
8
7
6
5
4
3
2
1
```


---

```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:63074934d4f58d7da426c8ca
```
