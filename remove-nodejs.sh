#!/bin/bash

sudo apt-get remove --purge -y nodejs
sudo rm -rf /etc/apt/keyrings/nodesource.gpg
sudo rm -rf /etc/apt/sources.list.d/nodesource.list
sudo apt-get autoremove -y
