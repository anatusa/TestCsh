::-----------------------------------------------------------------------
::  Together Fuzzy Search
::  Copyright (C) 2011 Together Teamsolutions Co., Ltd.
::
::  This program is free software: you can redistribute it and/or modify
::  it under the terms of the GNU General Public License as published by
::  the Free Software Foundation, either version 3 of the License, or
::  (at your option) any later version.
::
::  This program is distributed in the hope that it will be useful,
::  but WITHOUT ANY WARRANTY; without even the implied warranty of
::  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
::  GNU General Public License for more details.
:: 
::  You should have received a copy of the GNU General Public License
::  along with this program. If not, see http://www.gnu.org/licenses
::-----------------------------------------------------------------------
@echo off
cls

SET NANTHOME=./tools/nant

SET APP_NAME=X

"%NANTHOME%\bin\nant.exe" -D:output.name=app.name -D:property.file="%CD%/project.build" -buildfile:"%CD%/configure/configure.build.xml" property.export > nul
for /F "tokens=1,2* delims==" %%i in (app.name.txt) do SET APP_NAME=%%j
del app.name.txt>nul

if "X%~1"=="X" goto help
if %~1==help goto help
if %~1==buildAll goto continue
if %~1==buildDoc goto continue
if %~1==buildNoDoc goto continue
if %~1==clean goto continue
if %~1==debug goto continue
if %~1==distributions goto continue
if %~1==install goto continue

:continue

if not exist properties.build configure.bat

"%NANTHOME%\bin\nant.exe" %1
goto end

:help
echo.
echo Parameters value for using with make.bat :
echo.
echo make			- Displays the Help screen.
echo make help		- Displays the Help screen.
echo make buildAll		- Builds and configures %APP_NAME% with documentation.
echo make buildNoDoc		- Builds and configures %APP_NAME% without documentation
echo make buildDoc		- Builds documentation only
echo make clean		- Removes the output and distribution folder
echo 			  (in order to start a new compilation from scratch)
echo make debug		- Builds and configures %APP_NAME% debug version.
echo make distributions	- Builds and configures %APP_NAME% with all documentations
echo 			  and creates distribution package.
echo make install		- Installs and configures %APP_NAME% into directory defined by
echo 			  parameter install.dir in build.properties file.
echo 			  Which can be set by using the command:
echo 			  configure -instdir PATH_TO_DIR.
echo 			  (execute only after 'make buildAll').
goto end


:end
SET NANTHOME=
