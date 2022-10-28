#!/bin/bash

if [ "$(lsb_release -cs)" == "jammy" ]; then
  bash ./setup-tools.sh
  bash ./setup-nodejs.sh
  bash ./setup-pm2.sh
  bash ./setup-elasticsearch.sh
  bash ./setup-rabbitmq-jammy.sh
  bash ./setup-redis.sh
  bash ./setup-hyperion.sh
  cd ~/hyperion
else
  echo "Ubuntu 22.04 is required for auto install, for other distributions please install dependencies manually."
fi
