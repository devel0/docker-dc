FROM searchathing/ubuntu

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

# build essential
RUN apt-get update && apt-get install -y build-essential

#-------------------
# samba (git)
#-------------------

# samba 4.7.5
RUN cd /usr/src && git clone https://github.com/samba-team/samba.git --branch samba-4.7.5 --single-branch
#
RUN apt-get install -y python-dev libgnutls28-dev libgpgme11-dev libacl1-dev libldap2-dev libpam0g-dev
RUN cd /usr/src/samba && \
	./configure --prefix=/usr --enable-fhs --sysconfdir=/etc --localstatedir=/var --libexecdir=/usr/lib/x86_64-linux-gnu --with-privatedir=/var/lib/samba/private  --with-smbpasswd-file=/etc/samba/smbpasswd --with-piddir=/var/run/samba --with-pammodulesdir=/lib/x86_64-linux-gnu/security --with-pam --with-syslog --with-utmp --with-winbind  --with-shared-modules=idmap_rid,idmap_ad,idmap_adex,idmap_hash,idmap_ldap,idmap_tdb2,vfs_dfs_samba4,auth_samba4 --with-automount --with-ldap --with-ads --with-dnsupdate --with-gpgme  --libdir=/usr/lib/x86_64-linux-gnu --with-modulesdir=/usr/lib/x86_64-linux-gnu/samba --datadir=/usr/share --with-lockdir=/var/run/samba --with-statedir=/var/lib/samba  --with-cachedir=/var/cache/samba --enable-avahi --disable-rpath --disable-rpath-install  --with-cluster-support --with-socketpath=/var/run/ctdb/ctdbd.socket --with-logdir=/var/log/ctdb --with-systemd &&  make && make install && \
	echo 'source /etc/environment' >> ~/.bashrc && \
	echo 'umask 0007' >> ~/.bashrc && \
	apt-get install -y autoconf && \
	cd /usr/src && git clone http://git.samba.org/cifs-utils.git && cd /usr/src/cifs-utils && autoreconf -fiv &&  ./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --with-piddir=/run/samba --with-pammodulesdir=/lib/x86_64-linux-gnu/security --enable-fhs &&  make && make install && \
	apt-get install -y krb5-user && \
	sed -i 's/passwd:\(\s*\)compat/passwd: compat files winbind/g' /etc/nsswitch.conf && \
	sed -i 's/group:\(\s*\)compat/group: compat files winbind/g' /etc/nsswitch.conf

RUN apt install tzdata && rm -f /etc/timezone && rm -f /etc/localtime && ln -s /usr/share/zoneinfo/Europe/Rome /etc/localtime && dpkg-reconfigure --frontend noninteractive tzdata
#RUN apt-get install -y openssh-server

#-------------------
# setup
#-------------------

RUN echo 'alias cp="cp -i"' >> /root/.bashrc && \
	echo 'alias mv="mv -i"' >> /root/.bashrc && \
	echo 'alias rm="rm -i"' >> /root/.bashrc && \
	echo 'HISTORY=1000000' >> /root/.bashrc && \
	echo 'PS1="[docker \h:\\w]\\\\$ "' >> /root/.bashrc && \
	echo 'if [ -f /etc/bash_completion ] && ! shopt -oq posix; then . /etc/bash_completion; fi' >> /root/.bashrc && \
	echo '"\e[1;5D": backward-word' >> /root/.inputrc && \
	echo '"\e[1;5C": forward-word' >> /root/.inputrc && \
	echo "source /etc/environment" >> /root/.bashrc

COPY crontab /var/spool/cron/crontabs/root
RUN chmod 600 /var/spool/cron/crontabs/root && chown root:crontab /var/spool/cron/crontabs/root
COPY environment /etc
COPY mycmd.sh /root/.entrypoint

ENTRYPOINT /root/.entrypoint
