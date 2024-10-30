@echo off
set "bazarPath=C:\Program Files\Snippingtool\bazar.sys"
set "mapperPath=C:\Program Files\Snippingtool\map.exe"

echo Running mapper.exe with bazar.sys > log.txt 2>&1
"%mapperPath%" "%bazarPath%" >> log.txt 2>&1

pause
