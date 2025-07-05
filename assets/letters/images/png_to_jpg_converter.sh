#!/bin/bash

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null; then
    echo "Error: ImageMagick is not installed. Please install it first."
    exit 1
fi

# Set the source directory (current directory by default, or pass as argument)
SOURCE_DIR="${1:-.}"

# Create the jpgs directory if it doesn't exist
mkdir -p "$SOURCE_DIR/jpgs"

# Counter for processed files
count=0

# Process all PNG files in the source directory
for png_file in "$SOURCE_DIR"/*.png; do
    # Check if any PNG files exist
    if [ ! -f "$png_file" ]; then
        echo "No PNG files found in $SOURCE_DIR"
        exit 1
    fi
    
    # Get the filename without extension
    filename=$(basename "$png_file" .png)
    
    # Convert PNG to JPG with 500x500 resolution
    convert "$png_file" -resize 500x500 "$SOURCE_DIR/jpgs/$filename.jpg"
    
    # Check if conversion was successful
    if [ $? -eq 0 ]; then
        echo "Converted: $filename.png → jpgs/$filename.jpg"
        ((count++))
    else
        echo "Error converting: $filename.png"
    fi
done

echo "Conversion complete! Processed $count files."