# README

## Overview

This project offers scripts for extracting images from video files across multiple operating systems. It includes a Bash script (`extract_images.sh`) for macOS and Linux users, and a CMD line script (`extract_images.cmd`) for Windows users. These scripts automate the process of extracting images from video files, allowing for customization of quality and frame rate.

## Installation Requirements

### FFmpeg Dependency

The extraction process is powered by FFmpeg, a comprehensive multimedia framework that needs to be installed on your system.

- **For macOS Users:**
  - Installation guide: [FFmpeg Installation on macOS](https://ffmpeg.org/download.html#build-mac)

- **For Windows Users:**
  - Installation guide: [FFmpeg Installation on Windows](https://ffmpeg.org/download.html#build-windows)

Ensure FFmpeg is installed on your system before proceeding with the script usage.

## Usage Instructions

1. **Bash Script for macOS/Linux:**
   - Make the script executable: `chmod +x extract_images.sh`
   - To run, use the following syntax:
     ```
     ./extract_images.sh <directory> [qscale] [fps]
     ```
   - Extracted images will be in the extracted_images subdirectory of the video source
   - Parameters explained:
     - `<directory>`: The directory containing .mp4 files.
     - `[qscale]`: Optional, defines the image quality scale (default is 2).
     - `[fps]`: Optional, sets the frames per second (default is 0.5).

2. **CMD Line Script for Windows:**
   - Navigate to the script's directory in CMD.
   - Execute the script using the following syntax:
     ```
     extract_images.cmd <directory> [qscale] [fps]
     ```
   - Parameters are similar to the Bash script, with `<directory>` indicating where your .mp4 files are located, `[qscale]` for quality scale, and `[fps]` for frame rate.
   - Extracted images will be in the extracted_images subdirectory of the video source

3. ** Parameter notes
   - Typical values for `fps` are
     - If you want one image every second, use `fps` = 1
     - If you want one image every 2 seconds, use `fps` = 0.5  (default)
     - If you want one image every 10 seconds, use `fps` = 0.1
    
  - Typical values for `qscale` are
     - If you want the highest quality, use `qscale` = 1
     - If you want high quality, use `qscale` = 2  (default)
     - If you want thwe lowest quality, use `qscale` = 32

## Contributing

We welcome contributions! If you have improvements or fixes, please review the contribution guidelines for details on how to participate in making this project better.

## License

This project is distributed under the MIT License. Please refer to the LICENSE file for full text.

---

This README provides an essential guide to setting up and using the scripts. Ensure FFmpeg is correctly installed for the scripts to function as intended.
