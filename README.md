# nextcloud-docker
nextcloud docker-compose files...

To start do:
```bash
docker-compose pull
docker-compose up -d
```

# Setup

Adjust your setup according to the ```*.sample``` files.


# Start/Stop/Update

Simply use the according scripts in ```scripts/```.


## Use systemd Service
Change path in ```scripts/nextcloud.service``` and link to systemd.

