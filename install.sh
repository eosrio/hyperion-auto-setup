#!/bin/bash

DISTRO_CODENAME=$(lsb_release -cs)

if [ "$DISTRO_CODENAME" == "noble" ] || [ "$DISTRO_CODENAME" == "jammy" ]; then
  bash ./setup-tools.sh
  bash ./setup-nodejs.sh
  
  # Load FNM environment for current session if it exists
  if [ -d "$HOME/.local/share/fnm" ]; then
    export PATH="$HOME/.local/share/fnm:$PATH"
    eval "$($HOME/.local/share/fnm/fnm env --use-on-cd --shell bash)"
  fi
  
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
