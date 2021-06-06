#!/bin/bash

nc_version=$(docker inspect nextcloud:apache|grep NEXTCLOUD_VERSION -m1 | cut -d = -f 2 |cut -d \" -f 1)


echo "You will update to Nextcloud-Version: $nc_version"
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

#open directory
cd $NEXTCLOUD_DOCKER
#enable maintenace mode
bash $NEXTCLOUD_DOCKER/scripts/nextcloud_scripts/maintenance_enable.sh 

# make snapper create here
#N=$(snapper -c nextcloud create -d "NC update to $nc_version pre" -t pre -p)

# Stop nextcloud docker instance
sudo systemctl stop nextcloud.service


#pull docker image update
docker-compose pull

# Start nextcloud docker instance
sudo systemctl start nextcloud.service


docker exec -it -u www-data nc_cron php /var/www/html/occ upgrade


#snapper -c nextcloud create -d "NC update post" -t post --pre-number $N

#disable maintenace mode
bash $NEXTCLOUD_DOCKER/scripts/nextcloud_scripts/maintenance_disable.sh
