#!/bin/bash

source ~/.bashrc

# Function to setup PM2 startup
setup_pm2_startup() {
    echo "Setting up PM2 startup..."
    
    # Run pm2 startup and capture the output
    STARTUP_OUTPUT=$(pm2 startup 2>&1)
    
    # Check if the output contains a sudo command to run
    if echo "$STARTUP_OUTPUT" | grep -q "sudo env PATH"; then
        # Extract the sudo command from the output
        SUDO_CMD=$(echo "$STARTUP_OUTPUT" | grep "sudo env PATH" | head -1)
        echo "Running startup command: $SUDO_CMD"
        eval "$SUDO_CMD"
        
        if [ $? -eq 0 ]; then
            echo "PM2 startup configured successfully!"
        else
            echo "Failed to configure PM2 startup. Please run the command manually:"
            echo "$SUDO_CMD"
        fi
    else
        echo "PM2 startup output:"
        echo "$STARTUP_OUTPUT"
    fi
}

# Check if PM2 is already installed
if command -v pm2 &> /dev/null; then
    PM2_VERSION=$(pm2 -v)
    echo "PM2 already installed!"
    echo "Version: $PM2_VERSION"
    echo "Skipping setup..."
else
    echo "PM2 not found, installing..."
    
    # Check if npm is available
    if ! command -v npm &> /dev/null; then
        echo "Error: npm is not installed. Please install Node.js first."
        exit 1
    fi
    
    # Install PM2 globally
    npm install pm2 -g
    
    if [ $? -eq 0 ]; then
        echo "PM2 installed successfully!"
        setup_pm2_startup
    else
        echo "Failed to install PM2"
        exit 1
    fi
fi
