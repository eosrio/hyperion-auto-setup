#!/bin/bash

if command -v redis-server &> /dev/null
then
  REDIS_VERSION=$(redis-server -v | cut -d" " -f3 | cut -d"=" -f2);
  REDIS_MAJOR=$(echo "$REDIS_VERSION" | cut -d. -f1);

  if [ "$REDIS_MAJOR" -eq "7" ]; then
    echo "Redis detected!"
    echo "Version: $REDIS_VERSION"
    echo "Skipping setup..."
  else
    echo "Redis version mismatch, installing..."
    curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list
    sudo apt-get update
    sudo apt-get install redis -y
    sudo systemctl enable redis-server.service
    redis-cli INFO SERVER | grep redis_version | cut -f2 -d: > .redis.version
  fi
else
  echo "Redis not found, installing..."
  curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list
  sudo apt-get update
  sudo apt-get install redis -y
  sudo systemctl enable redis-server.service
  redis-cli INFO SERVER | grep redis_version | cut -f2 -d: > .redis.version
fi
