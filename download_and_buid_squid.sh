#!/bin/sh

if [ -d ./squid-4.10 ]; then

    rm -r ./squid-4.10
fi



wget -O ./squid-4.10.tar.gz  http://www.squid-cache.org/Versions/v4/squid-4.10.tar.gz

tar -zxvf ./squid-4.10.tar.gz

cd ./squid-4.10

./configure \
\
'--with-openssl' \
'--enable-ssl-crtd' \
'--build=x86_64-linux-gnu' \
'--prefix=/usr' \
'--includedir=${prefix}/include' \
'--mandir=${prefix}/share/man' \
'--infodir=${prefix}/share/info' \
'--sysconfdir=/etc' \
'--localstatedir=/var' \
'--libexecdir=${prefix}/lib/squid' \
'--srcdir=.' \
'--disable-maintainer-mode' \
'--disable-dependency-tracking' \
'--disable-silent-rules' \
'BUILDCXXFLAGS=-g -O2 -fdebug-prefix-map=/build/squid-vL9JDp/squid-4.10=. -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -D_FORTIFY_SOURCE=2 -Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,-z,now -Wl,--as-needed' \
'BUILDCXX=x86_64-linux-gnu-g++' \
'--with-build-environment=default' \
'--enable-build-info=Ubuntu linux' \
'--datadir=/usr/share/squid' \
'--sysconfdir=/etc/squid' \
'--libexecdir=/usr/lib/squid' \
'--mandir=/usr/share/man' \
'--enable-inline' \
'--disable-arch-native' \
'--enable-async-io=8' \
'--enable-storeio=ufs,aufs,diskd,rock' \
'--enable-removal-policies=lru,heap' \
'--enable-delay-pools' \
'--enable-cache-digests' \
'--enable-icap-client' \
'--enable-follow-x-forwarded-for' \
'--enable-auth-basic=DB,fake,getpwnam,LDAP,NCSA,NIS,PAM,POP3,RADIUS,SASL,SMB' \
'--enable-auth-digest=file,LDAP' \
'--enable-auth-negotiate=kerberos,wrapper' \
'--enable-auth-ntlm=fake,SMB_LM' \
'--enable-external-acl-helpers=file_userip,kerberos_ldap_group,LDAP_group,session,SQL_session,time_quota,unix_group,wbinfo_group' \
'--enable-security-cert-validators=fake' \
'--enable-storeid-rewrite-helpers=file' \
'--enable-url-rewrite-helpers=fake' \
'--enable-eui' \
'--enable-esi' \
'--enable-icmp' \
'--enable-zph-qos' \
'--enable-ecap' \
'--disable-translation' \
'--with-swapdir=/var/spool/squid' \
'--with-logdir=/var/log/squid' \
'--with-pidfile=/var/run/squid.pid' \
'--with-filedescriptors=65536' \
'--with-large-files' \
'--with-default-user=proxy' \
'--with-gnutls' \
'--enable-linux-netfilter' \
'build_alias=x86_64-linux-gnu' \
'CC=x86_64-linux-gnu-gcc' \
'CFLAGS=-g -O2 -fdebug-prefix-map=/build/squid-vL9JDp/squid-4.10=. -fstack-protector-strong -Wformat -Werror=format-security -Wall' 'LDFLAGS=-Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,-z,now -Wl,--as-needed' \
'CPPFLAGS=-Wdate-time -D_FORTIFY_SOURCE=2' 'CXX=x86_64-linux-gnu-g++' \
'CXXFLAGS=-g -O2 -fdebug-prefix-map=/build/squid-vL9JDp/squid-4.10=. -fstack-protector-strong -Wformat -Werror=format-security'


make

















