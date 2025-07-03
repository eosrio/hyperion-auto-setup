#!/bin/bash

HYP_INSTALL_DIR="$HOME/hyperion"

if [ -d "$HYP_INSTALL_DIR" ]; then
  cd "$HYP_INSTALL_DIR" || exit
  pm2 stop all
  pm2 delete all
  pm2 save --force
  cd ~ || exit
  rm -rf "$HYP_INSTALL_DIR"
  echo "Hyperion removed!"
else
  echo "Hyperion not found, skipping removal..."
fi
