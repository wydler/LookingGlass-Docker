# LookingGlass
[![Docker Image Version (tag latest)](https://img.shields.io/docker/v/wydler/lookingglass-web/latest)](https://hub.docker.com/r/wydler/lookingglass-web) [![Docker Image Size (tag latest)](https://img.shields.io/docker/image-size/wydler/lookingglass-web/latest)](https://hub.docker.com/r/wydler/lookingglass-web) [![Docker Pulls](https://img.shields.io/docker/pulls/wydler/lookingglass-web)](https://hub.docker.com/r/wydler/lookingglass-web) [![Docker Stars](https://img.shields.io/docker/stars/wydler/lookingglass-web)](https://hub.docker.com/r/wydler/lookingglass-web)

## Overview
LookingGlass is a user-friendly PHP based looking glass that allows the public (via a web interface) to execute network commands on behalf of your server.

This is a port of the native [Looking Glass application](https://github.com/wydler/LookingGlass/tree/customize) into docker images.


## Demo
[Looking Glass](http://lg.n01.cl01.daniel.wydler.eu/)

Demo is running on a Cloud Server of Hetzner Online GmbH. 


## Features
You can find an overview [here](https://github.com/wydler/LookingGlass/tree/customize).


## Implemented commands
You can find an overview [here](https://github.com/wydler/LookingGlass/tree/customize).


## Requirements
* Docker & Docker Compose V2
* Git
* SSH/Terminal access (able to install commands/functions if non-existent)


## Install Docker and configure LookingGlass
1. Install Docker and containerd:
  ```
    curl https://raw.githubusercontent.com/wydler/LookingGlass-Docker/master/misc/docker-shared/01-docker-installation.sh | bash
  ```
2. For IPv6 support, edit the Docker daemon configuration file, located at /etc/docker/daemon.json. Configure the following parameters and run `systemctl restart docker.service` to restart docker:
  ```
  {
    "experimental": true,
    "ip6tables": true
  }
  ```
3. Clone the repository to the correct folder for docker container:
  ```
   git clone https://github.com/wydler/LookingGlass-Docker.git /opt/containers/lookingglass
   git -C /opt/containers/lookingglass checkout $(git -C /opt/containers/lookingglass tag | tail -1)
  ```
4. Copy `.env.example` to `.env`:
  ```
  cp /opt/containers/lookingglass/.env.example /opt/containers/lookingglass/.env
  ```
5. Copy `docker-compose.yml.example` to `docker-compose.yml`:
  ```
  cp /opt/containers/lookingglass/docker-compose.yml.example /opt/containers/lookingglass/docker-compose.yml
  ```  
6. Edit `.env` and set your LookingGlass settings.
7. Edit `docker-compose.yml` if needed.
8. Start the application with `docker compose -f /opt/containers/lookingglass/docker-compose.yml up -d`.
9. Verify that the application works (for example, by opening its IP address or FQDN in a browser).


## Update Looking Glass
LookingGlass is pinned in `docker/lookingglass.version` and included in the web and PHP images during the Docker build. After images containing the desired version have been published, update the container images.

Set `DOCKER_HUB_CONTAINER_TAG` in `.env` to the published image tag you want to use, then pull and restart the containers:

  ```
  cd /opt/containers/lookingglass
  docker compose -f docker-compose.yml pull
  docker compose -f docker-compose.yml up -d
  ```

Persistent data and logs are stored under `./data`: LookingGlass state in `data/lookingglass`, Nginx logs in `data/nginx/logs`, and PHP-FPM logs in `data/php-fpm/logs`. To move the installation, copy `docker-compose.yml`, `.env`, and the `data` directory to the new server.

For existing installations using the named volume `www-data`, migrate its rate-limit database before switching to the bind mount:
1. Stop the containers without deleting volumes:
   ```
   docker compose -f docker-compose.yml down
   ```
2. Find the existing volume name:
   ```
   docker volume ls --filter label=com.docker.compose.volume=www-data
   ```
3. Copy the database into `data/lookingglass` (replace `<old-volume-name>` with the listed name):
   ```
   mkdir -p data/lookingglass
   docker run --rm -v <old-volume-name>:/source:ro -v "$PWD/data/lookingglass:/target" alpine:3.24.4 sh -c 'if [ -f /source/LookingGlass/ratelimit.db ]; then cp -a /source/LookingGlass/ratelimit.db /target/; fi'
   ```

If the database is already in `data/lookingglass/LookingGlass`, the first startup moves it to `data/lookingglass/`; `Config.php` is regenerated from `.env`. Keep the old Docker volume until the new setup is verified; do not use `docker compose down -v` during migration.


## License
Code is licensed under the MIT License.
If you wish to support my efforts, keep the "Powered by LookingGlass" link intact.
