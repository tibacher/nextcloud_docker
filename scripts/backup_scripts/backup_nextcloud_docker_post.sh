#!/bin/bash
export HOME=unkown

#rm $(ls -1t /home/tim/workspace/docker/nextcloud_docker/db/mysql/nextcloud-sqlbkp_* | tail -n +2)
docker exec nc_db bash -c 'rm $(ls -1t /var/lib/mysql/$(cat $MYSQL_DATABASE_FILE)-sqlbkp_* | tail -n +2)'


scripts_path=`realpath $(dirname $(readlink -f $0))/../`
# disable maintanace mode
bash $scripts_path/nextcloud_scripts/maintenance_disable.sh
#docker exec --user www-data nc_web php occ maintenance:mode -q --off

sleep 120 && monit monitor nextcloud & monit monitor nextcloud-local &

