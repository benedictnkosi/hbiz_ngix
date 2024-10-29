
#!/bin/bash

# Usage: ./setup_domain.sh example.com

# Check if domain name is provided as an argument
if [ -z "$1" ]; then
  echo "Please provide the domain name (e.g., example.com)"
  exit 1
fi

DOMAIN=$1
EMAIL="nkosi.benedict@gmail.com"  # Set the email for Certbot
WEB_ROOT="/var/www/$DOMAIN"
NGINX_SITES_AVAILABLE="/etc/nginx/sites-available/$DOMAIN"
NGINX_SITES_ENABLED="/etc/nginx/sites-enabled/$DOMAIN"

# Step 1: Update packages and install Certbot and NGINX plugin
sudo apt update
sudo apt install -y certbot python3-certbot-nginx

# Step 2: Set up NGINX server block for the domain
sudo mkdir -p "$WEB_ROOT"
sudo chown -R $USER:$USER "$WEB_ROOT"

# Create an NGINX server block configuration
sudo bash -c "cat > $NGINX_SITES_AVAILABLE" <<EOL
server {
    listen 80;
    server_name $DOMAIN www.$DOMAIN;

    root $WEB_ROOT;
    index index.html index.htm;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOL

# Enable the server block by creating a symbolic link
sudo ln -s "$NGINX_SITES_AVAILABLE" "$NGINX_SITES_ENABLED"

# Step 3: Reload NGINX to apply changes
sudo systemctl reload nginx

# Step 4: Obtain an SSL certificate and configure HTTPS with Certbot
sudo certbot --nginx --non-interactive --agree-tos --email $EMAIL -d $DOMAIN -d www.$DOMAIN

# Step 5: Reload NGINX to apply HTTPS configuration
sudo systemctl reload nginx

echo "HTTPS has been enabled for $DOMAIN with automatic redirection from HTTP."
