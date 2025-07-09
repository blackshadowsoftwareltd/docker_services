#!/bin/bash

# VPS Deployment Script for Docker Services
# Replace VPS_IP and VPS_USER with your actual values

VPS_IP="159.198.32.51"
VPS_USER="user"
PROJECT_DIR="/home/user/docker_services"

echo "🚀 Starting VPS deployment..."

# 1. Upload project to VPS
echo "📦 Uploading project to VPS..."
scp -r ./ $VPS_USER@$VPS_IP:$PROJECT_DIR

# 2. SSH into VPS and run deployment commands
echo "🔐 Connecting to VPS and setting up services..."
ssh $VPS_USER@$VPS_IP << 'EOF'
cd /home/user/docker_services

# 3. Create certbot directories
echo "📁 Creating certbot directories..."
mkdir -p certbot/conf certbot/www

# 4. Start services without SSL first
echo "🐳 Starting Docker services (without SSL)..."
docker-compose up -d fuel_cost_server personal_service nginx

# Wait for services to be ready
echo "⏳ Waiting for services to start..."
sleep 30

# 5. Get SSL certificates
echo "🔒 Obtaining SSL certificates..."
docker-compose run --rm certbot certonly --webroot -w /var/www/certbot --force-renewal --email blackshadowsoftwareltd@gmail.com -d fuelcost.blackshadow.software -d personal_service.blackshadow.software --agree-tos

# 6. Restart nginx with SSL
echo "🔄 Restarting nginx with SSL..."
docker-compose restart nginx

echo "✅ Deployment completed successfully!"
echo "🌐 Your services should be available at:"
echo "   - https://fuelcost.blackshadow.software"
echo "   - https://personal_service.blackshadow.software"

EOF

echo "🎉 Deployment script completed!"