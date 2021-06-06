#!/bin/bash
docker exec -it -u www-data nc_web php /var/www/html/occ maintenance:mimetype:update-js
 

