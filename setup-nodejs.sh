#!/bin/bash

# Check current NodeJS Installation
NODE_VERSION=$(node -v | cut -d. -f1)

if [ "$NODE_VERSION" == "v18" ]; then
  echo "NodeJS 18 Detected. Skipping setup...";
else
  curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - && sudo apt-get install -y nodejs
fi
