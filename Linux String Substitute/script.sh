# Linux String Substitute

: '
The backup server in the Stratos DC contains several template XML files used by the Nautilus application. 
However, these template XML files must be populated with valid data before they can be used. One of the daily tasks of a system admin working in the 
xFusionCorp industries is to apply string and file manipulation commands!
Replace all occurances of the string Text to Cloud on the XML file /root/nautilus.xml located in the backup server.
'


sed -i 's/Text/Cloud/g' /root/nautilus.xml
