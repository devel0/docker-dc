#!/bin/bash

source /etc/environment

# nothing for others
umask 0007

# dc docker ip
host_ip=172.19.0.10

if [ ! -e /root/initialized ]; then
	if [ -e /security/dc01/root ]; then
		echo "set ssh service"
		sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config

		echo "setup root pass"
		echo "root:`cat /security/dc01/root`" | chpasswd
	fi

	#---------------------
	# domain provisioning
	#---------------------

	DEBUG_LEVEL=0

	rm -f /dk/smb.conf /etc/samba/smb.conf
	touch /dk/smb.conf
	echo "creating symlink /etc/samba/smb.conf"
        ln -s ../../dk/smb.conf /etc/samba/smb.conf

	echo
	echo "---> setup /etc/hosts [BEFORE]"
	cat /etc/hosts
	echo "---> setup /etc/hosts [AFTER]"
	cat /etc/hosts | grep -v dc01 > /tmp/t ; cat /tmp/t > /etc/hosts
	echo "$host_ip dc01.my.local dc01" >> /etc/hosts
	cat /etc/hosts

	echo
	echo "---> bind [BEFORE]"
	netstat -tpln

	echo
	echo "domain provision"
	samba-tool domain provision \
		-d $DEBUG_LEVEL \
		--use-rfc2307 \
		--realm=my.local \
		--domain=my \
		--server-role=dc \
		--host-ip=$host_ip \
		--dns-backend=SAMBA_INTERNAL \
		--option="dns forwarder = 8.8.8.8" \
		--option="load printers = no" \
		--option="printcap name = /dev/null" \
		--option="tls cafile = /etc/letsencrypt/live/srv0.example.com/root.pem" \
		--option="tls certfile = /etc/letsencrypt/live/srv0.example.com/fullchain.pem" \
		--option="tls keyfile = /etc/letsencrypt/live/srv0.example.com/privkey.pem" \
		--adminpass=$(cat /security/dc01/Administrator) && \
        cp -f /var/lib/samba/private/krb5.conf /etc

	touch /root/initialized
fi

# --option="wins support = yes" \

cp -f /dk/resolv.conf /etc
#touch /root/docker-fs

# start services
service rsyslog start
service cron start
if [ -e /root/initialized ]; then service supervisor start; fi
service ntp start
#service ssh start

if [ -e /root/initialized ]; then
	echo "restarting samba"
	restart_samba
fi

echo
echo
echo "===> SERVER READY <==="
echo
echo "press ctrl+c to stop docker logs and return to shell"
echo
echo "- dk-exec dc01 to enter container"
echo "- /dk/POST_INITIAL_SETTINGS to reset samba group policy base"
echo "======================"
echo

echo
echo "---> check-dns"
/dk/check-dns
echo

tail -f /var/log/samba/*
