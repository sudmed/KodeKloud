# Print Environment Variables

The Nautilus DevOps team is working on to setup some pre-requisites for an application that will send the greetings to different users.  
There is a sample deployment, that needs to be tested. Below is a scenario which needs to be configured on Kubernetes cluster.  
Please find below more details about it.  
- Create a pod named print-envars-greeting.  
- Configure spec as, the container name should be print-env-container and use bash image.  
Create three environment variables:  
a. GREETING and its value should be Welcome to.  
b. COMPANY and its value should be DevOps.  
c. GROUP and its value should be Ltd.  
Use command to echo `["$(GREETING) $(COMPANY) $(GROUP)"]` message.  
You can check the output using `<kubectl logs -f [ pod-name ]>` command.  
Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.


## 1. Check existing deployment and pods
`kubectl get pods`  
```console
No resources found in default namespace.
```

`kubectl get all`  
```console
NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3h33m
```


## 2. Create yaml file
`vi /tmp/env.yml`
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: print-envars-greeting
  labels:
    name: print-envars-greeting
spec:
  containers:
    - name: print-env-container
      image: bash
      env:
        - name: GREETING
          value: "Welcome to"
        - name: COMPANY
          value: "DevOps"
        - name: GROUP
          value: "Ltd"
      command: ["echo"]
      args: ["$(GREETING) $(COMPANY) $(GROUP)"]
```


## 3. Create a pod 
`kubectl create -f /tmp/env.yml`  
```console
pod/print-envars-greeting created
```


## 4. Validate the task
`kubectl logs print-envars-greeting`  
```console
Welcome to DevOps Ltd
```

`kubectl logs -f print-envars-greeting`  
```console
Welcome to DevOps Ltd
```


---

```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:630fa28c8f84de1fe78c4063
```
