:: mbnq00@gmail.com
:: https://www.mbnq.pl/

@echo off
setlocal enabledelayedexpansion
title Discordiffy by mbnq.pl
color 09

set "consoleCaret=> "
set "ffmpegPath=bin\ffmpeg.exe"


if not exist !ffmpegPath! (
    echo !consoleCaret!FFmpeg is not installed or not in system path.
    echo !consoleCaret!Please install FFmpeg and adjust it path in the script file.
    goto fail
)

:: Prompt for file if not provided as argument
if "%~1"=="" (
    echo !consoleCaret!Please drag and drop a video file onto the script or pass it as a command line argument.
    set /p input="!consoleCaret!Enter file path: "
) else (
    set "input=%~1"
)

:: Output file setup
set "output=!~dpn1_converted.mp4"

:: Conversion process
echo Converting file. Please wait...
bin\ffmpeg -i "!input!" -b:v 2M -bufsize 2M -maxrate 2M -vf "scale=-2:1080" -c:a aac -b:a 192k "!output!"

:: Check if the output file exceeds the desired maximum file size of 24.80 MB
for %%I in ("!output!") do set /a size=%%~zI/1048576
if !size! gtr 24 (
    echo File size exceeded 24.80 MB, adjusting bitrate.
    bin\ffmpeg -i "!input!" -fs 24M -c:v libx264 -crf 23 -preset veryslow -c:a aac -b:a 192k "!output!"
)

echo Conversion complete. Output file is located at: !output!
pause
endlocal

:fail
pause
exit /b 1

:bye
pause
exit /b 0