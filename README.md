
Для установки на голую ubuntu 20.04 сервера SQUID с возможность взлома и кеширования SSL-соединений
необходимо и достаточно:

1) установить из пакетов squid 
apt install squid

2) необходимо собрать кастомный squid с нужными опциями из исходников и подменить исполнимый файл
squid ( /usr/sbin/squid ) на собранный.
для этого:
- сначала запускаем скрипт apt_install.sh , который установит все пакеты, необходимые для сборки кастомного squid
- после этого запускаем файл download_and_buid_squid.sh, который скачает и соберёт исходники squid.
после этого в папке squid-4.10/src будет находиться файл squid-4.10/src/squid, на который и нужно подменить
штатный /usr/sbin/squid
- после этого запускаем файл config_ssl_crtd.sh, который настроит демон генерации сертификатов.
демон генерации сертификатов будет по запросу squid генерировать сертификаты для доменов, которые 
squid будет проксировать по защищённым соединениям. по сути squid будет осуществлять атаку "Man in the middle"
( https://uk.wikipedia.org/wiki/%D0%90%D1%82%D0%B0%D0%BA%D0%B0_%C2%AB%D0%BB%D1%8E%D0%B4%D0%B8%D0%BD%D0%B0_%D0%BF%D0%BE%D1%81%D0%B5%D1%80%D0%B5%D0%B4%D0%B8%D0%BD%D1%96%C2%BB ) с подменой сертификата на специально сгенерированный под атакуемый домен.
дабы клиенты ничего не заподозрили, клиентскому ПО ( браузеру ) необходимо скормить корневой сертификат squid как доверенный.
этот сертификат находится по пути /etc/squid/ssl/squid.pem .
- после этого необходимо создать символическую ссылку на файл /usr/share/squid/mime.conf  в каталоге /etc/squid
- после создания ссылки, правим конфиг squid примерно так:


```C

    ### конфликтует с systemd
    ### pid_filename /var/run/squid/squid.pid

    coredump_dir /var/spool/squid
    access_log stdio:/var/log/squid/squid.log
    http_port 3128  ssl-bump generate-host-certificates=on dynamic_cert_mem_cache_size=64MB cert=/etc/squid/ssl/squid.pem key=/etc/squid/ssl/squid.key


    ##############

    ## http_port 3129 intercept
    ## https_port 3130 intercept ssl-bump generate-host-certificates=on dynamic_cert_mem_cache_size=64MB cert=/etc/squid/ssl/squid.pem key=/etc/squid/ssl/squid.key
    sslproxy_cert_error allow all
    ## sslproxy_flags DONT_VERIFY_PEER

    always_direct allow all

    ssl_bump server-first all
    ssl_bump none all
    sslcrtd_program /usr/sbin/security_file_certgen -s /var/spool/squid_ssl_db -M 64MB

    ##############


    via off
    forwarded_for off

    ##shutdown_lifetime 10

    dns_v4_first on

    http_access allow all


    cache_dir ufs /var/spool/squid 4096 16 16
    maximum_object_size 1024 MB
    minimum_object_size 0
    maximum_object_size_in_memory 512 KB

    ##cache_peer usa.rotating.proxyrack.net parent 333 0 no-query default login=joinup_hetzner_gmail_com:d04532-ab8cb8-9f8eb4-151646-1ab4a1

    request_header_access From deny all
    request_header_access Server deny all
    request_header_access WWW-Authenticate deny all
    request_header_access Link deny all
    request_header_access Cache-Control deny all
    request_header_access Proxy-Connection deny all
    request_header_access X-Cache deny all
    request_header_access X-Cache-Lookup deny all
    request_header_access Via deny all
    request_header_access X-Forwarded-For deny all
    request_header_access Pragma deny all
    request_header_access Keep-Alive deny all


    acl IMG_FILES    url_regex -i \.jpeg$ \.jpeg\?$ \.jpg$ \.jpg\?$ \.gif$ \.gif\?$ \.png$ \.png\?$
    acl VIDEO_FILES  url_regex -i \.avi$  \.avi\?$  \.mpg$ \.mpg\?$ \.mp4$ \.mp4\?$ \.swf$ \.swf\?$ \.mpeg$ \.mpeg\?$
    acl SOUND_FILES  url_regex -i \.mp3$  \.asf$ \.wma$  \.mp3\?$  \.asf\?$ \.wma\?$
    acl FONT_FILES   url_regex -i \.woff2$ \.fnt$ \.fon$ \.otf$ \.ttf$
    acl CSS_FILES    url_regex -i \.css$ \.css\?$
    acl JS_FILES     url_regex -i \.js$ \.js\?$


    #never_direct allow all

    #acl imgacl urlpath_regex  \.png$

    cache allow  IMG_FILES
    cache allow  VIDEO_FILES
    cache allow  SOUND_FILES
    cache allow  FONT_FILES
    cache allow  CSS_FILES
    cache allow  JS_FILES


    refresh_pattern -i .+$ 43200 100% 432000 override-lastmod override-expire reload-into-ims ignore-reload

    cache deny all
```



