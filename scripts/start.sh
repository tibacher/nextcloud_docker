#!/bin/sh
RC=0

cd $NEXTCLOUD_DOCKER
/usr/bin/docker-compose up -d || RC=1

# optional start monit
sleep 120 && sudo monit monitor nextcloud & sudo monit monitor nextcloud-local &

exit $RC
