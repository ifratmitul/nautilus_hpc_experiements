import kagglehub
import os
import shutil

download_path = "/data/brats"

print("="*60)
print("BraTS20 Dataset Download")
print("="*60)
print(f"Target location: {download_path}")
print("This may take 10-30 minutes depending on your connection...")
print("")

# Create download directory
os.makedirs(download_path, exist_ok=True)

try:
    # Download the dataset
    print("Starting download from Kaggle...")
    path = kagglehub.dataset_download("awsaf49/brats20-dataset-training-validation")
    
    print(f"\n✓ Dataset downloaded to kagglehub cache: {path}")
    print(f"Copying to PVC location: {download_path}")
    print("")
    
    # Copy all files to PVC
    if os.path.exists(path):
        for item in os.listdir(path):
            src = os.path.join(path, item)
            dst = os.path.join(download_path, item)
            
            print(f"  Copying {item}...")
            if os.path.isdir(src):
                shutil.copytree(src, dst, dirs_exist_ok=True)
            else:
                shutil.copy2(src, dst)
        
        print(f"\n✓ All files copied to {download_path}")
        
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
    else:
        print(f"Error: Download path not found: {path}")
        exit(1)
        
except Exception as e:
    print(f"\n✗ Error during download: {str(e)}")
    import traceback
    traceback.print_exc()
    exit(1)

print("\n✓ Download complete!")
print(f"Dataset saved to: {download_path}")