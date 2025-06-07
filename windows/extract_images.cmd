@echo off
REM Copyright (C) 2025 Whirly Bloke
REM
REM This program is free software: you can redistribute it and/or modify
REM it under the terms of the GNU General Public License as published by
REM the Free Software Foundation, either version 3 of the License, or
REM (at your option) any later version.
REM
REM This program is distributed in the hope that it will be useful,
REM but WITHOUT ANY WARRANTY; without even the implied warranty of
REM MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
REM GNU General Public License for more details.
REM
REM You should have received a copy of the GNU General Public License
REM along with this program. If not, see <https://www.gnu.org/licenses/>.

REM This script automates the process of extracting images from video files within a specified input directory,
REM allowing the user to specify the output directory, image quality (as 'high', 'medium', 'low', or qscale number), and interval in seconds for extraction.
REM The extracted images are saved in a subdirectory called extracted_images in the source video directory.
REM Original author: Whirly Bloke

IF "%~1"=="" (
    echo Usage: %~nx0 ^<directory^> [quality] [interval]
    echo   - ^<directory^>: The directory containing .mp4 or .MP4 files.
    echo   - [quality]: Optional image quality ('high', 'medium', 'low', or qscale number, default: high).
    echo   - [interval]: Optional interval in seconds between images (default: 2 seconds).
    echo   - e.g. extract_images.cmd C:\videos high 3
    exit /b 1
)

SET "input_dir=%~1"
SET "quality=%~2"
IF "%quality%"=="" SET "quality=high"
SET "interval=%~3"
IF "%interval%"=="" SET "interval=2"

REM Map human-readable quality to qscale value
SET "qscale="
IF /I "%quality%"=="high" SET "qscale=2"
IF /I "%quality%"=="best" SET "qscale=2"
IF /I "%quality%"=="medium" SET "qscale=5"
IF /I "%quality%"=="med" SET "qscale=5"
IF /I "%quality%"=="low" SET "qscale=10"
IF /I "%quality%"=="worst" SET "qscale=10"
REM If not set, check if it's a number
IF "%qscale%"=="" (
    SET /A testnum=%quality% 2>NUL
    IF "%testnum%"=="%quality%" (
        SET "qscale=%quality%"
    ) ELSE (
        echo Unknown quality: %quality%. Use 'high', 'medium', 'low', or a qscale number.
        exit /b 1
    )
)

REM Calculate fps as 1/interval (rounded to 2 decimal places)
SETLOCAL ENABLEDELAYEDEXPANSION
SET "fps="
FOR /F "usebackq tokens=*" %%F IN (`powershell -Command "[math]::Round(1/%interval%,2)"`) DO SET "fps=%%F"
ENDLOCAL & SET "fps=%fps%"

REM Check if ffmpeg is installed
where ffmpeg >nul 2>nul
IF ERRORLEVEL 1 (
    echo Error: ffmpeg is not installed or not in your PATH.
    exit /b 1
)

REM Check if the input directory exists
IF NOT EXIST "%input_dir%\" (
    echo Error: Directory '%input_dir%' does not exist.
    exit /b 1
)

REM Create output directory
SET "output_dir=%input_dir%\extracted_images"
IF NOT EXIST "%output_dir%" mkdir "%output_dir%"

REM Gather video files (.mp4 and .MP4)
SETLOCAL ENABLEDELAYEDEXPANSION
SET "found_file=0"
FOR %%F IN ("%input_dir%\*.mp4" "%input_dir%\*.MP4") DO (
    IF EXIST "%%F" (
        SET "found_file=1"
        GOTO :found
    )
)
:found
IF "!found_file!"=="0" (
    echo No .mp4 or .MP4 video files found in '%input_dir%'.
    ENDLOCAL
    exit /b 0
)

echo Extraction started ....
FOR %%F IN ("%input_dir%\*.mp4" "%input_dir%\*.MP4") DO (
    IF EXIST "%%F" (
        SET "mp4_file=%%F"
        SET "filename_with_extension=%%~nxF"
        SET "filename_no_extension=%%~nF"
        SET "filename_no_spaces=!filename_no_extension: =_!"
        SET "output_pattern=%output_dir%\!filename_no_spaces!_%%d.jpg"
        ffmpeg -loglevel error -i "%%F" -vf "fps=%fps%" -q:v %qscale% "!output_pattern!"
        echo Extracted frames from '%%F' to '%output_dir%' with quality '%quality%' (qscale %qscale%) and interval %interval% seconds.
    )
)
ENDLOCAL

echo Extraction complete. Images saved in '%output_dir%' with quality '%quality%' (qscale %qscale%) and interval %interval% seconds.