#!/bin/bash
set -e  # Exit on any error

echo "=========================================="
echo "VinDr-CXR Competition Dataset Download"
echo "=========================================="

# Check if Kaggle credentials are set
if [ -z "$KAGGLE_USERNAME" ] || [ -z "$KAGGLE_KEY" ]; then
    echo "Error: Kaggle credentials not found!"
    echo "Please set KAGGLE_USERNAME and KAGGLE_KEY environment variables"
    exit 1
fi

# Create .kaggle directory and credentials file
echo "Setting up Kaggle credentials..."
mkdir -p /root/.kaggle
echo "{\"username\":\"$KAGGLE_USERNAME\",\"key\":\"$KAGGLE_KEY\"}" > /root/.kaggle/kaggle.json
chmod 600 /root/.kaggle/kaggle.json
echo "✓ Kaggle credentials configured"

# Install curl if not available
echo ""
echo "Installing curl if not available..."
if ! command -v curl &> /dev/null; then
    apt-get update -qq
    apt-get install -y curl
fi

echo ""
echo "=========================================="
echo "Starting competition dataset download..."
echo "WARNING: This is 205 GB and will take time!"
echo "=========================================="
echo ""

# Run the Python download script
python wget_download.py

echo ""
echo "=========================================="
echo "Download process completed!"
echo "=========================================="