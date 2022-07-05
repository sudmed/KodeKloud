# Deploy Jenkins on Kubernetes

The Nautilus DevOps team is planning to set up a Jenkins CI server to create/manage some deployment pipelines for some of the projects. They want to set up the Jenkins server on Kubernetes cluster. Below you can find more details about the task:  
1) Create a namespace jenkins.  
2) Create a Service for jenkins deployment. Service name should be jenkins-service under jenkins namespace, type should be NodePort, nodePort should be 30008.  
3) Create a Jenkins Deployment under jenkins namespace, It should be name as jenkins-deployment , labels app should be jenkins , container name should be jenkins-container , use jenkins/jenkins image , containerPort should be 8080 and replicas count should be 1.  
Make sure to wait for the pods to be in running state and make sure you are able to access the Jenkins login screen in the browser before hitting the Check button.  
Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.  


## 1. On jump server
`kubectl get namespace`
```console
NAME                 STATUS   AGE
default              Active   71m
kube-node-lease      Active   71m
kube-public          Active   71m
kube-system          Active   71m
local-path-storage   Active   70m
```

`kubectl get service`
```console
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   71m
```


## 2. Create namespace
`kubectl create namespace jenkins`
```console
namespace/jenkins created
```

`kubectl get namespace`
```console
NAME                 STATUS   AGE
default              Active   71m
jenkins              Active   11s
kube-node-lease      Active   71m
kube-public          Active   71m
kube-system          Active   71m
local-path-storage   Active   71m
```
 
 
## 3. Create jenkins yaml file
`vi /tmp/jenkins.yaml`
```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: jenkins
---
apiVersion: v1
kind: Service
metadata:
  name: jenkins-service
  namespace: jenkins
spec:
  type: NodePort
  selector:
    app: jenkins
  ports:
    - port: 8080
      targetPort: 8080
      nodePort: 30008
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: jenkins-deployment
  namespace: jenkins
  labels:
    app: jenkins
spec:
  replicas: 1
  selector:
    matchLabels:
      app: jenkins
  template:
    metadata:
      labels:
        app: jenkins
    spec:
      containers:
      - name: jenkins-container
        image: jenkins/jenkins
        ports:
        - containerPort: 8080
```


## 4. Create a pod
`kubectl create -f /tmp/jenkins.yaml`
```console
namespace/jenkins created
service/jenkins-service created
deployment.apps/jenkins-deployment created
```

`kubectl get service`
```console
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   75m
```

`kubectl get pods`
```console
No resources found in default namespace.
```

`kubectl get namespace`
```console
NAME                 STATUS   AGE
default              Active   76m
jenkins              Active   45s
kube-node-lease      Active   76m
kube-public          Active   76m
kube-system          Active   76m
local-path-storage   Active   75m
```

`kubectl get pods --namespace jenkins`
```console
NAME                                  READY   STATUS    RESTARTS   AGE
jenkins-deployment-6b6c78f968-bcvw4   1/1     Running   0          58s
```


## 5. Get status
`kubectl get deploy --namespace jenkins`
```console
NAME                 READY   UP-TO-DATE   AVAILABLE   AGE
jenkins-deployment   1/1     1            1           73s
```

`kubectl get pods --namespace jenkins`
```console
NAME                                  READY   STATUS    RESTARTS   AGE
jenkins-deployment-6b6c78f968-bcvw4   1/1     Running   0          84s
```

`kubectl get service --namespace jenkins`
```console
NAME              TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
jenkins-service   NodePort   10.96.235.225   <none>        8080:30008/TCP   2m
```


## 6. Validate the task
`kubectl exec jenkins-deployment-6b6c78f968-bcvw4 --namespace jenkins -- curl http://localhost:8080`
  ```console
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   541  100   541    0     0    138      0  0:00:03  0:00:03 --:--:--   138
<html><head><meta http-equiv='refresh' content='1;url=/login?from=%2F'/><script>window.location.replace('/login?from=%2F');</script></head><body style='background-color:white; color:white;'>


Authentication required
<!--
-->

</body></html> 
```


`kubectl exec jenkins-deployment-6b6c78f968-bcvw4 --namespace jenkins -- cat /var/jenskins_home/secrets/initialAdminPassword`
```console
96fd8deeba8b4871b1bff735092611ac
```

`kubectl exec jenkins-deployment-6b6c78f968-bcvw4 --namespace jenkins -- curl --user admin:96fd8deeba8b4871b1bff735092611ac http://localhost:8080`
```console
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:01 --:--:--     0
  
  <!DOCTYPE html><html><head resURL="/static/14cb8c1c" data-rooturl="" data-resurl="/static/14cb8c1c" data-extensions-available="true" data-unit-test="false" data-imagesurl="/static/14cb8c1c/images" data-crumb-header="Jenkins-Crumb" data-crumb-value="27c9bd3a969d29653a3fd53f45af78f5545be4fab6b5d67c5d22025b3f006fa9">

    <title>Setup Wizard [Jenkins]</title><link rel="stylesheet" href="/static/14cb8c1c/jsbundles/styles.css" type="text/css"><link rel="stylesheet" href="/static/14cb8c1c/css/responsive-grid.css" type="text/css"><link rel="shortcut icon" href="/static/14cb8c1c/favicon.ico" type="image/vnd.microsoft.icon"><script src="/static/14cb8c1c/scripts/prototype.js" type="text/javascript"></script><script src="/static/14cb8c1c/scripts/behavior.js" type="text/javascript"></script><script src='/adjuncts/14cb8c1c/org/kohsuke/stapler/bind.js' type='text/javascript'></script><script src="/static/14cb8c1c/scripts/yui/yahoo/yahoo-min.js"></script><script src="/static/14cb8c1c/scripts/yui/dom/dom-min.js"></script><script src="/static/14cb8c1c/scripts/yui/event/event-min.js"></script><script src="/static/14cb8c1c/scripts/yui/animation/animation-min.js"></script><script src="/static/14cb8c1c/scripts/yui/dragdrop/dragdrop-min.js"></script><script src="/static/14cb8c1c/scripts/yui/container/container-min.js"></script><script src="/static/14cb8c1c/scripts/yui/connection/connection-min.js"></script><script src="/static/14cb8c1c/scripts/yui/datasource/datasource-min.js"></script><script src="/static/14cb8c1c/scripts/yui/autocomplete/autocomplete-min.js"></script><script src="/static/14cb8c1c/scripts/yui/menu/menu-min.js"></script><script src="/static/14cb8c1c/scripts/yui/element/element-min.js"></script><script src="/static/14cb8c1c/scripts/yui/button/button-min.js"></script><script src="/static/14cb8c1c/scripts/yui/storage/storage-min.js"></script><script src="/static/14cb8c1c/scripts/hudson-behavior.js" type="text/javascript"></script><script src="/static/14cb8c1c/scripts/sortable.js" type="text/javascript"></script><link rel="stylesheet" href="/static/14cb8c1c/scripts/yui/container/assets/container.css" type="text/css"><link rel="stylesheet" href="/static/14cb8c1c/scripts/yui/container/assets/skins/sam/container.css" type="text/css"><link rel="stylesheet" href="/static/14cb8c1c/scripts/yui/menu/assets/skins/sam/menu.css" type="text/css"><link rel="search" href="/opensearch.xml" type="application/opensearchdescription+xml" title="Jenkins"><meta name="ROBOTS" content="INDEX,NOFOLLOW"><meta name="viewport" content="width=device-width, initial-scale=1"><script src="/static/14cb8c1c/jsbundles/vendors.js" type="text/javascript"></script><script src="/static/14cb8c1c/jsbundles/page-init.js" type="text/javascript"></script><script src="/static/14cb8c1c/jsbundles/sortable-drag-drop.js" type="text/javascript"></script></head><body data-model-type="jenkins.install.SetupWizard" id="jenkins" class="yui-skin-sam full-screen jenkins-2.357" data-version="2.357"><div id="page-body" class="clear"><div id="main-panel"><a name="skip2content"></a><div class="plugin-setup-wizard-container"></div><script type="text/javascript">
    var defaultUpdateSiteId = 'default';
    var setupWizardExtensions = [];
    var onSetupWizardInitialized = function(extension) {
      setupWizardExtensions.push(extension);
    };
  </script><script src="/static/14cb8c1c/jsbundles/pluginSetupWizard.js" type="text/javascript"></script><link rel="stylesheet" href="/static/14cb8c1c/jsbundles/pluginSetupWizard.css" type=100  3579  100  3579    0     0   1536      0  0:00:02  0:00:02 --:--:--  1700
```


```bash
CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:62c3f09a5fc4c61c008c5f41
```
