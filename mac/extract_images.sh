#!/bin/bash
# Copyright (C) 2025 Whirly Bloke
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.

# This script automates the process of extracting images from video files within a specified input directory,
# allowing the user to specify the output directory, image quality (as 'high', 'medium', 'low', or qscale number), and interval in seconds for extraction.
# The extracted images are saved in a subdirectory called extracted_images in the source video directory.
# Original author: Whirly Bloke


if [ $# -lt 1 ]; then
    echo "Usage: $0 <directory> [quality] [interval]"
    echo "  - <directory>: The directory containing .mp4 or .MP4 files."
    echo "  - [quality]: Optional image quality ('high', 'medium', 'low', or qscale number, default: high)."
    echo "  - [interval]: Optional interval in seconds between images (default: 2 seconds)."
    echo "  - e.g. ./extract_images.sh /videos high 3 gives best quality and images every 3 seconds"
    exit 1
fi

input_dir="$1"
quality=${2:-high}   # Default to "high" if not provided

# Map human-readable quality to qscale value
case "$quality" in
    high|best)
        qscale=2
        ;;
    medium|med)
        qscale=5
        ;;
    low|worst)
        qscale=10
        ;;
    [0-9]*)
        qscale=$quality
        ;;
    *)
        echo "Unknown quality: $quality. Use 'high', 'medium', 'low', or a qscale number."
        exit 1
        ;;
esac

interval=${3:-2}
fps=$(bc -l <<< "1/$interval")  # Calculate fps as the reciprocal of the interval in seconds

# Check if ffmpeg is installed
if ! command -v ffmpeg >/dev/null 2>&1; then
    echo "Error: ffmpeg is not installed or not in your PATH."
    exit 1
fi

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

# Gather video files
video_files=("${input_dir}"/*.mp4)

# Check if there are any video files
found_file=false
for mp4_file in "${video_files[@]}"; do
    if [ -f "$mp4_file" ]; then
        found_file=true
        break
    fi
done

if ! $found_file; then
    echo "No .mp4 video files found in '$input_dir'."
    exit 0
fi

echo "Extraction started ...."
for mp4_file in "${video_files[@]}"; do
    if [ -f "$mp4_file" ]; then
        # Extract frames from the .mp4 file at the calculated FPS
        filename_with_extension=$(basename -- "$mp4_file")
        filename_no_extension="${filename_with_extension%.*}"
        filename_no_spaces="${filename_no_extension// /_}"
        output_pattern="${output_dir}/${filename_no_spaces}_%d.jpg"

        ffmpeg -loglevel error -i "$mp4_file" -vf "fps=${fps}" -q:v "$qscale" "$output_pattern"

        echo "Extracted frames from '$mp4_file' to '$output_dir' with quality '$quality' (qscale $qscale) and interval $interval seconds."
    fi
done

echo "Extraction complete. Images saved in '$output_dir' with quality '$quality' (qscale $qscale) and interval $interval seconds."