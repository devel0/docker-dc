#!/bin/bash

#set -x

source /scripts/constants
source /etc/environment
source /scripts/utils.sh
exdir=$(executing_dir)

container=dc01
container_image=my/dc01
#container_data=/nas/data/xxx

#net=host
net=dc01

#ip=
ip=$ip_dc01_srv

#privileged="--cap-add=SYS_ADMIN --cap-add=SYS_TIME --cap-add=SYSLOG"
privileged="--privileged"

cpus="4"
memory="2g"

dk-rm-if-exists $container

args_ip=""
if [ "$ip" != "" ]; then args_ip="--ip=$ip"; fi

docker run \
	-d \
	-ti \
	-e TZ=`cat /etc/timezone` \
	--name "$container" \
        --network="$net" \
	$privileged \
	$args_ip \
        --restart="unless-stopped" \
        --cpus="$cpus" \
        --memory="$memory" \
	--hostname=dc01.my.local \
	--volume="/etc/letsencrypt:/etc/letsencrypt:ro" \
	--volume="/security/dc01:/security/dc01" \
	--volume="$exdir:/dk" \
        "$container_image"

docker logs -f "$container"
