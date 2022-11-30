#!/bin/bash

DISTRO_CODENAME=$(lsb_release -cs)

if [ "$DISTRO_CODENAME" == "jammy" ] || [ "$DISTRO_CODENAME" == "focal" ]; then
  bash ./setup-tools.sh
  bash ./setup-nodejs.sh
  bash ./setup-pm2.sh
  bash ./setup-elasticsearch.sh
  bash ./setup-rabbitmq.sh
  bash ./setup-redis.sh
  bash ./setup-hyperion.sh
  cd ~/hyperion || exit
else
  echo "Ubuntu 22.04 or 20.04 is required for auto install, for other distributions please install dependencies manually."
fi
