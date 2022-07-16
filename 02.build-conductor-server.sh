#!/bin/sh

# Display commands and exit on error
set -ex 

die () {
    echo >&2 "$@"
    exit 1
}

[ "$#" -eq 2 ] || die "2 arguments are required: 1. specifying conductor tag in the format of vX.Y.Z; 2. specify the startup.sh script type [local,redis,postgres], $# provided"

CONDUCTOR_VERSION=$1
START_TYPE=$2
START_SCRIPT=
if [ $START_TYPE = 'local' ];then
	START_SCRIPT="startup.sh"
else
	START_SCRIPT=startup-$START_TYPE.sh
fi

echo "using $START_SCRIPT to build docker image"

# Copy config and startup files
cd conductor-$CONDUCTOR_VERSION/docker
# Build Conductor Server
docker build -t conductor:server-$START_TYPE -f server/Dockerfile --build-arg start_script=$START_SCRIPT ../
