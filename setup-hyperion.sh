#!/bin/bash

HYP_INSTALL_DIR="$HOME/hyperion"
if [ -d "$HYP_INSTALL_DIR" ]; then
  echo "Hyperion already installed!"
  echo "Skipping setup..."
else
  git clone https://github.com/eosrio/hyperion-history-api "$HYP_INSTALL_DIR" || exit
  cd ~/hyperion || exit
  npm install
fi
