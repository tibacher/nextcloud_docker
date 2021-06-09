#!/bin/bash
scripts_path=`realpath $(dirname $(readlink -f $0))/`

groupfolder_id=2

folders=$(docker exec -it -u 33 nc_web ls data/__groupfolders/2)
for folder in $folders 
do
# remove new lines tabs etc.
folder=${folder//[$'\t\r\n']}
$scripts_path/enter_occ_command.sh "occ groupfolders:permissions 2 --group Ärzte $folder -- -read"

done

Ärzte
