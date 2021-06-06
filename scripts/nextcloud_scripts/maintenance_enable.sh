#!/bin/bash
docker exec --user www-data nc_web  php occ maintenance:mode --on
