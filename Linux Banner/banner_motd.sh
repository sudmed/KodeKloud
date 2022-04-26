### Linux Banner
# MOTD — Message Of The Day
: '
During the monthly compliance meeting, it was pointed out that several servers in the Stratos DC do not have a valid banner. 
The security team has provided serveral approved templates which should be applied to the servers to maintain compliance. 
These will be displayed to the user upon a successful login. 
Update the message of the day on all application and db servers for Nautilus. 
Make use of the approved template located at /tmp/nautilus_banner on jump host
'


# On Jump Server
# Copy the /tmp/nautilus_banner using scp command from jumpserver to all Apps & DB servers
ll /tmp/nautilus_banner
sudo scp -r /tmp/nautilus_banner tony@stapp01:/tmp
sudo scp -r /tmp/nautilus_banner steve@stapp02:/tmp
sudo scp -r /tmp/nautilus_banner banner@stapp03:/tmp
sudo scp -r /tmp/nautilus_banner peter@stdb01:/tmp

# on Nautilus DB Server
ssh peter@stdb01 
sudo yum install openssh-clients -y
sudo mv nautilus_banner /etc/motd

# do SSH to each app Server
ssh tony@stapp01
ssh steve@stapp02
ssh banner@stapp03

# Type the below code on each app server
sudo mv nautilus_banner /etc/motd


### Validate login all the server's & check banner implemented successfully as per the task request
: '
################################################################################################
       .__   __.      ___      __    __  .___________. __   __       __    __       _______.   #
       |  \ |  |     /   \    |  |  |  | |           ||  | |  |     |  |  |  |     /       |   #
       |   \|  |    /  ^  \   |  |  |  | `---|  |----`|  | |  |     |  |  |  |    |   (----`   #
       |  . `  |   /  /_\  \  |  |  |  |     |  |     |  | |  |     |  |  |  |     \   \       #
       |  |\   |  /  _____  \ |  `--'  |     |  |     |  | |  `----.|  `--'  | .----)   |      #
       |__| \__| /__/     \__\ \______/      |__|     |__| |_______| \______/  |_______/       #
                                                                                               #
                                                                                               #
                                                                                               #
                                                                                               #
                                     # #  ( )                                                  #
                                  ___#_#___|__                                                 #
                              _  |____________|  _                                             #
                       _=====| | |            | | |==== _                                      #
                 =====| |.---------------------------. | |====                                 #
   <--------------------'   .  .  .  .  .  .  .  .   '--------------/                          #
     \                                                             /                           #
      \_______________________________________________WWS_________/                            #
  wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww                        #
wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww                       #
   wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww                         #
                                                                                               #
                                                                                               #
################################################################################################
Warning! All Nautilus systems are monitored and audited. Logoff immediately if you are not authorized!
'
