#!/bin/bash

# Simple connection test
VPS_IP="159.198.32.51"
VPS_USER="root"

echo "Testing SSH connection to $VPS_USER@$VPS_IP..."
ssh -o ConnectTimeout=10 $VPS_USER@$VPS_IP "echo 'Connection successful!' && ls -la"