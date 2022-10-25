# Deploy Apache Web Server on Kubernetes CLuster

There is an application that needs to be deployed on Kubernetes cluster under Apache web server. The Nautilus application development team has asked the DevOps team to deploy it. We need to develop a template as per requirements mentioned below:
- Create a namespace named as httpd-namespace-xfusion.
- Create a deployment named as httpd-deployment-xfusion under newly created namespace. For the deployment use httpd image with latest tag only and remember to mention the tag i.e httpd:latest, and make sure replica counts are 2.
- Create a service named as httpd-service-xfusion under same namespace to expose the deployment, nodePort should be 30004.

Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.


## 1. Reconnaissance on the server
`kubectl version`  
```console
Client Version: version.Info{Major:"1", Minor:"19", GitVersion:"v1.19.3", GitCommit:"1e11e4a2108024935ecfcb2912226cedeafd99df", GitTreeState:"clean", BuildDate:"2020-10-14T12:50:19Z", GoVersion:"go1.15.2", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{Major:"1", Minor:"20+", GitVersion:"v1.20.5-rc.0.18+c4af4684437b37", GitCommit:"c4af4684437b378b9becf4c9cfb0e6ec276f69dc", GitTreeState:"clean", BuildDate:"2021-03-09T17:20:53Z", GoVersion:"go1.15.8", Compiler:"gc", Platform:"linux/amd64"}
```

`kubectl cluster-info`  
```console
Kubernetes master is running at https://kodekloud-control-plane:6443
KubeDNS is running at https://kodekloud-control-plane:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

`kubectl get cs -A`  
```console
Warning: v1 ComponentStatus is deprecated in v1.19+
NAME                 STATUS      MESSAGE                                                                                       ERROR
controller-manager   Unhealthy   Get "http://127.0.0.1:10252/healthz": dial tcp 127.0.0.1:10252: connect: connection refused   
scheduler            Unhealthy   Get "http://127.0.0.1:10251/healthz": dial tcp 127.0.0.1:10251: connect: connection refused   
etcd-0               Healthy     {"health":"true"}
```

`kubectl get all -o wide`  
```console
NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE    SELECTOR
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   4h3m   <none>
```

`kubectl get ns`  
```console
NAME                 STATUS   AGE
default              Active   4h3m
kube-node-lease      Active   4h4m
kube-public          Active   4h4m
kube-system          Active   4h4m
local-path-storage   Active   4h3m
```

`kubectl get svc -o wide`  
```console
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE    SELECTOR
kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   4h4m   <none>
```

`kubectl get no -A -owide`  
```console
NAME                      STATUS   ROLES                  AGE    VERSION                          INTERNAL-IP   EXTERNAL-IP   OS-IMAGE       KERNEL-VERSION   CONTAINER-RUNTIME
kodekloud-control-plane   Ready    control-plane,master   4h4m   v1.20.5-rc.0.18+c4af4684437b37   172.17.0.2    <none>        Ubuntu 20.10   5.4.0-1092-gcp   containerd://1.5.0-beta.0-69-gb3f240206
```

`kubectl get po -owide`  
```console
No resources found in default namespace.
```

`kubectl get events -owide`  
```console
No resources found in default namespace.
```

`kubectl get deploy`  
```console
No resources found in default namespace.
```

`kubectl get secret`  
```console
NAME                  TYPE                                  DATA   AGE
default-token-kcdt9   kubernetes.io/service-account-token   3      4h4m
```


## 2. Create namespace
`kubectl create namespace httpd-namespace-xfusion`  
```console
namespace/httpd-namespace-xfusion created
```

`kubectl get ns`  
```console
NAME                      STATUS   AGE
default                   Active   4h5m
httpd-namespace-xfusion   Active   9s
kube-node-lease           Active   4h5m
kube-public               Active   4h5m
kube-system               Active   4h5m
local-path-storage        Active   4h5m
```


## 3. Create YAML file
`vi /tmp/http.yaml`  
```yaml
apiVersion: v1
kind: Service
metadata:
  name: httpd-service-xfusion
  namespace: httpd-namespace-xfusion
spec:
  type: NodePort
  selector:
    app: httpd_app_xfusion
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30004

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: httpd-deployment-xfusion
  namespace: httpd-namespace-xfusion
  labels:
    app: httpd_app_xfusion
spec:
  replicas: 2
  selector:
    matchLabels:
      app: httpd_app_xfusion
  template:
    metadata:
      labels:
        app: httpd_app_xfusion
    spec:
      containers:
        - name: httpd-deployment-xfusion
          image: httpd:latest
          ports:
            - containerPort: 80
```


## 4. Run YAML file
`kubectl apply -f /tmp/http.yaml`  
```console
service/httpd-service-xfusion created
deployment.apps/httpd-deployment-xfusion created
```

`kubectl get deploy -n httpd-namespace-xfusion`  
```console
NAME                       READY   UP-TO-DATE   AVAILABLE   AGE
httpd-deployment-xfusion   2/2     2            2           5m5s
```

`kubectl get service -n httpd-namespace-xfusion`  
```console
NAME                    TYPE       CLUSTER-IP    EXTERNAL-IP   PORT(S)        AGE
httpd-service-xfusion   NodePort   10.96.59.96   <none>        80:30004/TCP   78s
```

`kubectl get pods -n httpd-namespace-xfusion`  
```console
NAME                                       READY   STATUS    RESTARTS   AGE
httpd-deployment-xfusion-d88d85848-c92rb   1/1     Running   0          22s
httpd-deployment-xfusion-d88d85848-z7fdc   1/1     Running   0          22s
```


## 5. Validate the task
https://30004-port-d2445ba8dece4012.labs.kodekloud.com/
```text
It works!
```

`kubectl exec -it -n httpd-namespace-xfusion httpd-deployment-xfusion-d88d85848-c92rb -- curl localhost`  
```html
<html><body><h1>It works!</h1></body></html>
```

`kubectl exec -it -n httpd-namespace-xfusion httpd-deployment-xfusion-d88d85848-c92rb -- curl -I localhost`  
```console
HTTP/1.1 200 OK
Date: Tue, 25 Oct 2022 20:32:14 GMT
Server: Apache/2.4.54 (Unix)
Last-Modified: Mon, 11 Jun 2007 18:53:14 GMT
ETag: "2d-432a5e4a73a80"
Accept-Ranges: bytes
Content-Length: 45
Content-Type: text/html
```

---


```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:635841245734690291da0499
```
