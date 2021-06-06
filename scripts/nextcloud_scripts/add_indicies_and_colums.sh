#!/bin/bash

docker exec --user www-data -it nc_web php occ db:add-missing-indices
docker exec --user www-data -it nc_web php occ db:add-missing-columns

