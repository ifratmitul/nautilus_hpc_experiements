import subprocess
import os

download_path = "/data/vindr-cxr"

print("="*60)
print("VinDr-CXR Dataset Download (Competition)")
print("="*60)
print(f"Target location: {download_path}")
print("Dataset size: ~205 GB")
print("Using streaming download to avoid OOM...")
print("")

# Create download directory
os.makedirs(download_path, exist_ok=True)

# Change to download directory
os.chdir(download_path)

try:
    print("Starting download from Kaggle Competition...")
    print("Downloading files one by one with streaming...")
    print("")
    
    # Download with streaming to avoid loading entire dataset into memory
    # The -f flag forces download, -p extracts to current directory
    result = subprocess.run(
        ["kaggle", "competitions", "download", 
         "-c", "vinbigdata-chest-xray-abnormalities-detection",
         "-p", download_path],
        check=True
    )
    
    print("\n✓ Download complete!")
    
    # List downloaded files without extracting (to avoid OOM)
    print("\n" + "="*60)
    print("Downloaded files:")
    print("="*60)
    
    for item in os.listdir(download_path):
        item_path = os.path.join(download_path, item)
        if os.path.isfile(item_path):
            size = os.path.getsize(item_path)
            print(f"  [FILE] {item} ({size / (1024**3):.2f} GB)")
    
    print("="*60)
    print("\nNOTE: Files are downloaded but NOT extracted yet.")
    print("Extract them manually or in a separate job with more memory.")
    print("To extract: unzip -q filename.zip")
    print("="*60)
        
except subprocess.CalledProcessError as e:
    print(f"\n✗ Error during download: {e}")
    exit(1)
except Exception as e:
    print(f"\n✗ Error: {str(e)}")
    import traceback
    traceback.print_exc()
    exit(1)

print("\n✓ Download complete!")
print(f"Files saved to: {download_path}")
print("\nRun extraction separately to avoid memory issues.")