#!/bin/bash

sudo systemctl stop mongod
sudo systemctl disable mongod
sudo apt-get remove --purge -y mongodb-org*
sudo rm -rf /var/lib/mongodb
sudo rm -rf /var/log/mongodb
sudo rm -rf /usr/share/keyrings/mongodb-server-8.0.gpg
sudo rm -rf /etc/apt/sources.list.d/mongodb-org-8.0.list
sudo apt-get autoremove -y
