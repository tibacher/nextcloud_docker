#!/bin/bash


if [ -z ${1+x} ]
then
	while true
	do
  echo "Enter occ command:"
  while read command
	do
	if [[ $command == occ* ]] 
	then
    command=$(echo $command | sed 's/occ//')
	fi
	if [[ ! -z "$command" ]]
	then
	echo "Execute: occ $command"
		docker exec -it -u www-data  nc_cron php /var/www/html/occ $command
	else
		echo "No command found. Enter new one..."
	fi
	echo 
	echo 
	echo "Enter occ command:"
	done
	done
else
	command=$1
	if [[ $command == occ* ]] 
	then
    command=$(echo $command | sed 's/occ//')
	fi
	echo "Execute: occ $command"
	docker exec -it -u www-data  nc_cron php /var/www/html/occ $command
fi
