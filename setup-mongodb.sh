#!/bin/bash

if command -v mongod &> /dev/null
then
  MONGO_VERSION=$(mongod --version | grep "db version" | cut -d" " -f3 | cut -d"v" -f2);
  MONGO_MAJOR=$(echo "$MONGO_VERSION" | cut -d. -f1);

  if [ "$MONGO_MAJOR" -eq "8" ]; then
    echo "MongoDB detected!"
    echo "Version: $MONGO_VERSION"
    echo "Skipping setup..."
  else
    echo "MongoDB version mismatch, installing v8..."
    sudo apt-get install gnupg -y
    curl -fsSL https://pgp.mongodb.com/server-8.0.asc | sudo gpg --dearmor -o /usr/share/keyrings/mongodb-server-8.0.gpg
    echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/8.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list
    sudo apt-get update
    sudo apt-get install -y mongodb-org
    sudo systemctl enable mongod.service
    mongod --version | grep "db version" | cut -d" " -f3 | cut -d"v" -f2 > .mongodb.version
  fi
else
  echo "MongoDB not found, installing..."
  sudo apt-get install gnupg -y
  curl -fsSL https://pgp.mongodb.com/server-8.0.asc | sudo gpg --dearmor -o /usr/share/keyrings/mongodb-server-8.0.gpg
  echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/8.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list
  sudo apt-get update
  sudo apt-get install -y mongodb-org
  sudo systemctl enable mongod.service
  mongod --version | grep "db version" | cut -d" " -f3 | cut -d"v" -f2 > .mongodb.version
fi
