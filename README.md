# App BIND

Zabbix 3.x template for stats collection from BIND 9 named service

## How to install (tested on CentOS 6.8):
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

# App Nginx

Zabbix 3.x template for stats collection from Nginx 1.x service

## How to install (tested on CentOS 6.8):
* Import the xml template into Zabbix 3
* Copy nginx-stats.sh to /usr/local/share/zabbix/externalscripts/ (or another dir & change path into nginx-stats.sh)
* Copy userparameter_nginx.conf to /etc/zabbix/zabbix_agentd.d/
* Configure Ngix Stub Status (https://nginx.org/ru/docs/http/ngx_http_stub_status_module.html)
```
        # Configure nginx status server
        server {
                listen          127.0.0.1:8885;
                server_name     monitor;
                server_name_in_redirect off;
                access_log      off;

                location  / {
                        stub_status on;
                        access_log   off;
                        allow 127.0.0.1;
                        deny all;
                }
        }
```
# App PHP-FPM

Zabbix 3.x template for stats collection from PHP-FPM 5.6.x and later service

## How to install (tested on CentOS 6.8):
* Import the xml template into Zabbix 3
* Copy php-fpm-stats.sh to /usr/local/share/zabbix/externalscripts/ (or another dir & change path into php-fpm-stats.sh)
* Copy userparameter_php-fpm.conf to /etc/zabbix/zabbix_agentd.d/
* Configure PHP-FPM status for your pool (ex. /etc/php-fpm.d/www.conf)
```
pm.status_path = /php
```
* Configure PHP-FPM status page for your web-server (ex. /etc/nginx/nginx.conf)
```
        # php-fpm status page
        location ~ ^/(php)$ {
              access_log off;
              allow 127.0.0.1;
              allow 192.168.0/24;
              deny all;
              fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
              include fastcgi_params;
              fastcgi_pass socket;
        }
```
