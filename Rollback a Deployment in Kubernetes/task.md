# Rollback a Deployment in Kubernetes

This morning the Nautilus DevOps team rolled out a new release for one of the applications. Recently one of the customers logged a complaint which seems to be about a bug related to the recent release. Therefore, the team wants to rollback the recent release.  
There is a deployment named nginx-deployment; roll it back to the previous revision.  
Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.  


## 1. Check existing deployment and pods
`kubectl get deploy`
```console
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   3/3     3            3           34s
```


`kubectl get pods`
```console
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-5546d5b87b-jjgmg   1/1     Running   0          22s
nginx-deployment-5546d5b87b-pj2q6   1/1     Running   0          16s
nginx-deployment-5546d5b87b-qz45g   1/1     Running   0          34s
```


## 2. Rollback to an earlier release
`kubectl rollout undo deployment nginx-deployment`
```console
deployment.apps/nginx-deployment rolled back
```


## 3. Get deploy and pods status
`kubectl get deploy`
```console
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   3/3     3            3           85s
```


`kubectl get pods`
```console
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-74fb588559-97h7b   1/1     Running   0          14s
nginx-deployment-74fb588559-c9pkw   1/1     Running   0          18s
nginx-deployment-74fb588559-q86hg   1/1     Running   0          11s
```


## 4. Validate the task
`kubectl rollout status deployment nginx-deployment`
```console
deployment "nginx-deployment" successfully rolled out
```



```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:62d03e8268ba89b54c51c2e8
```
