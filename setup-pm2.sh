#!/bin/bash

if command -v pm2 &> /dev/null
then
  PM2_VERSION=$(pm2 -v)
  if [[ $PM2_VERSION ]]; then
    echo "PM2 already installed!"
    echo "Version: $PM2_VERSION"
    echo "Skipping setup..."
  else
    echo "PM2 not found, installing..."
    sudo npm install pm2 -g || exit
    sudo pm2 startup
  fi
else
  echo "PM2 not found, installing..."
  sudo npm install pm2 -g || exit
  sudo pm2 startup
fi
