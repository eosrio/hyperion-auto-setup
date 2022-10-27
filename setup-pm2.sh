#!/bin/bash

pm2 -v && echo "PM2 already installed!" && exit
sudo npm install pm2 -g || exit
sudo pm2 startup
