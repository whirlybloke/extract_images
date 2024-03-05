#!/bin/bash
# This script automates the process of extracting images from video files within a specified input directory, allowing the user 
# to specify the output directory, image quality scale (qscale), and frames per second (fps) for extraction. 
# The extracted images are saved a sub directory called extracted_images in the source video directory.

if [ $# -lt 1 ]; then
    echo "Usage: $0 <directory> [qscale] [fps]"
    echo "  - <directory>: The directory containing .mp4 or .MP4 files."
    echo "  - [qscale]: Optional qscale (image quality, default: 2)."
    echo "  - [fps]: Optional frames per second (default: 0.5 images per second = 1/fps)."
    echo "  - e.g. ./extract_images.sh /images 2 0.5 gives best quality and images every 2 seconds"
    exit 1
fi

input_dir="$1"
qscale=${2:-2}      # Use 2 as the default qscale if not provided
fps=${3:-0.5}       # Use 0.5 as the default fps if not provided

# Check if the input directory exists
if [ ! -d "$input_dir" ]; then
    echo "Error: Directory '$input_dir' does not exist."
    exit 1
fi

# Create an output directory for the extracted images
output_dir="${input_dir}/extracted_images"
mkdir -p "$output_dir"

# Iterate over .mp4 and .MP4 files in the input directory
shopt -s nocaseglob  # Enable case-insensitive globbing
for mp4_file in "${input_dir}"/*.mp4 "${input_dir}"/*.MP4; do
    if [ -f "$mp4_file" ]; then
        # Extract frames from the .mp4 file with the specified FPS
        filename_with_extension=$(basename -- "$mp4_file")
        filename_no_extension="${filename_with_extension%.*}"
        filename_no_spaces="${filename_no_extension// /_}"
        output_pattern="${output_dir}/${filename_no_spaces}_%d.jpg"
        
        ffmpeg -i "$mp4_file" -vf "fps=${fps}" -q:v "$qscale" "$output_pattern"
        
        echo "Extracted frames from '$mp4_file' to '$output_dir' with qscale $qscale and FPS $fps."
    fi
done

echo "Extraction complete. Images saved in '$output_dir' with qscale $qscale and FPS $fps."
