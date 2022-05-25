# Environment Variables in Kubernetes
: '
There are a number of parameters that are used by the applications. We need to define these as environment variables, so that we can use them as needed 
within different configs. Below is a scenario which needs to be configured on Kubernetes cluster. Please find below more details about the same.
Create a pod named envars.
Container name should be fieldref-container, use image nginx preferable latest tag, use command 'sh', '-c' and args should be
'while true; do echo -en '/n'; printenv NODE_NAME POD_NAME; printenv POD_IP POD_SERVICE_ACCOUNT; sleep 10; done;'
(Note: please take care of indentations)
Define Four environment variables as mentioned below:
a.) The first env should be named as NODE_NAME, set valueFrom fieldref and fieldPath should be spec.nodeName.
b.) The second env should be named as POD_NAME, set valueFrom fieldref and fieldPath should be metadata.name.
c.) The third env should be named as POD_IP, set valueFrom fieldref and fieldPath should be status.podIP.
d.) The fourth env should be named as POD_SERVICE_ACCOUNT, set valueFrom fieldref and fieldPath shoulbe be spec.serviceAccountName.
Set restart policy to Never.
To check the output, exec into the pod and use printenv command.
Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.
'


# as thor on jump_host
kubectl get namespace
kubectl get pods
	No resources found in default namespace

# Create namespace
kubectl create namespace fieldref-namespace

# Create yaml
vi /tmp/envars.yml

apiVersion: v1
kind: Pod
metadata:
  name: envars
spec:
  containers:
    - name: envars-container
      image: nginx:lastest
      command: [ "sh", "-c"]
      args:
      - while true; do
          echo -en '\n';
          printenv NODE_NAME POD_NAME;
          printenv POD_IP POD_SERVICE_ACCOUNT;
          sleep 10;
        done;
      env:
        - name: NODE_NAME
          valueFrom:
            fieldRef:
              fieldPath: spec.nodeName
        - name: POD_NAME
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
        - name: POD_IP
          valueFrom:
            fieldRef:
              fieldPath: status.podIP
        - name: POD_SERVICE_ACCOUNT
          valueFrom:
            fieldRef:
              fieldPath: spec.serviceAccountName
  restartPolicy: Never

# create pod
kubectl apply -f /tmp/envars.yml
kubectl logs envars
kubectl get pods

# get a shell into the Container
kubectl exec -it envars -- sh

# In shell, view the environment variables
printenv


CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:628e294ddcb95ac7596e122d
