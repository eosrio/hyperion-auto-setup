#!/bin/bash

sudo apt-get remove --purge -y curl git jq net-tools
sudo apt-get autoremove -y
