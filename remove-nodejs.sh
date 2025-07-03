#!/bin/bash

# Function to remove FNM and Node.js
remove_fnm() {
    echo "Removing FNM (Fast Node Manager) and Node.js..."
    
    # Remove FNM directory
    FNM_DIR="$HOME/.local/share/fnm"
    if [ -d "$FNM_DIR" ]; then
        echo "Removing FNM directory: $FNM_DIR"
        rm -rf "$FNM_DIR"
    fi
    
    # Remove FNM from shell configuration
    SHELL_CONFIG="$HOME/.bashrc"
    if [ -f "$SHELL_CONFIG" ]; then
        echo "Removing FNM configuration from $SHELL_CONFIG..."
        # Remove the FNM setup line and the comment
        sed -i '/# FNM (Fast Node Manager)/d' "$SHELL_CONFIG"
        sed -i '/fnm env/d' "$SHELL_CONFIG"
    fi
    
    echo "FNM and Node.js have been removed."
    echo "Note: You may need to restart your terminal for changes to take effect."
}

# Function to remove apt-installed Node.js
remove_apt_nodejs() {
    echo "Removing apt-installed Node.js..."
    sudo apt-get remove --purge -y nodejs npm
    sudo rm -rf /etc/apt/keyrings/nodesource.gpg
    sudo rm -rf /etc/apt/sources.list.d/nodesource.list
    sudo apt-get autoremove -y
    echo "Apt-installed Node.js removed."
}

# Check if FNM is installed
if [ -d "$HOME/.local/share/fnm" ] || command -v fnm &> /dev/null; then
    remove_fnm
else
    echo "FNM not found, checking for apt-installed Node.js..."
    if command -v node &> /dev/null; then
        remove_apt_nodejs
    else
        echo "No Node.js installation found."
    fi
fi
