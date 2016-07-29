# App BIND

Zabbix 3.x template for stats collection from BIND 9 named service

## How to install (tested on CentOS):
* Import the xml template into Zabbix 3
* Copy named-stats.sh to /usr/local/share/zabbix/externalscripts/ (or another dir & change path into named-stats.sh)
* Copy userparameter_named.conf to /etc/zabbix/zabbix_agentd.d/
* Configure Bind to export statistics in file /var/named/data/named_stats.txt by adding the following to your /var/named/chroot/etc/named.conf:
```
options {
    statistics-file "/var/named/data/named_stats.txt";
};
```
* Restarting named and zabbix-agent daemons

## Screenshots

![ScreenShot](https://raw.github.com/aGGre55or/zabbix-app-bind/master/screenshots/zabbix-app-bind.png)
