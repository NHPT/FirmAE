#!/bin/bash
set -e

# Check if the script is run by root
if [ "$(id -u)" -eq 0 ]; then
    # The script is run by root, no need for sudo
    service postgresql restart
else
    # The script is run by a non-root user, use sudo
    sudo service postgresql restart
fi

echo "Waiting for DB to start..."
sleep 5
