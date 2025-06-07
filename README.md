# README

## Overview

This project offers scripts for extracting images from video files across multiple operating systems. It includes a Bash script (`extract_images.sh`) for macOS and Linux users, and a CMD line script (`extract_images.cmd`) for Windows users. These scripts automate the process of extracting images from video files, allowing for customization of quality and extraction interval.

## Installation Requirements

### FFmpeg Dependency

The extraction process is powered by FFmpeg, a comprehensive multimedia framework that needs to be installed on your system.

- **For macOS Users:**
  - Installation guide: [FFmpeg Installation on macOS](https://ffmpeg.org/download.html#build-mac)
  - You can also install ffmpeg using Homebrew:  
    ```
    brew install ffmpeg
    ```

- **For Windows Users:**
  - Installation guide: [FFmpeg Installation on Windows](https://ffmpeg.org/download.html#build-windows)

Ensure FFmpeg is installed on your system before proceeding with the script usage.

## Usage Instructions

### 1. Bash Script for macOS/Linux

- Make the script executable:  
  ```
  chmod +x extract_images.sh
  ```
- To run, use the following syntax:  
  ```
  ./extract_images.sh <directory> [quality] [interval]
  ```
- Extracted images will be in the `extracted_images` subdirectory of the video source directory.

**Parameters:**
- `<directory>`: The directory containing `.mp4` or `.MP4` files.
- `[quality]`: Optional, image quality (`high`, `medium`, `low`, or a qscale number; default is `high`).
- `[interval]`: Optional, interval in seconds between images (default is `2`).

**Examples:**
- Extract every 3 seconds at high quality:  
  ```
  ./extract_images.sh /videos high 3
  ```

### 2. CMD Line Script for Windows

- Navigate to the script's directory in CMD.
- Execute the script using the following syntax:  
  ```
  extract_images.cmd <directory> [quality] [interval]
  ```
- Parameters are similar to the Bash script:
  - `<directory>`: Directory containing `.mp4` files.
  - `[quality]`: Optional, image quality (`high`, `medium`, `low`, or a qscale number; default is `high`).
  - `[interval]`: Optional, interval in seconds between images (default is `2`).
- Extracted images will be in the `extracted_images` subdirectory of the video source directory.

### 3. Parameter Details

- **Interval values:**  
  - For one image every second, use `interval = 1`
  - For one image every 2 seconds, use `interval = 2` (default)
  - For one image every 10 seconds, use `interval = 10`

- **Quality (qscale) values:**  
  - Highest quality: `high` or `1`
  - Medium quality: `medium` or `5`
  - Lowest quality: `low` or `10`
  - You can also specify a custom qscale number (lower is better quality; default is `high`/`2`)

### 4. Extracted Images Format

- The extracted images will be `.jpg` and named as `original_video_filename_%d.jpg`  
  (e.g. `DJI_1234.mp4` will extract images as `DJI_1234_1.jpg`, `DJI_1234_2.jpg`, etc.)
- The extracted images will be in the `<directory>/extracted_images` folder.

## Contributing

We welcome contributions! If you have improvements or fixes, please review the contribution guidelines for details on how to participate in making this project better.

## License

This project is distributed under the GNU General Public License v3.0. Please refer to the LICENSE file for the full text.

---

This README provides an essential guide to setting up and using the scripts. Ensure FFmpeg is correctly installed for the scripts to function as intended.