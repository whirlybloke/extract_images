@echo off
:: This script automates the process of extracting images from video files within a specified input directory, allowing the user 
:: to specify the output directory, image quality scale (qscale), and frames per second (fps) for extraction. 
:: The extracted images are saved a sub directory called extracted_images in the source video directory.

setlocal enabledelayedexpansion

:: Check for the presence of at least one argument
if "%~1"=="" (
    echo Usage: %~nx0 directory [qscale] [fps]
    echo  - directory: The directory containing .mp4 or .MP4 files.
    echo  - [qscale]: Optional qscale (image quality, default: 2).
    echo  - [fps]: Optional frames per second (default: 0.5 images per second = 1/fps).
    echo  - e.g. %~nx0 "C:\images" 2 0.5 gives best quality and images every 2 seconds
    goto :EOF
)

set "input_dir=%~1"
set "qscale=%2"
if "%qscale%"=="" set "qscale=2"
set "fps=%3"
if "%fps%"=="" set "fps=0.5"

:: Check if the input directory exists
if not exist "%input_dir%" (
    echo Error: Directory '%input_dir%' does not exist.
    goto :EOF
)

:: Create an output directory for the extracted images
set "output_dir=%input_dir%\extracted_images"
if not exist "%output_dir%" mkdir "%output_dir%"

:: Iterate over .mp4 and .MP4 files in the input directory
for %%F in ("%input_dir%\*.mp4", "%input_dir%\*.MP4") do (
    if exist "%%~fF" (
        set "filename=%%~nF"
        set "filename_no_spaces=!filename: =_!"
        set "output_pattern=%output_dir%\!filename_no_spaces!_%%d.jpg"
        
        ffmpeg -loglevel error -i "%%~fF" -vf "fps=!fps!" -q:v %qscale% "!output_pattern!"
        
        echo Extracted frames from '%%~fF' to '%output_dir%' with qscale %qscale% and FPS !fps!.
    )
)

echo Extraction complete. Images saved in '%output_dir%' with qscale %qscale% and FPS %fps%.
