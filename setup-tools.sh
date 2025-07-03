#!/bin/bash

if [ -x "$(command -v jq)" ] && [ -x "$(command -v curl)" ] && [ -x "$(command -v git)" ]; then
  echo "Skipping tooling setup..."
  exit
else
  sudo apt-get update
  sudo apt-get install gnupg jq net-tools curl git unzip apt-transport-https -y
fi
