### Selinux Installation
: '
The xFusionCorp Industries security team recently did a security audit of their infrastructure and came up with ideas to improve the application and server security. 
They decided to use SElinux for an additional security layer. They are still planning how they will implement it; however, they have decided to start testing with app 
servers, so based on the recommendations they have the following requirements:
Install the required packages of SElinux on App server 3 in Stratos Datacenter and disable it permanently for now; 
it will be enabled after making some required configuration changes on this host. 
Don't worry about rebooting the server as there is already a reboot scheduled for tonight's maintenance window. 
Also ignore the status of SElinux command line right now; the final status after reboot should be disabled.
'


# Install the SElinux
yum install selinux* -y

# Check the existing SElinux status
sestatus
#Out:  SELinux status:                 disabled

cat /etc/selinux/config | grep SELINUX
#Out:
: '
# SELINUX= can take one of these three values:
  SELINUX=enforcing
  # SELINUXTYPE= can take one of three values:
  SELINUXTYPE=targeted
'

# Edit the /etc/selinux/config file and correct it
vi /etc/selinux/config
#Out:  SELINUX=disabled

# Validate the task by sestatus
sestatus
#Out:  SELinux status:                 disabled


/etc/selinux/config
```bash
-SELINUX=enforcing
+SELINUX=disabled
```
# or
setenforce 0 && sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config



Install the SElinux package first:
```console
yum install -y selinux*
```
And after you can disable it:
```console
setenforce 0 && sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
```
