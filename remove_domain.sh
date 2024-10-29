#!/bin/bash

# Usage: ./remove_domain.sh example.com

# Check if domain name is passed as an argument
if [ -z "$1" ]; then
  echo "Please provide the domain name to remove (e.g., example.com)"
  exit 1
fi

DOMAIN=$1
NGINX_SITES_AVAILABLE="/etc/nginx/sites-available/$DOMAIN"
NGINX_SITES_ENABLED="/etc/nginx/sites-enabled/$DOMAIN"
WEB_ROOT="/var/www/$DOMAIN"

# Step 1: Remove the NGINX config file for the domain
if [ -f "$NGINX_SITES_AVAILABLE" ]; then
  sudo rm "$NGINX_SITES_AVAILABLE"
  echo "Removed $NGINX_SITES_AVAILABLE"
else
  echo "No config found in sites-available for $DOMAIN"
fi

# Step 2: Remove the symbolic link from sites-enabled
if [ -f "$NGINX_SITES_ENABLED" ]; then
  sudo rm "$NGINX_SITES_ENABLED"
  echo "Removed $NGINX_SITES_ENABLED"
else
  echo "No config found in sites-enabled for $DOMAIN"
fi

# Step 3: Remove the web root directory
if [ -d "$WEB_ROOT" ]; then
  sudo rm -rf "$WEB_ROOT"
  echo "Removed web root directory $WEB_ROOT"
else
  echo "No web root directory found for $DOMAIN"
fi

# Step 4: Reload NGINX
sudo systemctl reload nginx
echo "NGINX reloaded"

echo "Domain $DOMAIN and associated files have been removed."
