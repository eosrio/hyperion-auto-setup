#!/bin/bash

sudo systemctl stop rabbitmq-server
sudo systemctl disable rabbitmq-server
sudo apt-get remove --purge -y rabbitmq-server erlang*
sudo rm -rf /var/lib/rabbitmq
sudo rm -rf /etc/rabbitmq
sudo rm -f /usr/share/keyrings/com.rabbitmq.team.gpg
sudo rm -f /usr/share/keyrings/rabbitmq.E495BB49CC4BBE5B.gpg
sudo rm -f /usr/share/keyrings/rabbitmq.9F4587F2262083FC.gpg
sudo rm -f /etc/apt/sources.list.d/rabbitmq-erlang.list
sudo rm -f /etc/apt/sources.list.d/rabbitmq-server.list
sudo rm -f /etc/apt/preferences.d/99rabbitmq.pref
sudo apt-get autoremove -y