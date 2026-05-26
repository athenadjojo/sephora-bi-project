import kagglehub
import shutil
from pathlib import Path

# Download dataset
path = kagglehub.dataset_download(
    "nadyinky/sephora-products-and-skincare-reviews"
)

print("Downloaded to:", path)

# Create local data folder
destination = Path("data/raw")
destination.mkdir(parents=True, exist_ok=True)

# Copy dataset files into your project
shutil.copytree(path, destination, dirs_exist_ok=True)

print("Dataset copied to data/raw")