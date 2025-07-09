#!/bin/bash

# Quick diagnostic and fix script
VPS_IP="159.198.32.51"
VPS_USER="root"

echo "🔍 Quick VPS diagnostic and fix..."
echo "You'll need to enter your password for each command."

echo "1. Testing basic connectivity..."
ssh $VPS_USER@$VPS_IP "echo 'Connected successfully'"

echo "2. Checking if Docker is running..."
ssh $VPS_USER@$VPS_IP "systemctl status docker --no-pager"

echo "3. Starting Docker if not running..."
ssh $VPS_USER@$VPS_IP "systemctl start docker"

echo "4. Going to project directory and checking services..."
ssh $VPS_USER@$VPS_IP "cd /home/root/docker_services && ls -la"

echo "5. Checking Docker Compose status..."
ssh $VPS_USER@$VPS_IP "cd /home/root/docker_services && docker-compose ps"

echo "6. Restarting services..."
ssh $VPS_USER@$VPS_IP "cd /home/root/docker_services && docker-compose down && docker-compose up -d"

echo "7. Checking ports..."
ssh $VPS_USER@$VPS_IP "netstat -tlnp | grep -E ':80|:443'"

echo "8. Testing local connection..."
ssh $VPS_USER@$VPS_IP "curl -I localhost:80"

echo "9. Checking firewall..."
ssh $VPS_USER@$VPS_IP "ufw status"

echo "10. Opening firewall if needed..."
ssh $VPS_USER@$VPS_IP "ufw allow 80/tcp && ufw allow 443/tcp"

echo "✅ Diagnostic complete!"