# Linux Collaborative Directories
: '
The Nautilus team doesn't want its data to be accessed by any of the other groups/teams due to security reasons and want their data to be strictly accessed by the dbadmin group of the team.
Setup a collaborative directory /dbadmin/data on Nautilus App 2 server in Stratos Datacenter.
The directory should be group owned by the group dbadmin and the group should own the files inside the directory. The directory should be read/write/execute to the group owners, and others should not have any access.
'


mkdir -p /dbadmin/data
chown root:dbadmin /dbadmin/data
chmod 770 /dbadmin/data
