#!/bin/bash

# HTTP-only VPS Deployment Script (No SSL)
VPS_IP="159.198.32.51"
VPS_USER="root"
PROJECT_NAME=$(basename "$(pwd)")
PROJECT_DIR="/home/$VPS_USER/$PROJECT_NAME"

echo "🚀 Starting HTTP-only VPS deployment..."
echo "📁 Target directory: $PROJECT_DIR"
echo "⚠️  You will be prompted for your VPS password multiple times"

# Test connection first
echo "🔐 Testing SSH connection..."
if ! ssh -o ConnectTimeout=10 $VPS_USER@$VPS_IP "echo 'Connection successful'"; then
    echo "❌ SSH connection failed"
    exit 1
fi

# Create directory
echo "📁 Creating directory on VPS..."
ssh $VPS_USER@$VPS_IP "mkdir -p $PROJECT_DIR"

# Upload files
echo "📤 Uploading files..."
rsync -av --exclude='deploy*.sh' --exclude='test_connection.sh' --exclude='check_services.sh' --exclude='quick_fix.sh' ./ $VPS_USER@$VPS_IP:$PROJECT_DIR/

# Run deployment
echo "🚀 Running HTTP-only deployment on VPS..."
ssh $VPS_USER@$VPS_IP << 'EOF'
cd /home/root/docker_services

echo "📍 Current directory: $(pwd)"

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

# Stop any existing services
echo "🛑 Stopping existing services..."
docker-compose down

# Start services (HTTP only)
echo "🐳 Starting Docker services (HTTP only)..."
docker-compose up -d fuel_cost_server personal_service nginx

# Wait for services
echo "⏳ Waiting 30 seconds for services to start..."
sleep 30

# Check status
echo "📊 Service status:"
docker-compose ps

# Check if services are responding
echo "🔍 Testing internal connectivity..."
curl -I http://localhost:80 || echo "❌ Nginx not responding"

# Check ports
echo "🌐 Checking open ports:"
netstat -tlnp | grep -E ':80|:8080|:8081'

# Open firewall for HTTP
echo "🔥 Opening firewall for HTTP..."
ufw allow 80/tcp
ufw --force enable

# Final status
echo "📊 Final service status:"
docker-compose ps

echo "✅ HTTP-only deployment completed!"
echo "🌐 Your API should be available at:"
echo "   - http://fuelcost.blackshadow.software"
echo "   - http://personal_service.blackshadow.software"
EOF

echo "🎉 Deployment script finished!"
echo "🌐 Test your API at: http://fuelcost.blackshadow.software"