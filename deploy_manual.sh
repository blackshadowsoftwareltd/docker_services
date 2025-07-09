#!/bin/bash

# Manual VPS Deployment Script
VPS_IP="159.198.32.51"
VPS_USER="root"
PROJECT_NAME=$(basename "$(pwd)")
PROJECT_DIR="/home/$VPS_USER/$PROJECT_NAME"

echo "🚀 Starting VPS deployment..."
echo "📁 Target directory: $PROJECT_DIR"
echo "⚠️  You will be prompted for your VPS password multiple times"

# Test connection first
echo "🔐 Testing SSH connection..."
if ! ssh -o ConnectTimeout=10 $VPS_USER@$VPS_IP "echo 'Connection successful'"; then
    echo "❌ SSH connection failed"
    echo "Please check:"
    echo "1. VPS is running"
    echo "2. IP address is correct: $VPS_IP"
    echo "3. User is correct: $VPS_USER"
    echo "4. Password is correct"
    exit 1
fi

# Create directory
echo "📁 Creating directory on VPS..."
ssh $VPS_USER@$VPS_IP "mkdir -p $PROJECT_DIR"

# Upload files
echo "📤 Uploading files..."
rsync -av --exclude='deploy*.sh' --exclude='test_connection.sh' ./ $VPS_USER@$VPS_IP:$PROJECT_DIR/

# Run deployment
echo "🚀 Running deployment on VPS..."
ssh $VPS_USER@$VPS_IP << 'EOF'
cd /home/root/docker_services

echo "📍 Current directory: $(pwd)"
echo "📋 Files in directory:"
ls -la

# Install Docker if needed
echo "🐳 Checking Docker..."
if ! command -v docker &> /dev/null; then
    echo "📦 Installing Docker..."
    apt-get update
    apt-get install -y docker.io docker-compose
    systemctl start docker
    systemctl enable docker
    echo "✅ Docker installed"
else
    echo "✅ Docker already installed"
    systemctl start docker
fi

# Check docker-compose
if ! command -v docker-compose &> /dev/null; then
    echo "📦 Installing docker-compose..."
    apt-get install -y docker-compose
fi

# Create certbot directories
echo "📁 Creating certbot directories..."
mkdir -p certbot/conf certbot/www

# Start services
echo "🐳 Starting Docker services..."
docker-compose up -d fuel_cost_server personal_service nginx

# Wait for services
echo "⏳ Waiting 30 seconds for services to start..."
sleep 30

# Check status
echo "📊 Service status:"
docker-compose ps

# Get SSL certificates
echo "🔒 Getting SSL certificates..."
docker-compose run --rm certbot certonly --webroot -w /var/www/certbot --force-renewal --email blackshadowsoftwareltd@gmail.com -d fuelcost.blackshadow.software -d personal_service.blackshadow.software --agree-tos

# Restart nginx
echo "🔄 Restarting nginx with SSL..."
docker-compose restart nginx

# Final status
echo "📊 Final service status:"
docker-compose ps

echo "✅ Deployment completed!"
EOF

echo "🎉 Deployment script finished!"
echo "🌐 Your API should be available at: https://fuelcost.blackshadow.software"