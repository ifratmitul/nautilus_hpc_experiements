#!/bin/bash
set -e  # Exit on any error

echo "=========================================="
echo "Setting up LieConv environment..."
echo "=========================================="

# Check if we're in the right directory (now /data/lieconv instead of /lieconv)
if [ ! -d "/data/lieconv" ]; then
    echo "Error: /data/lieconv directory not found!"
    echo "Available directories in /data:"
    ls -la /data/
    exit 1
fi

cd /data/lieconv

# Update conda
echo "Updating conda..."
conda update -n base -c defaults conda -y

# Create conda environment with Python 3.8 (skip if exists)
if conda env list | grep -q "lieconv"; then
    echo "Environment 'lieconv' already exists, skipping creation..."
else
    echo "Creating conda environment 'lieconv' with Python 3.8..."
    conda create -n lieconv python=3.8 -y
fi

# DO NOT activate environment here - let the job command handle it
# This matches the pattern of your working job

# Install required packages in the environment without activating
echo "Installing PyTorch and torchvision..."
conda install -n lieconv pytorch torchvision -c pytorch -y

echo "Installing additional packages..."
conda run -n lieconv pip install numpy scipy matplotlib sympy tqdm

# Check if LieConv directory exists
if [ ! -d "LieConv" ]; then
    echo "Error: LieConv subdirectory not found!"
    echo "Available items in /data/lieconv:"
    ls -la /data/lieconv/
    exit 1
fi

# Navigate to LieConv directory and install the package
echo "Installing LieConv package..."
cd LieConv
conda run -n lieconv pip install -e .

# Navigate back to main lieconv directory
cd /data/lieconv

echo "=========================================="
echo "LieConv environment setup complete!"
echo "=========================================="
echo "Environment: lieconv (Python 3.8)"
echo "Location: /data/lieconv/"
echo "Ready to run: python test_train.py"
echo ""

# Verify installations using conda run (without activating)
echo "Verifying installations..."
conda run -n lieconv python -c "import torch; print(f'✓ PyTorch: {torch.__version__}')" || echo "✗ PyTorch installation failed"
conda run -n lieconv python -c "import numpy; print(f'✓ NumPy: {numpy.__version__}')" || echo "✗ NumPy installation failed"
conda run -n lieconv python -c "import scipy; print('✓ SciPy installed')" || echo "✗ SciPy installation failed"
conda run -n lieconv python -c "import matplotlib; print('✓ Matplotlib installed')" || echo "✗ Matplotlib installation failed"
conda run -n lieconv python -c "import sympy; print('✓ SymPy installed')" || echo "✗ SymPy installation failed"
conda run -n lieconv python -c "import tqdm; print('✓ tqdm installed')" || echo "✗ tqdm installation failed"

# Test CUDA if available
if conda run -n lieconv python -c "import torch; print(torch.cuda.is_available())" | grep -q "True"; then
    echo "✓ CUDA available"
    conda run -n lieconv python -c "import torch; print(f'✓ GPU device: {torch.cuda.get_device_name(0)}')"
else
    echo "✗ CUDA not available"
fi

echo ""
echo "Setup completed successfully!"
echo "Environment is ready - activation will be handled by the job command"