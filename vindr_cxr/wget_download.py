import subprocess
import os

download_path = "/data/vindr-cxr"
kaggle_username = os.environ.get('KAGGLE_USERNAME')
kaggle_key = os.environ.get('KAGGLE_KEY')

print("="*60)
print("VinDr-CXR Dataset Download (using curl)")
print("="*60)
print(f"Target location: {download_path}")
print("Dataset size: ~205 GB")
print("Using curl for minimal memory usage...")
print("")

# Create download directory
os.makedirs(download_path, exist_ok=True)

# Change to download directory
os.chdir(download_path)

try:
    print("Starting download using curl...")
    print("This will take 1-3 hours depending on network speed...")
    print("")
    
    # Use curl with Kaggle API authentication
    # Kaggle API uses HTTP Basic Auth with username:key
    download_url = "https://www.kaggle.com/api/v1/competitions/data/download-all/vinbigdata-chest-xray-abnormalities-detection"
    
    result = subprocess.run([
        "curl",
        "-L",  # Follow redirects
        "-#",  # Show progress bar
        "-u", f"{kaggle_username}:{kaggle_key}",  # Basic auth
        download_url,
        "-o", "vindr-cxr-dataset.zip"
    ], check=True)
    
    print("\n✓ Download complete!")
    
    # List downloaded files
    print("\n" + "="*60)
    print("Downloaded files:")
    print("="*60)
    
    for item in os.listdir(download_path):
        item_path = os.path.join(download_path, item)
        if os.path.isfile(item_path):
            size = os.path.getsize(item_path)
            print(f"  [FILE] {item} ({size / (1024**3):.2f} GB)")
    
    print("="*60)
    print("\nFiles downloaded successfully (not extracted).")
    print("To extract: unzip vindr-cxr-dataset.zip")
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