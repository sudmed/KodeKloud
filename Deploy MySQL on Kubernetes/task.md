# Deploy MySQL on Kubernetes

A new MySQL server needs to be deployed on Kubernetes cluster. The Nautilus DevOps team was working on to gather the requirements. Recently they were able to finalize the requirements and shared them with the team members to start working on it. Below you can find the details:  
1.) Create a PersistentVolume mysql-pv, its capacity should be 250Mi, set other parameters as per your preference.  
2.) Create a PersistentVolumeClaim to request this PersistentVolume storage. Name it as mysql-pv-claim and request a 250Mi of storage. Set other parameters as per your preference.  
3.) Create a deployment named mysql-deployment, use any mysql image as per your preference. Mount the PersistentVolume at mount path /var/lib/mysql.  
4.) Create a NodePort type service named mysql and set nodePort to 30007.  
5.) Create a secret named mysql-root-pass having a key pair value, where key is password and its value is YUIidhb667, create another secret named mysql-user-pass having some key pair values, where frist key is username and its value is kodekloud_roy, second key is password and value is B4zNgHA7Ya, create one more secret named mysql-db-url, key name is database and value is kodekloud_db2  
6.) Define some Environment variables within the container:  
a) name: MYSQL_ROOT_PASSWORD, should pick value from secretKeyRef name: mysql-root-pass and key: password  
b) name: MYSQL_DATABASE, should pick value from secretKeyRef name: mysql-db-url and key: database  
c) name: MYSQL_USER, should pick value from secretKeyRef name: mysql-user-pass key key: username  
d) name: MYSQL_PASSWORD, should pick value from secretKeyRef name: mysql-user-pass and key: password  
Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.  


## 1. Check existing pods
`kubectl get all`
```console
NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   41m
```


## 2.  Create secret
`kubectl create secret generic mysql-root-pass --from-literal=password=YUIidhb667`
```console
secret/mysql-root-pass created
```

`kubectl create secret generic mysql-user-pass --from-literal=username=kodekloud_roy --from-literal=password=B4zNgHA7Ya`
```console
secret/mysql-user-pass created
```

`kubectl create secret generic mysql-db-url --from-literal=database=kodekloud_db2`
```console
secret/mysql-db-url created
```

 
## 3. Check secret
`kubectl get secret`
```console
NAME                  TYPE                                  DATA   AGE
default-token-6s4bm   kubernetes.io/service-account-token   3      41m
mysql-db-url          Opaque                                1      6s
mysql-root-pass       Opaque                                1      15s
mysql-user-pass       Opaque                                2      10s
```


## 4. Create a YAML file
`vi /tmp/mysql.yaml`
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: mysql-pv
  labels:
    type: local
spec:
  storageClassName: manual
  capacity:
    storage: 250Mi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/mnt/data"

---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-pv-claim
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 250Mi

---
apiVersion: v1
kind: Secret
metadata:
  name: mysql-root-pass
type: kubernetes.io/basic-auth
stringData:
  password: YUIidhb667

---  
apiVersion: v1
kind: Secret
metadata:
  name: mysql-user-pass
type: kubernetes.io/basic-auth
stringData:
  username: kodekloud_roy
  password: B4zNgHA7Ya
  
---  
apiVersion: v1
kind: Secret
metadata:
  name: mysql-db-url
type: Opaque
stringData:
  database: kodekloud_db2
  
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql-deployment
spec:
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
      - image: mysql:5.6
        name: mysql
        env:
        - name: MYSQL_ROOT_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mysql-root-pass
              key: password
        - name: MYSQL_DATABASE
          valueFrom:
            secretKeyRef:
              name: mysql-db-url
              key: database
        - name: MYSQL_USER
          valueFrom:
            secretKeyRef:
              name: mysql-user-pass
              key: username
        - name: MYSQL_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mysql-user-pass
              key: password
        ports:
        - containerPort: 3306
          name: mysql
        volumeMounts:
        - name: mysql-persistent-storage
          mountPath: /var/lib/mysql
      volumes:
      - name: mysql-persistent-storage
        persistentVolumeClaim:
          claimName: mysql-pv-claim

---
apiVersion: v1
kind: Service
metadata:
  name: mysql
spec:
  type: NodePort
  ports:
  - port: 3306
    targetPort: 3306
    nodePort: 30007
  selector:
    app: mysql
```


## 5. Run YAML file
`kubectl create -f /tmp/mysql.yaml`
```console
persistentvolume/mysql-pv created
persistentvolumeclaim/mysql-pv-claim created
deployment.apps/mysql-deployment created
service/mysql created
Error from server (AlreadyExists): error when creating "/tmp/mysql.yaml": secrets "mysql-root-pass" already exists
Error from server (AlreadyExists): error when creating "/tmp/mysql.yaml": secrets "mysql-user-pass" already exists
Error from server (AlreadyExists): error when creating "/tmp/mysql.yaml": secrets "mysql-db-url" already exists
```


`kubectl get pv`
```console
NAME       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                    STORAGECLASS   REASON   AGE
mysql-pv   250Mi      RWO            Retain           Bound    default/mysql-pv-claim   manual                  14s
```


`kubectl get pvc`
```console
NAME             STATUS   VOLUME     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
mysql-pv-claim   Bound    mysql-pv   250Mi      RWO            manual         26s
```


`kubectl get all`
```console
NAME                                    READY   STATUS    RESTARTS   AGE
pod/mysql-deployment-5f86875bc9-6zz4k   1/1     Running   0          38s

NAME                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
service/kubernetes   ClusterIP   10.96.0.1       <none>        443/TCP          43m
service/mysql        NodePort    10.96.253.157   <none>        3306:30007/TCP   38s

NAME                               READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/mysql-deployment   1/1     1            1           38s

NAME                                          DESIRED   CURRENT   READY   AGE
replicaset.apps/mysql-deployment-5f86875bc9   1         1         1       38s
```


## 6. Login to pod for validation
`kubectl exec -it replicaset.apps/mysql-deployment-5f86875bc9 -- /bin/bash`
`printenv`
```console
MYSQL_PASSWORD=B4zNgHA7Ya
MYSQL_PORT_3306_TCP_PROTO=tcp
HOSTNAME=mysql-deployment-5f86875bc9-6zz4k
MYSQL_DATABASE=kodekloud_db2
KUBERNETES_PORT_443_TCP_PROTO=tcp
MYSQL_SERVICE_PORT=3306
KUBERNETES_PORT_443_TCP_ADDR=10.96.0.1
MYSQL_ROOT_PASSWORD=YUIidhb667
MYSQL_PORT=tcp://10.96.253.157:3306
KUBERNETES_PORT=tcp://10.96.0.1:443
MYSQL_PORT_3306_TCP=tcp://10.96.253.157:3306
PWD=/
HOME=/root
MYSQL_MAJOR=5.6
GOSU_VERSION=1.12
MYSQL_USER=kodekloud_roy
MYSQL_PORT_3306_TCP_PORT=3306
KUBERNETES_SERVICE_PORT_HTTPS=443
MYSQL_PORT_3306_TCP_ADDR=10.96.253.157
KUBERNETES_PORT_443_TCP_PORT=443
MYSQL_VERSION=5.6.51-1debian9
KUBERNETES_PORT_443_TCP=tcp://10.96.0.1:443
TERM=xterm
SHLVL=1
KUBERNETES_SERVICE_PORT=443
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
KUBERNETES_SERVICE_HOST=10.96.0.1
MYSQL_SERVICE_HOST=10.96.253.157
_=/usr/bin/printenv
```


```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:62d9bf2b0ca5b92ea1cea4d1
```
