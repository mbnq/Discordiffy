:: mbnq00@gmail.com
:: https://www.mbnq.pl/

REM 	This simple script converts video file until it gets under 10.00MB 
REM 	to fit into free Discord video upload size limit.
REM		Simply drag'n'drop video file onto script file.
REM 	This script uses ffmpeg.exe, you can find it on the web. 

@echo off
setlocal enabledelayedexpansion
title Discordiffy by mbnq.pl
color 09

set "cc=> "
set "ffmpegPath=bin\ffmpeg.exe"

cls

call :intro

if not exist !ffmpegPath! (
    echo !cc!FFmpeg is not installed or not in system path.
    echo !cc!Please install FFmpeg and adjust it path in the script file.
    goto fail
)

if "%~1"=="" (
    echo !cc!Please drag and drop a video file onto the script or pass it as a command line argument.
    set /p input="!cc!Enter file path: "
) else (
    set "input=%~1"
)

if not exist "!input!" (
	echo !cc! could not access !input! file.
	goto fail
)

for %%I in ("!input!") do set /a input_size=%%~zI
if !input_size! leq 10471117 (
    echo !cc!Input file is already under 10MB.
	goto fail
)

set "output=%~dpn1_discordiffied.mp4"
if exist !output! del /Q /f !output!

echo !cc!Converting file. Please wait...
	!ffmpegPath! -loglevel warning -stats -i "!input!" -b:v 2M -bufsize 2M -maxrate 2M -vf "scale=-2:1080" -c:a aac -b:a 192k "!output!"

if %ERRORLEVEL% neq 0 (
	echo !cc!Something went wrong...
	goto fail
)

for %%I in ("!output!") do set /a size=%%~zI/1048576
if !size! gtr 10 (
    echo !cc!File size exceeded 10.00 MB, adjusting bitrate.
    !ffmpegPath! -y -loglevel warning -stats -i "!input!" -fs 10M -c:v libx264 -crf 28 -preset veryslow -c:a aac -b:a 128k "!output!"
)

if %ERRORLEVEL% neq 0 (
	echo !cc!Something went wrong...
	goto fail
)

goto bye

:fail
echo !cc!Press any key to exit...
pause > nul
endlocal
exit /b 1

:bye
echo.
echo !cc!Conversion complete!
echo !cc!Output file is located at: 
echo !cc!!output!
echo.
echo !cc!Press any key to exit...
pause > nul
endlocal
exit /b 0

:intro
	cls
	echo *********************************************************
	echo *                                                       *
	echo *                   Discordiffy                         *
	echo *                                                       *
	echo *                                        mbnq.pl 2024   *
	echo *                                                       *
	echo *********************************************************
	echo.
	exit /b
