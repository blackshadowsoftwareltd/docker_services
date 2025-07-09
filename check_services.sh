#!/bin/bash

# Check VPS services status
VPS_IP="159.198.32.51"
VPS_USER="root"
PROJECT_DIR="/home/root/docker_services"

echo "🔍 Checking VPS services status..."

ssh $VPS_USER@$VPS_IP << 'EOF'
echo "📍 Current directory: $(pwd)"
cd /home/root/docker_services

echo "📋 Files in project directory:"
ls -la

echo "🐳 Docker status:"
systemctl status docker --no-pager

echo "📊 Docker Compose services:"
docker-compose ps

echo "📋 Docker containers:"
docker ps -a

echo "🌐 Network connections:"
netstat -tlnp | grep -E ':80|:443|:8080|:8081'

echo "🔥 Firewall status:"
ufw status

echo "📝 Nginx container logs:"
docker-compose logs nginx | tail -20

echo "🚀 Fuel cost server logs:"
docker-compose logs fuel_cost_server | tail -20

echo "🔧 System services listening:"
ss -tlnp | grep -E ':80|:443|:8080|:8081'
EOF