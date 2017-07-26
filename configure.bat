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

:: ************************************************************************
:: *  				Initialize environment variables
:: ************************************************************************
:: **** initial data ****
SET "APP_NAME=tfs"
SET "APP_FULL_NAME=Together Fuzzy Search"
SET VERSION=2.5
SET RELEASE=1
SET COPYRIGHT_YEAR=2011
SET "COMPANY_NAME=Together Teamsolutions Co., Ltd."

SET SET_VERSION=off
SET SET_RELEASE=off
SET SET_INSTALLDIR=off
SET SET_BUILDID=off
SET SET_JDKHOME=off
SET SET_APP_NAME=off
SET SET_APP_FULL_NAME=off

SET TOOLS_PATH=%CD%/configure
SET JDKHOME=
SET NANTHOME=./tools/nant

:: *********************************************
:: *   These will be set in "properties.build",
:: *   if it does not exist
:: *********************************************

SET INSTALLDIR=
SET BUILDID=

if %~1.==. goto skiphelp
if %~1==-help goto help

:skiphelp

:initversion
"%NANTHOME%\bin\nant.exe" -D:output.name=version -D:property.file=%CD%/version.build -buildfile:%TOOLS_PATH%/configure.build.xml property.export > detail.log
if not exist version.txt goto initrelease
for /F "tokens=1,2* delims==" %%i in (version.txt) do SET VERSION=%%j
del version.txt>nul

:initrelease
"%NANTHOME%\bin\nant.exe" -D:output.name=release -D:property.file=%CD%/version.build -buildfile:%TOOLS_PATH%/configure.build.xml property.export > detail.log
if not exist release.txt goto initAppName
for /F "tokens=1,2* delims==" %%i in (release.txt) do SET RELEASE=%%j
del release.txt>nul

:initAppName
"%NANTHOME%\bin\nant.exe" -D:output.name=app.name -D:property.file=%CD%/project.build -buildfile:%TOOLS_PATH%/configure.build.xml property.export > detail.log
if not exist app.name.txt goto initAppFullName
for /F "tokens=1,2* delims==" %%i in (app.name.txt) do SET "APP_NAME=%%j"
del app.name.txt>nul

:initAppFullName
"%NANTHOME%\bin\nant.exe" -D:output.name=app.full.name -D:property.file=%CD%/project.build -buildfile:%TOOLS_PATH%/configure.build.xml property.export > detail.log
if not exist app.full.name.txt goto endskiphelp
for /F "tokens=1,2* delims==" %%i in (app.full.name.txt) do SET "APP_FULL_NAME=%%j"
del app.full.name.txt>nul

:endskiphelp
if exist properties.build goto init

goto default

:: *********************************************
:: *  Set properties values from user input
:: *********************************************
:start
if %~1.==. goto make
if %~1==-version goto version
if %~1==-release goto release
if %~1==-jdkhome goto jdkhome
if %~1==-instdir goto instdir
if %~1==-buildid goto buildid 
if %~1==-appname goto appname
if %~1==-appfullname goto appfullname
goto error

:default
call %CD%\tools\trr\readregistry.exe
if errorlevel==1 goto start
for /F "tokens=1,2* delims==" %%i in (instdir.txt) do SET JDKHOME=%%j
if not exist instdir.txt goto start
del instdir.txt>nul
goto start

:init

:initinstdir
"%NANTHOME%\bin\nant.exe" -D:output.name=install.dir -D:property.file=%CD%/properties.build -buildfile:%TOOLS_PATH%/configure.build.xml property.export > detail.log
if not exist install.dir.txt goto initbuildid
for /F "tokens=1,2* delims==" %%i in (install.dir.txt) do SET INSTALLDIR=%%j
del install.dir.txt>nul

:initbuildid
"%NANTHOME%\bin\nant.exe" -D:output.name=buildid -D:property.file=%CD%/properties.build -buildfile:%TOOLS_PATH%/configure.build.xml property.export > detail.log
if not exist buildid.txt goto initjava
for /F "tokens=1,2* delims==" %%i in (buildid.txt) do SET BUILDID=%%j
del buildid.txt>nul

:initjava
call %CD%\tools\trr\readregistry.exe
if errorlevel==1 goto endinit
for /F "tokens=1,2* delims==" %%i in (instdir.txt) do SET JDKHOME=%%j
if not exist instdir.txt goto endinit
del instdir.txt>nul

:endinit
if not exist detail.log goto start
del detail.log>nul
goto start

:: *********************************************************
:: *  Edit parameters (properties.build)
:: *********************************************************
:make
if not exist project.build goto initProjectTemplate

if not exist version.build goto initVersionTemplate

if not exist properties.build goto initBuildTemplate
goto EditParameter

:initProjectTemplate
echo ^<?xml version="1.0"?^> >project.build
echo ^<!-- >>project.build
SET "APP_FULL_NAME=%APP_FULL_NAME:^|=|%"
SET "APP_FULL_NAME=%APP_FULL_NAME:|=^|%"
echo    %APP_FULL_NAME% >>project.build
echo    Copyright (C) %COPYRIGHT_YEAR% %COMPANY_NAME% >>project.build
echo. >>project.build
echo    This program is free software: you can redistribute it and/or modify >>project.build
echo    it under the terms of the GNU General Public License as published by >>project.build
echo    the Free Software Foundation, either version 3 of the License, or >>project.build
echo    (at your option) any later version. >>project.build
echo. >>project.build
echo    This program is distributed in the hope that it will be useful, >>project.build
echo    but WITHOUT ANY WARRANTY; without even the implied warranty of >>project.build
echo    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the >>project.build
echo    GNU General Public License for more details. >>project.build
echo. >>project.build
echo    You should have received a copy of the GNU General Public License >>project.build
echo    along with this program. If not, see http://www.gnu.org/licenses >>project.build
echo --^> >>project.build
echo ^<project name="My project environment project properties" default=""^> >>project.build
SET "APP_NAME=%APP_NAME:^|=|%"
SET "APP_NAME=%APP_NAME:|=^|%"
echo   ^<property name="app.name" value="%APP_NAME%" /^> >>project.build
echo   ^<property name="app.full.name" value="%APP_FULL_NAME%" /^> >>project.build
SET "APP_FULL_NAME=%APP_FULL_NAME:^|=|%"
SET "APP_NAME=%APP_NAME:^|=|%"
echo ^</project^> >>project.build
goto make

:initVersionTemplate
echo ^<?xml version="1.0"?^> >version.build
echo ^<!-- >>version.build
SET "APP_FULL_NAME=%APP_FULL_NAME:^|=|%"
SET "APP_FULL_NAME=%APP_FULL_NAME:|=^|%"
echo    %APP_FULL_NAME% >>version.build
SET "APP_FULL_NAME=%APP_FULL_NAME:^|=|%"
echo    Copyright (C) %COPYRIGHT_YEAR% %COMPANY_NAME% >>version.build
echo. >>version.build
echo    This program is free software: you can redistribute it and/or modify >>version.build
echo    it under the terms of the GNU General Public License as published by >>version.build
echo    the Free Software Foundation, either version 3 of the License, or >>version.build
echo    (at your option) any later version. >>version.build
echo. >>version.build
echo    This program is distributed in the hope that it will be useful, >>version.build
echo    but WITHOUT ANY WARRANTY; without even the implied warranty of >>version.build
echo    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the >>version.build
echo    GNU General Public License for more details. >>version.build
echo. >>version.build
echo    You should have received a copy of the GNU General Public License >>version.build
echo    along with this program. If not, see http://www.gnu.org/licenses >>version.build
echo --^> >>version.build
echo ^<project name="My project environment version properties" default=""^> >>version.build
echo   ^<property name="version" value="%VERSION%" /^> >>version.build
echo   ^<property name="release" value="%RELEASE%" /^> >>version.build
echo ^</project^> >>version.build
goto make

:initBuildTemplate
echo ^<?xml version="1.0"?^> >properties.build
echo ^<!-- >>properties.build
SET "APP_FULL_NAME=%APP_FULL_NAME:^|=|%"
SET "APP_FULL_NAME=%APP_FULL_NAME:|=^|%"
echo    %APP_FULL_NAME% >>properties.build
SET "APP_FULL_NAME=%APP_FULL_NAME:^|=|%"
echo    Copyright (C) %COPYRIGHT_YEAR% %COMPANY_NAME% >>properties.build
echo. >>properties.build
echo    This program is free software: you can redistribute it and/or modify >>properties.build
echo    it under the terms of the GNU General Public License as published by >>properties.build
echo    the Free Software Foundation, either version 3 of the License, or >>properties.build
echo    (at your option) any later version. >>properties.build
echo. >>properties.build
echo    This program is distributed in the hope that it will be useful, >>properties.build
echo    but WITHOUT ANY WARRANTY; without even the implied warranty of >>properties.build
echo    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the >>properties.build
echo    GNU General Public License for more details. >>properties.build
echo. >>properties.build
echo    You should have received a copy of the GNU General Public License >>properties.build
echo    along with this program. If not, see http://www.gnu.org/licenses >>properties.build
echo --^> >>properties.build
echo ^<project name="My project environment build properties" default=""^> >>properties.build
echo   ^<property name="jdk.dir" value="%JDKHOME%" /^> >>properties.build
echo   ^<property name="install.dir" value="%INSTALLDIR%" /^> >>properties.build
echo   ^<property name="buildid" value="%BUILDID%" /^> >>properties.build
echo ^</project^> >>properties.build
goto make

:EditParameter
if %SET_APP_NAME%==off goto writeAppFullName
"%NANTHOME%\bin\nant.exe" -D:input.name=app.name -D:input.value="%APP_NAME%" -D:property.file=%CD%/project.build -buildfile:%TOOLS_PATH%/configure.build.xml property.import > detail.log

:writeAppFullName
if %SET_APP_FULL_NAME%==off goto writeVersion
"%NANTHOME%\bin\nant.exe" -D:input.name=app.full.name -D:input.value="%APP_FULL_NAME%" -D:property.file=%CD%/project.build -buildfile:%TOOLS_PATH%/configure.build.xml property.import > detail.log

:writeVersion
if %SET_VERSION%==off goto writeRelease
"%NANTHOME%\bin\nant.exe" -D:input.name=version -D:input.value="%VERSION%" -D:property.file=%CD%/version.build -buildfile:%TOOLS_PATH%/configure.build.xml property.import > detail.log

:writeRelease
if %SET_RELEASE%==off goto writeInstallDir
"%NANTHOME%\bin\nant.exe" -D:input.name=release -D:input.value="%RELEASE%" -D:property.file=%CD%/version.build -buildfile:%TOOLS_PATH%/configure.build.xml property.import > detail.log

:writeInstallDir
if %SET_INSTALLDIR%==off goto writeJDKHome
"%NANTHOME%\bin\nant.exe" -D:input.name=install.dir -D:input.value="%INSTALLDIR%" -D:property.file=%CD%/properties.build -buildfile:%TOOLS_PATH%/configure.build.xml property.import > detail.log

:writeJDKHome
if %SET_JDKHOME%==off goto writeBuildID
"%NANTHOME%\bin\nant.exe" -D:input.name=jdk.dir -D:input.value="%JDKHOME%" -D:property.file=%CD%/properties.build -buildfile:%TOOLS_PATH%/configure.build.xml property.import > detail.log

:writeBuildID
if %SET_BUILDID%==off goto deleteLogfile
"%NANTHOME%\bin\nant.exe" -D:input.name=buildid -D:input.value="%BUILDID%" -D:property.file=%CD%/properties.build -buildfile:%TOOLS_PATH%/configure.build.xml property.import > detail.log

:deleteLogfile
if not exist detail.log goto end
del detail.log>nul
goto end


:: *********************************************************
:: *  Display ERROR message
:: *********************************************************
:error
echo.
echo Invalid option(s) used with configure.bat
echo.

:: *********************************************************
:: *  Display HELP message
:: *********************************************************
:help
echo.
echo Possible parameters value for the configure script are:

echo.
echo configure              - Creates the build.properties file with default values for all possible parameters.
echo                          It can work only if there is a default "JAVA_HOME" registered with the system.
echo configure -help        - Displays the Help Information.
echo configure -buildid     - Sets the buildid for the project.
echo configure -appname     - Sets the short application name for the project.
echo configure -appfullname - Sets the full application name for the project.
echo configure -version     - Sets the version number for the project.
echo configure -release     - Sets the release number for the project.
echo configure -instdir     - Sets the location of the installation directory used when executing the make script
echo                          with the install target specified.
echo configure -jdkhome     - Sets the "JAVA_HOME" location of Java to be used to compile the project.
echo.
echo Multiple parameters can be specified at once, for example:
echo.
echo           configure [-version version_tag] [-release release_tag] [-jdkhome jdk_home]
echo           configure -version %VERSION% -release %RELEASE% -jdkhome C:/jdk_home
echo.
goto end

:errorfilenotefound
echo.
echo "%NANTHOME%\bin\nant.exe" not found.
echo.
goto end

:: *********************************************************
:: *  Set VERSION parameter value
:: *********************************************************
:version
if %SET_VERSION%==on goto error
shift
if "X%~1"=="X" goto error
SET VERSION=%~1
SET SET_VERSION=on
shift
if "X%~1"=="X" goto make
goto start


:: *********************************************************
:: *  Set RELEASE parameter value
:: *********************************************************
:release
if %SET_RELEASE%==on goto error
shift
if "X%~1"=="X" goto error
SET RELEASE=%~1
SET SET_RELEASE=on
shift
if "X%~1"=="X" goto make
goto start

:: *********************************************************
:: *  Set INSTDIR parameter value
:: *********************************************************
:instdir
if %SET_INSTALLDIR%==on goto error
shift
if "X%~1"=="X" goto error
SET INSTALLDIR=%~f1
SET SET_INSTALLDIR=on
shift
if "X%~1"=="X" goto make
goto start

:: *********************************************************
:: *  Set JDKHOME parameter value
:: *********************************************************
:jdkhome
if %SET_JDKHOME%==on goto error
shift
if "X%~1"=="X" goto error
SET JDKHOME=%~f1
SET SET_JDKHOME=on
shift
if "X%~1"=="X" goto make
goto start

:: *********************************************************
:: *  Set BUILDID parameter value
:: *********************************************************
:buildid
if %SET_BUILDID%==on goto error
shift
if "X%~1"=="X" goto error
SET BUILDID=%~1
SET SET_BUILDID=on
shift
if "X%~1"=="X" goto make
goto start

rem *********************************************************
rem *  Set APP_NAME parameter value
rem *********************************************************
:appname
if %SET_APP_NAME%==on goto error
shift
if "X%~1"=="X" goto error
SET "APP_NAME=%~1"
SET SET_APP_NAME=on
shift
if "X%~1"=="X" goto make
goto start

rem *********************************************************
rem *  Set APP_FULL_NAME parameter value
rem *********************************************************
:appfullname
if %SET_APP_FULL_NAME%==on goto error
shift
if "X%~1"=="X" goto error
SET "APP_FULL_NAME=%~1"
SET SET_APP_FULL_NAME=on
shift
if "X%~1"=="X" goto make
goto start

:: *********************************************************
:: *  Reset evironment variables
:: *********************************************************
:end
SET NANTHOME=
SET VERSION=
SET RELEASE=
SET INSTALLDIR=
SET SET_BUILDID=
SET BUILDID=
SET PROJECT_NAME=
SET TOOLS_PATH=
SET JDKHOME=
