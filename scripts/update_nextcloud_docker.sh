#!/bin/bash

#open directory
nextcloud_docker_path=`realpath $(dirname $(readlink -f $0))/../`
cd $nextcloud_docker_path

source .env

LOCAL_IMAGE="nextcloud"
DOCKERHUB_LIST_TAGS=($(wget -q https://registry.hub.docker.com/v1/repositories/$LOCAL_IMAGE/tags -O - | sed -e 's/[][]//g' -e 's/"//g' -e 's/ //g' | tr '}' '\n'  | awk -F: '{print $3}' | grep '^[0-9]' | grep -v '-' | grep -v '\.[0-9]\.'))


echo "***** PLEASE DONT UPGRADE MULITPLE MAJOR VERSIONS *****"

echo "Available Nextcloud versions: ${DOCKERHUB_LIST_TAGS[*]: -20 : 18}"  

echo "Your desired tag: $WEB_DOCKER_IMAGE"
 
nc_version=$(docker inspect $WEB_CONTAINER_NAME|grep NEXTCLOUD_VERSION -m1 | cut -d = -f 2 |cut -d \" -f 1)


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
bash $nextcloud_docker_path/scripts/backup_scripts/backup_nextcloud_docker_pre.sh 

# make snapper create here
#N=$(snapper -c docker create -d "NC update to $nc_version pre" -t pre -p)

# Stop nextcloud docker instance

echo "Stopping Nextcloud..."

sudo systemctl stop nextcloud.service
sleep 5
docker compose down --remove-orphans  

echo "Nextcloud has been stopped!"

# pull docker image update
docker compose pull

nc_version=$(docker inspect $WEB_DOCKER_IMAGE|grep NEXTCLOUD_VERSION -m1 | cut -d = -f 2 |cut -d \" -f 1)
echo "You will update to Nextcloud-Version: $nc_version"
echo
echo "Do you want to procced with a start of nextcloud upgrade?"

select opt in yes no
do
    case $opt in
        "yes")
            echo "start nextcloud..."
			break
            ;;
        "no")
            # Start nextcloud docker instance
            docker compose up -d
            sudo systemctl start nextcloud.service 
            sleep 5
            bash $nextcloud_docker_path/scripts/nextcloud_scripts/maintenance_disable.sh 
            echo "exit..."
			exit 1
            ;;
        *) echo "invalid option $REPLY";;
    esac
done



# Start nextcloud docker instance
docker compose up -d

echo "Waiting 20s to start"
sleep 20

echo "Starting upgrade now!"

if bash $nextcloud_docker_path/scripts/nextcloud_scripts/enter_occ_command.sh "upgrade" ; then
    echo "upgrade command succeeded"
else
    echo "Upgrade command failed. Do you want try again?"
    
    select opt in yes no
    do
        case $opt in
            "yes")
                echo "Starting upgrade now!"
                if bash $nextcloud_docker_path/scripts/nextcloud_scripts/enter_occ_command.sh "upgrade" ; then
                    echo "upgrade command succeeded"
                else
                    echo "The Upgrade command failed a secondtime, please try running 'occ upgrade' manually again."
                    exit 1
    			break
                ;;
            "no")
                echo "Please try running 'occ upgrade' manually again."
                exit 1
            *) echo "invalid option $REPLY";;
        esac
    done

fi


bash $nextcloud_docker_path/scripts/nextcloud_scripts/maintenance_disable.sh 

bash $nextcloud_docker_path/scripts/nextcloud_scripts/add_indicies_and_colums.sh 


echo
echo "Do you want to procced with a normal start of nextcloud?"

select opt in yes no
do
    case $opt in
        "yes")
            echo "start nextcloud..."
			break
            ;;
        "no")
            echo "exit without starting..."
			exit 1
            ;;
        *) echo "invalid option $REPLY";;
    esac
done



sudo systemctl start nextcloud.service 

sleep 5

bash $nextcloud_docker_path/scripts/nextcloud_scripts/maintenance_disable.sh 

sleep 240 && sudo monit monitor nextcloud & sudo monit monitor nextcloud-local &

