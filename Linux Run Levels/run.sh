# Linux Run Levels
: '
New tools have been installed on the app server in Stratos Datacenter. Some of these tools can only be managed from the graphical user interface. 
Therefore, there are requirements for these app servers.
On all App servers in Stratos Datacenter change the default runlevel so that they can boot in GUI (graphical user interface) by default. 
Please do not try to reboot these servers
'

# Чтобы узнать текущий уровень выполнения достаточно ввести команду runlevel
runlevel
  # N 3

# В прошлом для этого приходилось редактировать файл /etc/inittab. Вы еще можете увидеть эту практику на некоторых системах.
vi /etc/inittab

# Чтобы проверить текущий уровень выполнения по умолчанию
systemctl get-default

# Чтобы просмотреть остальные "target" и уровни выполнения, ассоциированные с ними
# ls -l /lib/systemd/system/runlevel*

# чтобы поменять уровень выполнения по умолчанию, надо создать новую символьную ссылку на интересующую нас цель systemd
# ln -sf /lib/systemd/system/runlevel3.target /etc/systemd/system/default.target

# change the run level to graphical.target
systemctl set-default graphical.target
systemctl start graphical.target
systemctl status graphical.target
systemctl get-default


# Do on each App server:
```bash
systemctl set-default graphical.target && systemctl start graphical.target
```
