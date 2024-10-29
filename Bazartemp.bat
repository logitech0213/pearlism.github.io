@echo off
::Check for admin privileges
net session > nul 2 > &1
if % errorLevel % neq 0(
    echo Requesting administrative privileges...
    powershell - Command "Start-Process cmd -ArgumentList '/c \"%~f0\"' -Verb RunAs"
    exit / b
)

:: Set the path to the executable
set "exePath=C:\Program Files\Snippingtool\kdmapper.exe"
set "driver1=driver.sys"
set "data=.data"

:: Change to the directory where the executable is located
cd /d "C:\Program Files\Snippingtool"

:: Run the command with the specified parameters
"%exePath%" %driver1% %data%

:: Check the error level to determine if the command was successful
if %errorlevel% equ 0 (
    echo Setup successfully.
) else (
    echo Command failed setup with error code %errorlevel%.
)

:: Keep the command window open
pause