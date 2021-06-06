#!/bin/bash
export HOME=unkown

scripts_path=`realpath $(dirname $(readlink -f $0))/../`
# enable maintanace mode
bash $scripts_path/nextcloud_scripts/maintenance_enable.sh

# Create new sql dump backup
docker exec nc_db bash -c 'mysqldump --single-transaction -u$(cat $MYSQL_USER_FILE) -p$(cat $MYSQL_PASSWORD_FILE) $(cat $MYSQL_DATABASE_FILE) > /var/lib/mysql/$(cat $MYSQL_DATABASE_FILE)-sqlbkp_`date +"%Y%m%d"`.bak'
