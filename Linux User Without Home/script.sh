Linux User Without Home
: '
The system admins team of xFusionCorp Industries has set up a new tool on all app servers, 
as they have a requirement to create a service user account that will be used by that tool. 
They are finished with all apps except for App Server 2 in Stratos Datacenter.
Create a user named javed in App Server 2 without a home directory.
'

#useradd -M username
useradd -M javed
cat /etc/passwd


# Parameters are case-sensitive.  
```bash
useradd -M ammar
```
