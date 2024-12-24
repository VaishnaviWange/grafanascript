#!/bin/bash

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root (use sudo)"
    exit 1
fi

echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

echo "Installing required dependencies..."
sudo apt install -y curl

echo "Adding Grafana's GPG key..."
sudo curl -fsSL https://packages.grafana.com/gpg.key | gpg --dearmor -o /usr/share/keyrings/grafana-archive-keyring.gpg

echo "Adding Grafana's stable repository to sources list..."
echo "deb [signed-by=/usr/share/keyrings/grafana-archive-keyring.gpg] https://packages.grafana.com/oss/deb stable main" | sudo tee /etc/apt/sources.list.d/grafana.list > /dev/null

echo "Updating package list to include Grafana repository..."
sudo apt update

echo "Installing Grafana..."
sudo apt install grafana -y

echo "Starting Grafana service..."
sudo systemctl start grafana-server

echo "Enabling Grafana service to start at boot..."
sudo systemctl enable grafana-server

echo "Checking Grafana service status..."
sudo systemctl status grafana-server --no-pager

echo "Grafana installation complete!"
echo "Access Grafana at: http://<your-server-ip>:3000"
echo "Default Username: admin"
echo "Default Password: admin (You will be prompted to change it on first login)"