#!/bin/bash
set -e  # Exit on any error

echo "=========================================="
echo "Setting up VinDr-CXR environment..."
echo "=========================================="

# Check if we're in the right directory
if [ ! -d "/data/vindr-cxr" ]; then
    echo "Error: /data/vindr-cxr directory not found!"
    echo "Available directories in /data:"
    ls -la /data/
    exit 1
fi

cd /data

# Update conda
echo "Updating conda..."
conda update -n base -c defaults conda -y

# Create conda environment with Python 3.9 (skip if exists)
if conda env list | grep -q "vindr-env"; then
    echo "Environment 'vindr-env' already exists, skipping creation..."
else
    echo "Creating conda environment 'vindr-env' with Python 3.9..."
    conda create -n vindr-env python=3.9 -y
fi

# Install required packages in the environment without activating
echo "Installing PyTorch with CUDA support..."
conda install -n vindr-env pytorch==2.2.0 torchvision==0.17.0 pytorch-cuda=11.8 -c pytorch -c nvidia -y

echo "Installing additional packages..."
conda run -n vindr-env pip install numpy pandas matplotlib seaborn
conda run -n vindr-env pip install scikit-learn opencv-python pillow
conda run -n vindr-env pip install pydicom nibabel
conda run -n vindr-env pip install albumentations
conda run -n vindr-env pip install tqdm

echo "=========================================="
echo "VinDr-CXR environment setup complete!"
echo "=========================================="
echo "Environment: vindr-env (Python 3.9)"
echo "Location: /data/vindr-cxr/"
echo ""

# Verify installations using conda run (without activating)
echo "Verifying installations..."
conda run -n vindr-env python -c "import torch; print(f'✓ PyTorch: {torch.__version__}')" || echo "✗ PyTorch installation failed"
conda run -n vindr-env python -c "import numpy; print(f'✓ NumPy: {numpy.__version__}')" || echo "✗ NumPy installation failed"
conda run -n vindr-env python -c "import pandas; print(f'✓ Pandas: {pandas.__version__}')" || echo "✗ Pandas installation failed"
conda run -n vindr-env python -c "import cv2; print('✓ OpenCV installed')" || echo "✗ OpenCV installation failed"
conda run -n vindr-env python -c "import pydicom; print('✓ pydicom installed')" || echo "✗ pydicom installation failed"

# Test CUDA if available
if conda run -n vindr-env python -c "import torch; print(torch.cuda.is_available())" | grep -q "True"; then
    echo "✓ CUDA available"
    conda run -n vindr-env python -c "import torch; print(f'✓ GPU device: {torch.cuda.get_device_name(0)}')"
else
    echo "✗ CUDA not available"
fi

echo ""
echo "Setup completed successfully!"
echo "Environment 'vindr-env' is ready - activation will be handled by the job command"