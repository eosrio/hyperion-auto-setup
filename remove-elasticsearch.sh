#!/bin/bash

sudo systemctl stop elasticsearch.service
sudo systemctl disable elasticsearch.service
sudo apt-get remove --purge -y elasticsearch
sudo rm -rf /etc/elasticsearch
sudo rm -rf /var/lib/elasticsearch
sudo rm -rf /var/log/elasticsearch
sudo rm -rf /usr/share/keyrings/elasticsearch-keyring.gpg
sudo rm -rf /etc/apt/sources.list.d/elastic-9.x.list
sudo apt-get autoremove -y
