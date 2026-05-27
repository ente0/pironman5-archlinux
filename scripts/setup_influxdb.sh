#!/bin/bash

set -euo pipefail
trap 'echo "Error occurred. Exiting..." >&2; exit 1' ERR

# Check root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Check if argument exists before accessing $1
if [ $# -ge 1 ] && [ "$1" == "--uninstall" ]; then
    exit 0
fi

echo "Setup InfluxDB for Arch Linux..."

if pacman -Qi influxdb &>/dev/null; then
    echo "InfluxDB is already installed."
else
    echo "Installing InfluxDB via pacman..."
    pacman -S --noconfirm --needed influxdb
fi

echo "Enabling and starting InfluxDB service..."
systemctl enable influxdb
systemctl start influxdb
