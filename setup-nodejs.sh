#!/bin/bash

NODE_VERSION=$(node -v);

NODE_MAJOR=$(echo "$NODE_VERSION" | cut -d. -f1);

if [ "v20" = "$NODE_MAJOR" ]; then
  echo "NodeJS detected!"
  echo "Version: $NODE_VERSION"
  echo "Skipping setup..."
else
  sudo apt-get update
  sudo apt-get install -y ca-certificates curl gnupg
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
  NODE_MAJOR=20
  echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
  sudo apt-get update
  sudo apt-get install nodejs -y
fi
