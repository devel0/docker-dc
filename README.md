# docker-dotnet

samba 4 domain controller

## prerequisites

- [docker-ubuntu](https://github.com/devel0/docker-ubuntu)
- `/security/dc01/ldapquery` : clear text `ldapquery` user password ( must 600 mode )
- `/security/dc01/itadmin` : clear text `itadmin` user password ( must 600 mode ) [ Domain Admins ]
- `/security/dc01/localadmin` : clear text `localadmin` user password ( must 600 mode ) [ Local Admins ]
- `/security/dc01/Administator` : clear text `Administrator` user password ( must 600 mode ) [ Administrators ]
- `/scripts/constants` : `ip_dc01_srv` docker ip address variable
- [letsencrypt](https://letsencrypt.org/) certificates
- working [dns](https://github.com/devel0/docker-dns-rpz) that translates correctly `dc01.my.local` and `dc01.example.com` to dc01 ip docker container address

## install

```
./build.sh
./run.sh
```

follow message will appears

``
===> SERVER READY <===

press ctrl+c to stop docker logs and return to shell

- dk-exec dc01 to enter container
- /dk/POST_INITIAL_SETTINGS to reset samba group policy base
======================
```

- hit ctrl+c to exit logging dc01
- enter the container `dk-exec dc01`
- `/dk/POST_INITIAL_SETTINGS`
