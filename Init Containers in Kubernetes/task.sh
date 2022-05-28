# Init Containers in Kubernetes

: '
There are some applications that need to be deployed on Kubernetes cluster and these apps have some pre-requisites where some configurations need to be changed 
before deploying the app container. Some of these changes cannot be made inside the images so the DevOps team has come up with a solution to use init containers 
to perform these tasks during deployment. Below is a sample scenario that the team is going to test first.
Create a Deployment named as ic-deploy-xfusion.
Configure spec as replicas should be 1, labels app should be ic-xfusion, template's metadata lables app should be the same ic-xfusion.
The initContainers should be named as ic-msg-xfusion, use image centos, preferably with latest tag and use command 
'/bin/bash', '-c' and 'echo Init Done - Welcome to xFusionCorp Industries > /ic/beta'. 
The volume mount should be named as ic-volume-xfusion and mount path should be /ic.
Main container should be named as ic-main-xfusion, use image centos, preferably with latest tag and use command 
'/bin/bash', '-c' and 'while true; do cat /ic/beta; sleep 5; done'. 
The volume mount should be named as ic-volume-xfusion and mount path should be /ic.
Volume to be named as ic-volume-xfusion and it should be an emptyDir type.
Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.
'


# Check existing running Pods & Services
kubectl get pods
kubectl get services
kubectl get deploy

# Create a YAML
vi /tmp/init.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: ic-deploy-xfusion
  labels:
    app: ic-xfusion
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ic-xfusion
  template:
    metadata:
      labels:
        app: ic-xfusion
    spec:
      volumes:
        - name: ic-volume-xfusion
          emptyDir: {}
      initContainers:
        - name: ic-msg-xfusion
          image: centos:latest
          command:
            [
              "/bin/bash",
              "-c",
              "echo Init Done - Welcome to xFusionCorp Industries > /ic/beta",
            ]
          volumeMounts:
            - name: ic-volume-xfusion
              mountPath: /ic

      containers:
        - name: ic-main-xfusion
          image: centos:latest
          command:
            [
              "/bin/bash",
              "-c",
              "while true; do cat /ic/beta; sleep 5; done",
            ]
          volumeMounts:
            - name: ic-volume-xfusion
              mountPath: /ic


# create a pod
kubectl create -f /tmp/init.yaml

# get completed status
kubectl get deploy
kubectl get pods
	# copy pod name

# Validate the task by logs & cat the file
kubectl logs -f ic-deploy-xfusion-55bc5bbd78-zwcn9
kubectl exec ic-deploy-xfusion-55bc5bbd78-zwcn9 -- cat /ic/beta



CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:62914abea9c3fa54c03bd9b2
