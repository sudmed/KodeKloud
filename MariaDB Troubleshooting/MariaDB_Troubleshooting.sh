# MariaDB Troubleshooting

systemctl status mariadb
systemctl start mariadb
# /var/log/mariadb/mariadb.log

systemctl status mariadb.service
journalctl -xe -u mariadb

cd /var/lib
chown -R mysql:mysql mysql
systemctl start mariadb
systemctl status mariadb
