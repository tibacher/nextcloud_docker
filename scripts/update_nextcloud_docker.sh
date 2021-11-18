#!/bin/bash

#open directory
nextcloud_docker_path=`realpath $(dirname $(readlink -f $0))/../`
cd $nextcloud_docker_path


source .env


nc_version=$(docker inspect $WEB_DOCKER_IMAGE|grep NEXTCLOUD_VERSION -m1 | cut -d = -f 2 |cut -d \" -f 1)


echo "Your current Nextcloud-Version: $nc_version"
echo
echo "Do you want to procced?"

select opt in yes no
do
    case $opt in
        "yes")
            echo "update..."
			break
            ;;
        "no")
            echo "exit..."
			exit 1
            ;;
        *) echo "invalid option $REPLY";;
    esac
done


# uncomment to interupt
# exit 0

#enable maintenace mode
#bash $nextcloud_docker_path/scripts/nextcloud_scripts/maintenance_enable.sh 

# make snapper create here
N=$(snapper -c docker create -d "NC update to $nc_version pre" -t pre -p)

# Stop nextcloud docker instance
sudo systemctl stop nextcloud.service


#pull docker image update
docker-compose pull

# Start nextcloud docker instance
sudo systemctl start nextcloud.service


docker exec -it -u www-data nc_cron php /var/www/html/occ upgrade


snapper -c docker create -d "NC update post" -t post --pre-number $N

#disable maintenace mode
#bash $nextcloud_docker_path/scripts/nextcloud_scripts/maintenance_disable.sh
