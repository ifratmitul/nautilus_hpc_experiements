#!/bin/bash
set -e  # Exit on any error

echo "=========================================="
echo "BraTS20 Dataset Download Script"
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

# Install kagglehub
echo ""
echo "Installing kagglehub..."
pip install --quiet kagglehub

echo ""
echo "=========================================="
echo "Starting dataset download..."
echo "=========================================="
echo ""

# Run the Python download script
python download_brats20.py

echo ""
echo "=========================================="
echo "Download process completed!"
echo "=========================================="