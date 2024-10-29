# Usage: sudo ./create_domain.sh yourdomain.com

# Check if domain name is provided
if [ -z "$1" ]; then
    echo "Please provide a domain name. Usage: sudo ./create_domain.sh yourdomain.com"
    exit 1
fi

DOMAIN=$1
WEB_ROOT="/var/www/$DOMAIN"
NGINX_CONF="/etc/nginx/sites-available/$DOMAIN"
NGINX_LINK="/etc/nginx/sites-enabled/$DOMAIN"

# Step 1: Create web root directory
echo "Creating web root directory at $WEB_ROOT..."
mkdir -p "$WEB_ROOT"
chmod -R 755 "$WEB_ROOT"
chown -R www-data:www-data "$WEB_ROOT"

# Step 2: Create an NGINX server block
echo "Creating NGINX configuration for $DOMAIN..."
cat > "$NGINX_CONF" <<EOL
server {
    listen 80;
    listen [::]:80;

    server_name $DOMAIN www.$DOMAIN;

    root $WEB_ROOT;
    index index.html index.htm;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOL

# Step 3: Enable the new site by creating a symbolic link
echo "Enabling the site by creating a symbolic link..."
ln -s "$NGINX_CONF" "$NGINX_LINK"

# Step 4: Test NGINX configuration for syntax errors
echo "Testing NGINX configuration..."
nginx -t
if [ $? -ne 0 ]; then
    echo "NGINX configuration test failed. Please check the configuration."
    exit 1
fi

# Step 5: Reload NGINX to apply changes
echo "Reloading NGINX to apply changes..."
systemctl reload nginx

# Step 6: Create a sample index.html page
echo "Creating a sample index.html page at $WEB_ROOT..."
cp /index.html "$WEB_ROOT/index.html"
sed -i "s/\$DOMAIN/$DOMAIN/g" "$WEB_ROOT/index.html"