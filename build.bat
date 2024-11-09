@echo off
setlocal enabledelayedexpansion

set BASE_TITLE=Build Script by Chair hub/419
call :setESC

title %BASE_TITLE%

title %BASE_TITLE% - Checking for Python Installation
echo Checking for Python installation...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo %ESC%[31mPython is not installed. Please install Python from https://www.python.org/%ESC%[0m
    pause
    exit /b
) else (
    echo %ESC%[32mPython is installed.%ESC%[0m
)

title %BASE_TITLE% - Checking if Python is in PATH
echo Checking if Python is added to PATH...
where python >nul 2>&1
if %errorlevel% neq 0 (
    echo %ESC%[31mPython is not in PATH. Please reinstall Python and check "Add Python to PATH" during installation.%ESC%[0m
    pause
    exit /b
) else (
    echo %ESC%[32mPython is in PATH.%ESC%[0m
)

title %BASE_TITLE% - Checking for pip Installation
echo Checking for pip...
pip --version >nul 2>&1
if %errorlevel% neq 0 (
    echo %ESC%[33mpip is not installed. Installing pip...%ESC%[0m
    python -m ensurepip --upgrade
    echo %ESC%[32mpip has been successfully installed.%ESC%[0m
) else (
    echo %ESC%[32mpip is installed.%ESC%[0m
)

title %BASE_TITLE% - Installing Dependencies
echo Installing dependencies...
pip install customtkinter keyboard mouse screeninfo 

if %errorlevel% neq 0 (
    echo %ESC%[31mDependency installation failed. Please check your internet connection and try again.%ESC%[0m
    pause
    exit /b
) else (
    echo %ESC%[32mAll dependencies installed successfully.%ESC%[0m
)
pause
