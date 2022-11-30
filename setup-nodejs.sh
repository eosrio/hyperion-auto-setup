#!/bin/bash

NODE_VERSION=$(node -v);

NODE_MAJOR=$(echo "$NODE_VERSION" | cut -d. -f1);

if [ "v18" = "$NODE_MAJOR" ]; then
  echo "NodeJS detected!"
  echo "Version: $NODE_VERSION"
  echo "Skipping setup..."
else
  curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - && sudo apt-get install -y nodejs
fi
