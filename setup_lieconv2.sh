#!/bin/bash
set -e  # Exit on any error

echo "=========================================="
echo "Setting up LieConv environment for data2..."
echo "=========================================="

# Check if we're in the right directory (now /data/data2/lieconv)
if [ ! -d "/data/data2/lieconv" ]; then
    echo "Error: /data/data2/lieconv directory not found!"
    echo "Available directories in /data/data2:"
    ls -la /data/data2/
    exit 1
fi

cd /data/data2/lieconv

# Update conda
echo "Updating conda..."
conda update -n base -c defaults conda -y

# Create conda environment with Python 3.8 (skip if exists) - NEW ENVIRONMENT NAME
if conda env list | grep -q "lieconv2"; then
    echo "Environment 'lieconv2' already exists, skipping creation..."
else
    echo "Creating conda environment 'lieconv2' with Python 3.8..."
    conda create -n lieconv2 python=3.8 -y
fi

# DO NOT activate environment here - let the job command handle it
# This matches the pattern of your working job

# Install required packages in the environment without activating
echo "Installing PyTorch and torchvision..."
conda install -n lieconv2 pytorch torchvision -c pytorch -y

echo "Installing additional packages..."
conda run -n lieconv2 pip install numpy scipy matplotlib sympy tqdm

# Check if LieConv directory exists
if [ ! -d "LieConv" ]; then
    echo "Error: LieConv subdirectory not found!"
    echo "Available items in /data/data2/lieconv:"
    ls -la /data/data2/lieconv/
    exit 1
fi

# Navigate to LieConv directory and install the package
echo "Installing LieConv package..."
cd LieConv
conda run -n lieconv2 pip install -e .

# Navigate back to main lieconv directory
cd /data/data2/lieconv

echo "=========================================="
echo "LieConv environment setup complete!"
echo "=========================================="
echo "Environment: lieconv2 (Python 3.8)"
echo "Location: /data/data2/lieconv/"
echo "Ready to run: python test_train.py"
echo ""

# Verify installations using conda run (without activating)
echo "Verifying installations..."
conda run -n lieconv2 python -c "import torch; print(f'✓ PyTorch: {torch.__version__}')" || echo "✗ PyTorch installation failed"
conda run -n lieconv2 python -c "import numpy; print(f'✓ NumPy: {numpy.__version__}')" || echo "✗ NumPy installation failed"
conda run -n lieconv2 python -c "import scipy; print('✓ SciPy installed')" || echo "✗ SciPy installation failed"
conda run -n lieconv2 python -c "import matplotlib; print('✓ Matplotlib installed')" || echo "✗ Matplotlib installation failed"
conda run -n lieconv2 python -c "import sympy; print('✓ SymPy installed')" || echo "✗ SymPy installation failed"
conda run -n lieconv2 python -c "import tqdm; print('✓ tqdm installed')" || echo "✗ tqdm installation failed"

# Test CUDA if available
if conda run -n lieconv2 python -c "import torch; print(torch.cuda.is_available())" | grep -q "True"; then
    echo "✓ CUDA available"
    conda run -n lieconv2 python -c "import torch; print(f'✓ GPU device: {torch.cuda.get_device_name(0)}')"
else
    echo "✗ CUDA not available"
fi

echo ""
echo "Setup completed successfully!"
echo "Environment 'lieconv2' is ready - activation will be handled by the job command"