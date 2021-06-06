#!/bin/sh
RC=0

nextcloud_docker_path=`realpath $(dirname $(readlink -f $0))/../`
cd $nextcloud_docker_path

/usr/bin/docker-compose up -d || RC=1

# optional start monit
sleep 120 && sudo monit monitor nextcloud & sudo monit monitor nextcloud-local &

exit $RC
