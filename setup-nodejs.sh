#!/bin/bash

# Function to check if Node.js version meets requirements
check_node_version() {
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node -v | sed 's/v//')
        NODE_MAJOR=$(echo "$NODE_VERSION" | cut -d. -f1)
        NODE_MINOR=$(echo "$NODE_VERSION" | cut -d. -f2)
        
        # Check if version is 24.0+ or 22.16+
        if [ "$NODE_MAJOR" -gt 24 ] || \
           [ "$NODE_MAJOR" -eq 24 ] || \
           { [ "$NODE_MAJOR" -eq 22 ] && [ "$NODE_MINOR" -ge 16 ]; }; then
            echo "NodeJS detected!"
            echo "Version: v$NODE_VERSION"
            echo "Skipping setup..."
            return 0
        else
            echo "NodeJS version v$NODE_VERSION does not meet requirements (24.0+ or 22.16+)"
            return 1
        fi
    else
        echo "NodeJS not found"
        return 1
    fi
}

# Function to install FNM and Node.js
install_node_with_fnm() {
    echo "Installing FNM (Fast Node Manager)..."
    
    # Download and install FNM
    curl -o- https://fnm.vercel.app/install | bash
    
    # Source the shell configuration to make fnm available
    export PATH="$HOME/.fnm:$PATH"
    eval "$(fnm env --use-on-cd)"
    
    # Try to source common shell configs
    if [ -f "$HOME/.bashrc" ]; then
        source "$HOME/.bashrc"
    fi
    
    # Install Node.js 24 (latest LTS)
    echo "Installing Node.js 24..."
    fnm install 24
    fnm use 24
    fnm default 24
    
    # Verify installation
    echo "Verifying Node.js installation..."
    node -v
    npm -v
    
    echo "Node.js installation completed!"
}

# Check current Node.js version
if check_node_version; then
    exit 0
else
    echo "Installing Node.js using FNM..."
    install_node_with_fnm
fi
