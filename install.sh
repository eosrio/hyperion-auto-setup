#!/bin/bash

DISTRO_CODENAME=$(lsb_release -cs)

if [ "$DISTRO_CODENAME" == "noble" ] || [ "$DISTRO_CODENAME" == "jammy" ]; then
  bash ./setup-tools.sh
  bash ./setup-nodejs.sh
  source ~/.bashrc
  bash ./setup-pm2.sh
  bash ./setup-elasticsearch.sh
  bash ./setup-rabbitmq.sh
  bash ./setup-redis.sh
  bash ./setup-mongodb.sh
  bash ./setup-hyperion.sh
  cd ~/hyperion || exit
else
  echo "Ubuntu 24.04 or 22.04 is required for auto install, for other distributions please install dependencies manually."
fi
