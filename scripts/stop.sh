#!/bin/sh
RC=0

docker_path=`realpath $(dirname $(readlink -f $0))/../`
cd $docker_path

sudo monit unmonitor nextcloud
sudo monit unmonitor nextcloud-local

/usr/bin/docker-compose down -v --remove-orphans || RC=1
exit $RC
