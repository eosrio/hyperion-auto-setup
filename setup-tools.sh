#!/bin/bash

if [ -x "$(command -v jq)" ] && [ -x "$(command -v curl)" ] && [ -x "$(command -v git)" ]; then
  echo "Skipping tooling setup..."
  exit
else
  sudo apt-get update
  sudo apt-get install jq net-tools curl git -y
fi
