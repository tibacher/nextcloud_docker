#!/bin/sh
RC=0

docker_path=`realpath $(dirname $(readlink -f $0))/../`
cd $docker_path

docker compose up -d || RC=1

# optional start monit
sleep 240 && sudo monit monitor nextcloud & sudo monit monitor nextcloud-local &

exit $RC
