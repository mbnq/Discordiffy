@echo off
setlocal

:: Check for FFmpeg in system path
REM where ffmpeg >nul 2>&1
REM if %errorlevel% neq 0 (
    REM echo FFmpeg is not installed or not in system path.
    REM echo Please install FFmpeg and add it to your system path.
    REM exit /b 1
REM )

:: Prompt for file if not provided as argument
if "%~1"=="" (
    echo Please drag and drop a video file onto the script or pass it as a command line argument.
    set /p input="Enter file path: "
) else (
    set "input=%~1"
)

:: Output file setup
set "output=%~dpn1_converted.mp4"

:: Conversion process
echo Converting file. Please wait...
bin\ffmpeg -i "%input%" -b:v 2M -bufsize 2M -maxrate 2M -vf "scale=-2:1080" -c:a aac -b:a 192k "%output%"

:: Check if the output file exceeds the desired maximum file size of 24.80 MB
for %%I in ("%output%") do set /a size=%%~zI/1048576
if %size% gtr 24 (
    echo File size exceeded 24.80 MB, adjusting bitrate.
    bin\ffmpeg -i "%input%" -fs 24M -c:v libx264 -crf 23 -preset veryslow -c:a aac -b:a 192k "%output%"
)

echo Conversion complete. Output file is located at: %output%
pause
endlocal
