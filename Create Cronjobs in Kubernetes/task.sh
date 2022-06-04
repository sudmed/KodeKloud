# Create Cronjobs in Kubernetes

: '
There are some jobs/tasks that need to be run regularly on different schedules. Currently the Nautilus DevOps team is working 
on developing some scripts that will be executed on different schedules, but for the time being the team is creating some 
cron jobs in Kubernetes cluster with some dummy commands (which will be replaced by original scripts later). 
Create a cronjob as per details given below:
Create a cronjob named datacenter.
Set schedule to */12 * * * *.
Container name should be cron-datacenter.
Use httpd image with latest tag only and remember to mention the tag i.e httpd:latest.
Run a dummy command echo Welcome to xfusioncorp!.
Ensure restart policy is OnFailure.
Note: The kubectl utility on jump_host has been configured to work with the kubernetes cluster.
'


# check the existing pod & cronjob
kubectl get pods
kubectl get cronjob

vi /tmp/cron.yml
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: datacenter
spec:
  schedule: "*/12 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
            - name: cron-datacenter
              image: httpd:latest
              command:
                - /bin/sh
                - -c
                - echo Welcome to xfusioncorp!
          restartPolicy: OnFailure


# create a pod
kubectl create -f /tmp/cron.yml

# check
kubectl get cronjob
kubectl get pods
	datacenter-1654374240-8jp5z

# validate
kubectl logs datacenter-1654374240-8jp5z



CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:629b2de51f2a621079943963
