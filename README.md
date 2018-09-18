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

## build image

```
./build.sh
```

you can specify addictional docker build arguments, example:

```
./build.sh --network=dkbuild
```

## run image

follow create a test named container running an interactive bash terminal

```
docker run --name=test -ti searchathing/dotnet
```
