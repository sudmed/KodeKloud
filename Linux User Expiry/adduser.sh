# Linux User Expiry
: '
A developer anita has been assigned Nautilus project temporarily as a backup resource. As a temporary resource for this project, we need a temporary user for anita. 
It’s a good idea to create a user with a set expiration date so that the user won't be able to access servers beyond that point.
Therefore, create a user named anita on the App Server 1. Set expiry date to 2021-03-28 in Stratos Datacenter. 
'

cat /etc/passwd
grep anita /etc/passwd
useradd -e 2021-03-28 anita
grep anita /etc/passwd
grep anita /etc/shadow
chage -l anita
