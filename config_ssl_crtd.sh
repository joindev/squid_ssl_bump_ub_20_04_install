#!/bin/sh

if [ -d /etc/squid/ssl ]; then

    rm -r /etc/squid/ssl
fi

if [ -f /usr/sbin/security_file_certgen ]; then

    echo "0" > /dev/null 2>&1
else

    cp ./squid-4.10/src/security/cert_generators/file/security_file_certgen /usr/sbin/security_file_certgen
fi

mkdir  /etc/squid/ssl
cd     /etc/squid/ssl

openssl genrsa -out /etc/squid/ssl/squid.key
openssl req -new -key /etc/squid/ssl/squid.key -out /etc/squid/ssl/squid.csr
openssl x509 -req -days 36500 -in /etc/squid/ssl/squid.csr -signkey /etc/squid/ssl/squid.key -out /etc/squid/ssl/squid.pem
openssl x509 -in /etc/squid/ssl/squid.pem -outform DER -out squid.der

chown -R proxy:proxy /etc/squid/ssl

rm -rf /var/spool/squid_ssl_db
/usr/sbin/security_file_certgen -c -s /var/spool/squid_ssl_db -M 64MB
chown -R proxy:proxy /var/spool/squid_ssl_db

