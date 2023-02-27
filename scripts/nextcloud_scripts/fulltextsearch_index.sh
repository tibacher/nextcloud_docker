#!/bin/bash
docker exec -it -u www-data nc_cron php /var/www/html/occ fulltextsearch:index