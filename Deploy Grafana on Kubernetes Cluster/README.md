# Deploy Grafana on Kubernetes Cluster

The Nautilus DevOps teams is planning to set up a Grafana tool to collect and analyze analytics from some applications. They are planning to deploy it on Kubernetes cluster. Below you can find more details.  
1) Create a deployment named grafana-deployment-nautilus using any grafana image for Grafana app. Set other parameters as per your choice.  
2) Create NodePort type service with nodePort 32000 to expose the app.  

You need not to make any configuration changes inside the Grafana app once deployed, just make sure you are able to access the Grafana login page.  
Note: The kubeclt on jump_host has been configured to work with kubernetes cluster.


## 1. Reconnaissance on the server
`kubectl cluster-info`  
```console
Kubernetes master is running at https://kodekloud-control-plane:6443
KubeDNS is running at https://kodekloud-control-plane:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

`kubectl get all`  
```console
NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3h27m
```

`kubectl get no`  
```console
NAME                      STATUS   ROLES                  AGE     VERSION
kodekloud-control-plane   Ready    control-plane,master   3h27m   v1.20.5-rc.0.18+c4af4684437b37
```

`kubectl get po`  
```console
No resources found in default namespace.
```

`kubectl get ns`  
```console
NAME                 STATUS   AGE
default              Active   3h28m
kube-node-lease      Active   3h28m
kube-public          Active   3h28m
kube-system          Active   3h28m
local-path-storage   Active   3h27m
```

`kubectl get svc`  
```console
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3h28m
```


## 2. Create YAML file
`vi /tmp/grafana.yml`  

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: grafana-deployment-nautilus
spec:
  replicas: 1
  selector:
    matchLabels:
      app: grafana
  template:
    metadata:
      name: grafana
      labels:
        app: grafana
    spec:
      containers:
      - name: grafana
        image: grafana/grafana:latest
        ports:
        - name: grafana
          containerPort: 3000
---
apiVersion: v1
kind: Service
metadata:
  name: grafana
spec:
  selector: 
    app: grafana
  type: NodePort  
  ports:
    - port: 3000
      targetPort: 3000
      nodePort: 32000
```


## 3. Run YAML file
`kubectl apply -f /tmp/grafana.yml`  
```console
deployment.apps/grafana-deployment-nautilus created
service/grafana created
```

`kubectl get po`  
```console
NAME                                           READY   STATUS              RESTARTS   AGE
grafana-deployment-nautilus-7fd6c56b94-tdn6g   0/1     ContainerCreating   0          11s
```

`kubectl get svc`  
NAME         TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
grafana      NodePort    10.96.183.90   <none>        3000:32000/TCP   21s
kubernetes   ClusterIP   10.96.0.1      <none>        443/TCP          3h30m
```


## 4. Validate the task
`https://32000-port-edd4ff9ebc8b4f81.labs.kodekloud.com/login`  

`curl -Il https://32000-port-edd4ff9ebc8b4f81.labs.kodekloud.com/login`  
```console
HTTP/1.1 200 OK
content-type: text/html; charset=UTF-8
cache-control: no-cache
expires: -1
pragma: no-cache
x-content-type-options: nosniff
x-frame-options: deny
x-xss-protection: 1; mode=block
Date: Tue, 20 Sep 2022 06:59:28 GMT
Server: Google Frontend
Via: 1.1 google
Transfer-Encoding: chunked
Alt-Svc: h3=":443"; ma=2592000,h3-29=":443"; ma=2592000
```

---

```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:6328d9450350ca05388a4648
```
