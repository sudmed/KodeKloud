# Kubernetes Time Check Pod
: '
The Nautilus DevOps team want to create a time check pod in a particular Kubernetes namespace and record the logs. 
This might be initially used only for testing purposes, but later can be implemented in an existing cluster. 
Please find more details below about the task and perform it.
Create a pod called time-check in the xfusion namespace. This pod should run a container called time-check, container 
should use the busybox image with latest tag only and remember to mention tag i.e busybox:latest.
Create a config map called time-config with the data TIME_FREQ=12 in the same namespace.
The time-check container should run the command: while true; do date; sleep $TIME_FREQ;done and should write the result 
to the location /opt/data/time/time-check.log. Remember you will also need to add an environmental variable TIME_FREQ in 
the container, which should pick value from the config map TIME_FREQ key.
Create a volume log-volume and mount the same on /opt/data/time within the container.
Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.
'


# as thor@jump_host
# list namespaces
kubectl get namespace
	NAME              STATUS   AGE
	default           Active   8m20s
	...

kubectl get pods
	No resources found in default namespace
	
# create a new namespace
kubectl create namespace xfusion
	namespace/xfusion created

# list namespaces again
kubectl get namespace
	...
	xfusion	Active
	...

# Create YAML
vi /tmp/time.yaml

apiVersion: v1
kind: Namespace
metadata:
  name: xfusion

---
apiVersion: v1
kind: ConfigMap
metadata:
  name: time-config
  namespace: xfusion
data:
    TIME_FREQ: "12"

---    
apiVersion: v1
kind: Pod
metadata:
  name: time-check
  namespace: xfusion
spec:
  containers:
    - name: time-check
      image: busybox:latest
      command: [ "sh", "-c", "while true; do date; sleep $TIME_FREQ;done >> /opt/data/time/time-check.log" ]
      env:
        - name: TIME_FREQ
          valueFrom:
            configMapKeyRef:
              name: time-config
              key: TIME_FREQ
      volumeMounts:
      - name: log-volume
        mountPath: /opt/data/time
  volumes:
    - name: log-volume
      emptyDir : {}
  restartPolicy: Never



# list pods
kubectl get pods -n xfusion
	No resources found in default namespace

# create a pod
kubectl create -f /tmp/time.yaml
	configmap/time-config created
	pod/time-check created

# Wait for  pods to get running status
kubectl get pods -n xfusion
	NAME         READY   STATUS    RESTARTS   AGE
	time-check   1/1     Running   0          31s
	
kubectl exec time-check --namespace=xfusion -- cat /opt/data/time/time-check.log
	...




CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:628ac13ffba089cf0b814a18
