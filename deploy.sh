#!/bin/bash

# VPS Deployment Script for Docker Services
set -e  # Exit on any error

VPS_IP="159.198.32.51"
VPS_USER="root"
PROJECT_NAME=$(basename "$(pwd)")
PROJECT_DIR="/home/$VPS_USER/$PROJECT_NAME"

echo "🚀 Starting VPS deployment..."
echo "📁 Target directory: $PROJECT_DIR"

# Test SSH connection first
echo "🔐 Testing SSH connection..."
echo "You will be prompted for your VPS password multiple times..."
if ! ssh -o ConnectTimeout=10 $VPS_USER@$VPS_IP exit; then
    echo "❌ SSH connection failed. Please ensure:"
    echo "   1. VPS is running and accessible"
    echo "   2. You have the correct password"
    echo "   3. Try: ssh $VPS_USER@$VPS_IP"
    exit 1
fi

# 1. Upload project to VPS
echo "📦 Uploading project to VPS..."
if ! ssh $VPS_USER@$VPS_IP "mkdir -p $PROJECT_DIR"; then
    echo "❌ Failed to create directory on VPS"
    exit 1
fi

if ! rsync -av --exclude='deploy.sh' ./ $VPS_USER@$VPS_IP:$PROJECT_DIR/; then
    echo "❌ Failed to upload files to VPS"
    exit 1
fi

# 2. SSH into VPS and run deployment commands
echo "🔐 Connecting to VPS and setting up services..."
if ! ssh $VPS_USER@$VPS_IP "
cd $PROJECT_DIR || exit 1

# 3. Create certbot directories
echo '📁 Creating certbot directories...'
mkdir -p certbot/conf certbot/www

# 4. Start services without SSL first
echo '🐳 Starting Docker services (without SSL)...'
docker-compose up -d fuel_cost_server personal_service nginx

# Wait for services to be ready
echo '⏳ Waiting for services to start...'
sleep 30

# 5. Get SSL certificates
echo '🔒 Obtaining SSL certificates...'
docker-compose run --rm certbot certonly --webroot -w /var/www/certbot --force-renewal --email blackshadowsoftwareltd@gmail.com -d fuelcost.blackshadow.software -d personal_service.blackshadow.software --agree-tos

# 6. Restart nginx with SSL
echo '🔄 Restarting nginx with SSL...'
docker-compose restart nginx

echo '✅ Deployment completed successfully!'
echo '🌐 Your services should be available at:'
echo '   - https://fuelcost.blackshadow.software'
echo '   - https://personal_service.blackshadow.software'
"; then
    echo "❌ Deployment failed on VPS"
    exit 1
fi

echo "🎉 Deployment script completed!"