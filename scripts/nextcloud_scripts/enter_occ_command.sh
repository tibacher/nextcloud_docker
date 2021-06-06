#!/bin/bash

if [ -z ${1+x} ]
then
  echo "Enter occ command..."
  read command

else
	command=$1
fi
docker exec -it -u www-data  nc_cron php /var/www/html/occ $command
