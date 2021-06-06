#!/bin/bash

docker exec -t -u www-data nc_web php /var/www/html/occ app:update --all

