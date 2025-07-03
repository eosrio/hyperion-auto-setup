#!/bin/bash

# Array of required tools
REQUIRED_TOOLS=("jq" "curl" "git" "unzip" "gpg" "lsb_release")

# Array of packages to install (some tools have different package names)
INSTALL_PACKAGES=("jq" "curl" "git" "unzip" "gnupg" "lsb-release" "net-tools" "apt-transport-https")

function check_tools() {
    local missing_tools=()
    
    echo "Checking required tools..."
    
    for tool in "${REQUIRED_TOOLS[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            echo "  ❌ $tool - not found"
            missing_tools+=("$tool")
        else
            echo "  ✅ $tool - found"
        fi
    done
    
    if [ ${#missing_tools[@]} -eq 0 ]; then
        echo "All required tools are installed!"
        return 0
    else
        echo "Missing tools: ${missing_tools[*]}"
        return 1
    fi
}

function install_tools() {
    echo "Installing required tools and dependencies..."
    sudo apt-get update
    sudo apt-get install -y "${INSTALL_PACKAGES[@]}"
    
    echo "Installation completed. Verifying tools..."
    check_tools
}

# Main logic
if check_tools; then
    echo "Skipping tooling setup..."
else
    install_tools
fi
