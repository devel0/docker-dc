# docker-dotnet

samba 4 domain controller

## prerequisites

- [docker-ubuntu](https://github.com/devel0/docker-ubuntu)
- clear text user password ( must root owner and 600 mode )
  - `/security/dc01/ldapquery`
  - `/security/dc01/itadmin` [ Domain Admins ]
  - `/security/dc01/localadmin` [ Local Admins ]
  - `/security/dc01/Administator` [ Administrators ]
- `/scripts/constants` : `ip_dc01_srv` docker ip address variable
- [letsencrypt](https://letsencrypt.org/) certificates
- working [dns](https://github.com/devel0/docker-dns-rpz) that translates correctly `dc01.my.local` and `dc01.example.com` to dc01 ip docker container address

## install

```
./build.sh
./run.sh
```

follow message will appears

```
===> SERVER READY <===

press ctrl+c to stop docker logs and return to shell

- dk-exec dc01 to enter container
- /dk/POST_INITIAL_SETTINGS to reset samba group policy base
======================
```

- hit ctrl+c to exit logging dc01
- enter the container `dk-exec dc01`
- `/dk/POST_INITIAL_SETTINGS`
