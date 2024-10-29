#!/bin/bash


# Reset the local branch to match the remote main branch
git reset --hard origin/main

# Pull the latest changes from the remote main branch
git pull origin main


# Move all files to the parent directory
mv -f * ../

# Change directory to the parent directory
cd ../

# Make the specified scripts executable
chmod +x setup_ssl.sh
chmod +x create_domain.sh
chmod +x remove_domain.sh

echo "Setup completed successfully."