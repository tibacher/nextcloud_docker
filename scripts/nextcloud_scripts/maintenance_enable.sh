#!/bin/bash
sudo monit unmonitor nextcloud
sudo monit unmonitor nextcloud-local

docker exec --user www-data nc_web  php occ maintenance:mode --on
