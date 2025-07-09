#!/bin/bash

# VPS Deployment Script with Expect for Password Automation
VPS_IP="159.198.32.51"
VPS_USER="root"
PROJECT_NAME=$(basename "$(pwd)")
PROJECT_DIR="/home/$VPS_USER/$PROJECT_NAME"

echo "🚀 Starting VPS deployment..."
echo "📁 Target directory: $PROJECT_DIR"

# Function to run commands with password
run_with_password() {
    local password="$1"
    local command="$2"
    
    expect -c "
    spawn $command
    expect {
        \"*password:*\" { send \"$password\r\"; exp_continue }
        \"*Password:*\" { send \"$password\r\"; exp_continue }
        \"*(yes/no)?*\" { send \"yes\r\"; exp_continue }
        \"*Are you sure*\" { send \"yes\r\"; exp_continue }
        eof
    }
    "
}

# Get password from user
echo "Please enter your VPS password:"
read -s VPS_PASSWORD

# Test SSH connection
echo "🔐 Testing SSH connection..."
if ! run_with_password "$VPS_PASSWORD" "ssh -o ConnectTimeout=10 $VPS_USER@$VPS_IP exit"; then
    echo "❌ SSH connection failed"
    exit 1
fi

# Create directory on VPS
echo "📦 Creating directory on VPS..."
run_with_password "$VPS_PASSWORD" "ssh $VPS_USER@$VPS_IP 'mkdir -p $PROJECT_DIR'"

# Upload files
echo "📤 Uploading files..."
run_with_password "$VPS_PASSWORD" "rsync -av --exclude='deploy*.sh' --exclude='test_connection.sh' ./ $VPS_USER@$VPS_IP:$PROJECT_DIR/"

# Run deployment commands
echo "🚀 Running deployment commands..."
run_with_password "$VPS_PASSWORD" "ssh $VPS_USER@$VPS_IP '
cd $PROJECT_DIR || exit 1

# Install Docker if not present
echo \"🐳 Checking Docker installation...\"
if ! command -v docker &> /dev/null; then
    echo \"📦 Installing Docker...\"
    apt-get update
    apt-get install -y docker.io docker-compose
    systemctl start docker
    systemctl enable docker
fi

# Create certbot directories
echo \"📁 Creating certbot directories...\"
mkdir -p certbot/conf certbot/www

# Start services
echo \"🐳 Starting Docker services...\"
docker-compose up -d fuel_cost_server personal_service nginx

# Wait and check status
echo \"⏳ Waiting for services to start...\"
sleep 30
docker-compose ps

# Get SSL certificates
echo \"🔒 Getting SSL certificates...\"
docker-compose run --rm certbot certonly --webroot -w /var/www/certbot --force-renewal --email blackshadowsoftwareltd@gmail.com -d fuelcost.blackshadow.software -d personal_service.blackshadow.software --agree-tos

# Restart nginx with SSL
echo \"🔄 Restarting nginx with SSL...\"
docker-compose restart nginx

# Final status
echo \"📊 Final status:\"
docker-compose ps

echo \"✅ Deployment completed!\"
'"

echo "🎉 Deployment script completed!"