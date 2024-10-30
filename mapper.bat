@echo off
set "bazarPath=C:\Program Files\Snippingtool\bazar.sys"
set "mapperPath=C:\Program Files\Snippingtool\map.exe"

:: Drag bazar.sys onto mapper.exe
echo Running mapper.exe with bazar.sys
"%mapperPath%" "%bazarPath%"

pause
