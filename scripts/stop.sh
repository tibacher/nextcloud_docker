#!/bin/sh
nc_path=$NEXTCLOUD_DOCKER
RC=0
sudo monit unmonitor nextcloud
sudo monit unmonitor nextcloud-local
cd $nc_path
/usr/bin/docker-compose down -v --remove-orphans || RC=1
exit $RC
