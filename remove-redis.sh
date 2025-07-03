#!/bin/bash

sudo systemctl stop redis-server
sudo systemctl disable redis-server
sudo apt-get remove --purge -y redis-server redis-tools redis
sudo rm -rf /var/lib/redis
sudo rm -rf /etc/redis
sudo rm -rf /usr/share/keyrings/redis-archive-keyring.gpg
sudo rm -rf /etc/apt/sources.list.d/redis.list
sudo apt-get autoremove -y
