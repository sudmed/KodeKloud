# Manage Secrets in Kubernetes

The Nautilus nautilus team is working to deploy some tools in Kubernetes cluster. Some of the tools are licence based so that licence information needs to be stored securely within Kubernetes cluster. Therefore, the team wants to utilize Kubernetes secrets to store those secrets. Below you can find more details about the requirements:  
We already have a secret key file media.txt under /opt location on jump host. Create a generic secret named media, it should contain the password/license-number present in media.txt file.  
Also create a pod named secret-nautilus.  
Configure pod's spec as container name should be secret-container-nautilus, image should be fedora preferably with latest tag (remember to mention the tag with image). Use sleep command for container so that it remains in running state. Consume the created secret and mount it under /opt/demo within the container.  
To verify you can exec into the container secret-container-nautilus, to check the secret key under the mounted path /opt/demo. Before hitting the Check button please make sure pod/pods are in running state, also validation can take some time to complete so keep patience.  
Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.  


## 1. Create a secret
`ll /opt`

`cat /opt/media.txt`
```console
5ecur3
```

`kubectl create secret generic media --from-file=/opt/media.txt`
```console
secret/media created
```


## 2. Create a YAML file with parameters
`vi /tmp/secret.yml`
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secret-nautilus
  labels:
    name: myapp
spec:
  volumes:
    - name: secret-volume-nautilus
      secret:
        secretName: media
  containers:
    - name: secret-container-nautilus
      image: fedora:latest
      command: ["/bin/bash", "-c", "sleep 10000"]
      volumeMounts:
        - name: secret-volume-nautilus
          mountPath: /opt/demo
          readOnly: true
```


## 3. Create a pod
`kubectl create -f /tmp/secret.yml`
```console
pod/secret-nautilus created
```

`kubectl get pods`
```console
NAME              READY   STATUS    RESTARTS   AGE
secret-nautilus   1/1     Running   0          16s
```


## 4. Validate the task
`kubectl exec secret-nautilus -- cat /opt/demo/media.txt`
```console
5ecur3
```



```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:62c9526ad6a8358a74c3682d
```
