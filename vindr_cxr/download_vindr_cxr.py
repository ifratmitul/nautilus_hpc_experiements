import subprocess
import os
import shutil

download_path = "/data/vindr-cxr"

print("="*60)
print("VinDr-CXR Dataset Download (Competition)")
print("="*60)
print(f"Target location: {download_path}")
print("Dataset size: ~205 GB")
print("This will take 1-3 hours depending on your connection...")
print("")

# Create download directory
os.makedirs(download_path, exist_ok=True)

# Change to download directory
os.chdir(download_path)

try:
    print("Starting download from Kaggle Competition...")
    print("Using kaggle CLI: kaggle competitions download")
    print("")
    
    # Download using kaggle CLI
    result = subprocess.run(
        ["kaggle", "competitions", "download", "-c", "vinbigdata-chest-xray-abnormalities-detection"],
        capture_output=True,
        text=True,
        check=True
    )
    
    print(result.stdout)
    
    print("\n✓ Download complete!")
    print("Extracting files...")
    
    # Find and extract zip files
    for item in os.listdir(download_path):
        if item.endswith('.zip'):
            print(f"  Extracting {item}...")
            subprocess.run(["unzip", "-q", item], check=True)
            print(f"  ✓ Extracted {item}")
            # Optionally remove zip after extraction
            # os.remove(item)
    
    # List downloaded files
    print("\n" + "="*60)
    print("Downloaded files:")
    print("="*60)
    total_size = 0
    for item in os.listdir(download_path):
        item_path = os.path.join(download_path, item)
        if os.path.isdir(item_path):
            size = sum(os.path.getsize(os.path.join(dp, f)) 
                      for dp, dn, fn in os.walk(item_path) 
                      for f in fn)
            total_size += size
            print(f"  [DIR]  {item}/ ({size / (1024**3):.2f} GB)")
        else:
            size = os.path.getsize(item_path)
            total_size += size
            print(f"  [FILE] {item} ({size / (1024**2):.2f} MB)")
    
    print("="*60)
    print(f"Total size: {total_size / (1024**3):.2f} GB")
    print("="*60)
        
except subprocess.CalledProcessError as e:
    print(f"\n✗ Error during download: {e}")
    print(f"STDOUT: {e.stdout}")
    print(f"STDERR: {e.stderr}")
    exit(1)
except Exception as e:
    print(f"\n✗ Error: {str(e)}")
    import traceback
    traceback.print_exc()
    exit(1)

print("\n✓ Download and extraction complete!")
print(f"Dataset saved to: {download_path}")