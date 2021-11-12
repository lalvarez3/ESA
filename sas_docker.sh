#!/bin/bash

#set -xe

COMMAND=$@


echo "SAS_DOCKER_IMAGE == ${SAS_DOCKER_IMAGE:=juliojlgon/sas:latest}"
echo "SAS_DOCKER_PULL == \"${SAS_DOCKER_PULL:=no}\""
echo "SAS_DOCKER_PORT == ${SAS_DOCKER_PORT:=8880}\""

[ "x$SAS_DOCKER_PULL" == "xyes" ] && {
    echo "will update image (set SAS_DOCKER_PULL to anything but \"yes\" to stop this)"
    docker pull $SAS_DOCKER_IMAGE
}

echo "."
echo "."
echo "using WORKDIR: ${WORKDIR:=$PWD}"


[ -s /tmp/.X11-unix ] || { echo "no /tmp/.X11-unix? no X? not allowed!"; }

mkdir -pv $WORKDIR/pfiles

docker run \
    -p ${SAS_DOCKER_PORT}:${SAS_DOCKER_PORT} \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v $WORKDIR:/home/heasoft \
    --rm -it  --user $(id -u) \
        ${SAS_DOCKER_IMAGE} bash -c "

export HOME=/home/heasoft

cd \$HOME
. /usr/local/bin/init.sh
. /usr/local/bin/init_sas.sh

echo -e '\\e[31mrunning\\e[37m $COMMAND\\e[0m'

$COMMAND
"
