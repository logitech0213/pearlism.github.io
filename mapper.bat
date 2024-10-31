@echo off
:: Check if the script is running with admin privileges
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Requesting administrative privileges...
    :: Relaunch the script with admin privileges
    powershell -Command "Start-Process -File '%~f0' -Verb RunAs"
    exit /b
)
set "bazarPath=C:\Program Files\Snippingtool\bazar.sys"
set "mapperPath=C:\Program Files\Snippingtool\map.exe"

echo Running mapper.exe with bazar.sys > log.txt 2>&1
"%bazarPath%" "%mapperPath%" >> log.txt 2>&1

echo - Made By Landen419
pause
