#!/bin/bash
scripts_path=`realpath $(dirname $(readlink -f $0))/`

# KMC folder has ID 2
groupfolder_id=2

folders=$(docker exec -it -u 33 nc_web bash -c 'cd data/__groupfolders/2 && array=(*) && for dir in "${array[@]}"; do echo ",$dir"; done')

Field_Separator=$IFS
IFS=,

for folder in $folders 
do

if [[ -n $folder ]]
then

	# remove new lines tabs etc.
	folder=${folder//[$'\t\r\n']}
	$scripts_path/enter_occ_command.sh "occ groupfolders:permissions -n --group Ärzte -- 2 '$folder' -read"
	$scripts_path/enter_occ_command.sh "occ groupfolders:permissions -n --group Controller -- 2 '$folder' -read"
	$scripts_path/enter_occ_command.sh "occ groupfolders:permissions -n --group 'Ärztliche Direktoren' -- 2 '$folder' -read"
fi

done

IFS=$Field_Separator

