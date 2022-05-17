# Linux Configure sudo
: '
We have some users on all app servers in Stratos Datacenter. Some of them have been assigned some new roles and responsibilities, 
therefore their users need to be upgraded with sudo access so that they can perform admin level tasks.
a. Provide sudo access to user james on all app servers.
b. Make sure you have set up password-less sudo for the user.
'


# Login on all app servers & switch to root user
ssh tony@stapp01
sudo -i

# Check user is existing & have sudo permission
id james

# Add user in sudoers
visudo
+++james   ALL=(ALL) NOPASSWD:ALL

# validate
su - james
sudo cat /etc/sudoers
	# ...	



CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:6283ab6370ee8e1c6fedf3b1




sudo -i
visudo
+++mark    ALL=(ALL)   NOPASSWD:ALL
