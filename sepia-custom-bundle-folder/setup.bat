@echo off
setlocal enabledelayedexpansion
cd sepia-assist-server
FOR /F "delims=|" %%I IN ('DIR "sepia-assist-*.jar" /B /O:D') DO SET JAR_NAME=%%I
FOR /F "delims=|" %%I IN ('DIR "tools-*.jar" /B /O:D') DO SET TOOLS_JAR=%%I
echo. 
echo Welcome to the SEPIA framework!
echo. 
echo This little script will help you with the configuration of your server.
echo If you are here for the first time please take 5 minutes to read the (MIT) license agreement, especially the part about 'no-warranty' ^_^.
echo You can find the license file in your download folder, in the SEPIA app or on one of the SEPIA pages, e.g.:
echo https://github.com/SEPIA-Framework/sepia-assist-server
:enteroption
echo. 
echo What would you like to do next?
echo 1: Setup all components (except dynamic DNS)
echo 2: Define new admin and assistant passwords
echo 3: Setup dynamic DNS with DuckDNS
echo 4: Start Elasticsearch
echo. 
set /p option="Enter a number plz (0 to exit): "
echo. 
if "%option%" == "0" (
	exit
)
if "%option%" == "1" (
	echo Checking Elasticsearch access...
	java -jar %TOOLS_JAR% connection-check httpGetJson -url=http://localhost:20724 -maxTries=3 -waitBetween=1000
	set exitcode=!errorlevel!
	if "!exitcode!" == "0" (
		java -jar %JAR_NAME% setup --my
		goto bottom
	) else (
		goto noelastic
	)
)
if "%option%" == "2" (
	java -jar %JAR_NAME% setup accounts --my
	goto bottom
)
if "%option%" == "3" (
	java -jar %JAR_NAME% setup duckdns --my
	echo DONE. Please restart 'SEPIA assist server' to activate DuckDNS worker!
	goto bottom
)
if "%option%" == "4" (
	echo Starting Elasticsearch, please wait ...
	cd..
	cd elasticsearch\bin
	start /MIN "Elasticsearch" elasticsearch.bat
	cd..\..
	cd sepia-assist-server
	REM timeout 12
	java -jar %TOOLS_JAR% connection-check httpGetJson -url=http://localhost:20724 -maxTries=25 -waitBetween=2000
	goto enteroption
)
:nooption
echo Not an option, please try again.
goto enteroption
:noelastic
echo Please start Elasticsearch first (or check if access is possible).
goto enteroption
:bottom
echo Setup done.
pause
exit