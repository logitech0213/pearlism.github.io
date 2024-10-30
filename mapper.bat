@echo off
set "bazarPath="bazar.sys"
set "mapperPath="map.exe"

:: Drag bazar.sys onto mapper.exe
echo Running mapper.exe with bazar.sys
"%mapperPath%" "%bazarPath%"

pause
