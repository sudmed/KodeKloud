# Kubernetes Troubleshooting
: '
One of the Nautilus DevOps team members was working on to update an existing Kubernetes template. 
Somehow, he made some mistakes in the template and it is failing while applying. We need to fix this as soon as possible, 
so take a look into it and make sure you are able to apply it without any issues. Also, do not remove any component from the template 
like pods/deployments/volumes etc.
/home/thor/mysql_deployment.yml is the template that needs to be fixed.
Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.
'


thor@jump_host~$ kubectl get all
	# service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   54m

kubectl create -f mysql_deployment.yml
  # nothing to create
  
kubectl get secrets
	# default-token-58vx5   kubernetes.io/service-account-token   3      60m
	# mysql-db-url          Opaque                                1      106s
	# mysql-root-pass       Opaque                                1      106s
	# mysql-user-pass       Opaque                                2      106s

# split mysql_deployment.yml to 4 separate files
cp mysql_deployment.yml pv.yml
cp mysql_deployment.yml pvc.yml
cp mysql_deployment.yml service.yml
cp mysql_deployment.yml deploy.yml

# code see in separate files
vi pv.yml
vi pvc.yml
vi service.yml
vi deploy.yml

# checking
kubectl create -f pv.yml
kubectl create -f pvc.yml
kubectl create -f service.yml
kubectl create -f deploy.yml

# validate
kubectl get pv
  # NAME       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                    STORAGECLASS   REASON   AGE
  # mysql-pv   250Mi      RWO            Retain           Bound    default/mysql-pv-claim   standard                13m

kubectl get pvc
  # NAME             STATUS   VOLUME     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
  # mysql-pv-claim   Bound    mysql-pv   250Mi      RWO            standard       11m

kubectl get service
  # NAME         TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
  # kubernetes   ClusterIP   10.96.0.1      <none>        443/TCP          80m
  # mysql        NodePort    10.96.105.81   <none>        3306:30011/TCP   7m50s

kubectl get deploy
  # NAME               READY   UP-TO-DATE   AVAILABLE   AGE
  # mysql-deployment   1/1     1            1           57s

kubectl get all
  # NAME                                    READY   STATUS    RESTARTS   AGE
  # pod/mysql-deployment-74f5dd5cdf-csvcs   1/1     Running   0          85s
  # NAME                 TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
  # service/kubernetes   ClusterIP   10.96.0.1      <none>        443/TCP          76m
  # service/mysql        NodePort    10.96.105.81   <none>        3306:30011/TCP   3m45s
  # NAME                               READY   UP-TO-DATE   AVAILABLE   AGE
  # deployment.apps/mysql-deployment   1/1     1            1           86s
  # NAME                                          DESIRED   CURRENT   READY   AGE
  # replicaset.apps/mysql-deployment-74f5dd5cdf   1         1         1       86s

# as all ok, delete separate pods
kubectl delete deploy mysql-deployment
kubectl delete service mysql
kubectl delete pvc mysql-pv-claim
kubectl delete pv mysql-pv

# empty main template
vi mysql_deployment.yml
  #delete all lines pressing D

# join separate yaml into main template
cat pv.yml pvc.yml service.yml deploy.yml >> mysql_deployment.yml

# create resource
kubectl create -f mysql_deployment.yml

# checking
kubectl get all
  # NAME                                    READY   STATUS    RESTARTS   AGE
  # pod/mysql-deployment-74f5dd5cdf-v2vk8   0/1     Pending   0          39s
  # NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
  # service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   87m
  # NAME                               READY   UP-TO-DATE   AVAILABLE   AGE
  # deployment.apps/mysql-deployment   0/1     1            0           39s
  # NAME                                          DESIRED   CURRENT   READY   AGE
  # replicaset.apps/mysql-deployment-74f5dd5cdf   1         1         0       39s



: '
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:629d1a19e958fec39f09f99c
'
