# docker-dc

samba 4 domain controller

## prerequisites

- [docker-ubuntu](https://github.com/devel0/docker-ubuntu)
- clear text user password ( must root owner and 600 mode ; `/security/dc01` will mounted read-only into container )
  - `/security/dc01/ldapquery`
  - `/security/dc01/itadmin` [ Domain Admins ]
  - `/security/dc01/localadmin` [ Local Admins ]
  - `/security/dc01/Administator` [ Administrators ]
- `/scripts/constants` : `ip_dc01_srv` docker ip address variable
- [letsencrypt](https://letsencrypt.org/) certificates
- working [dns](https://github.com/devel0/docker-dns-rpz) that translates correctly `dc01.my.local` and `dc01.example.com` to dc01 ip docker container address
- [firewall rules](https://github.com/devel0/linux-scripts-utils/blob/master/fw.sh) ( search for dc01 rules )

## configure

| file | token | replace with |
|---|---|---|
| [POST_INITIAL_SETTINGS](POST_INITIAL_SETTINGS) | `--max-pwd-age=90` | user password expiration ( default: 3 months ) |
| | `SomeCity` | organization city |
| | `Utenti` | organization user group name |
| | `@example.com` | mail domain |
| | `Some company` | organization description |
| | `createuser2 loginname FirstName LastName` | initial users one per row |
| | `loginname1` | name of user in Direction group |
| | `loginname2` | name of user in Administration (accounting) group |
| [build.sh](build.sh) | `my/dc01` | namespace image ( example: `searchathing/dc01` ) |
| [check-dns](check-dns) | `my` | domain controller name |
| [mycmd.sh](mycmd.sh) | `172.19.0.10` | docker ip address of domain controller |
| | `my.local` | domain controller name ( example: `searchathing.local` ) |
| | `example.com` | your own fqdn name ( example: `searchathing.com` ) |
| [organization-unit-ldif](organization-unit.ldif) | `DC=my` | domain controller name ( example: `DC=searchathing` ) |
| | `SomeCity` | see above |
| [query-user](query-user) | `dc=my` | see above |
| | `example.com` | see above |
| [resolv.conf](resolv.conf) | `my.local` | see above |
| [run.sh](run.sh) | `my/dc01` | see above |
| | `dc01.my.local` | see above |
| [smb.conf](smb.conf) | `DC01` | domain controller name ( uppercased ) |
| | `MY.LOCAL` | local domain name ( uppercased ) |
| | `example.com` | see above |
| | `MY` | domain name |
| [test-ldaps](test-ldaps) | `dc=my` | see above |
| | `DC=my` | see above |
| | `example.com` | see above |

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
