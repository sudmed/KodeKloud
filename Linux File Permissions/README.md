# Linux File Permissions

There are new requirements to automate a backup process that was performed manually by the xFusionCorp Industries system admins team earlier. To automate this task, the team has developed a new bash script xfusioncorp.sh. They have already copied the script on all required servers, 
however they did not make it executable on one the app server i.e App Server 3 in Stratos Datacenter.  
Please give executable permissions to /tmp/xfusioncorp.sh script on App Server 3. Also make sure every user can execute it.


`chmod o+rx /tmp/xfusioncorp.sh`  



```text
NB! Execution of a binary file needs read permission. Only root can exec file without read permission, but you were asked 'make sure EVERY user can'.  
chmod ugo+rx <file>
```
