#!/bin/bash

sudo pm2 kill
sudo pm2 unstartup systemd
sudo npm uninstall pm2 -g
