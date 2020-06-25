@echo off
set thispath=%~dp0
SETLOCAL EnableDelayedExpansion
IF EXIST "java\version" (
	set /p javalocal=<java\version
	echo Found local Java version: !javalocal!
	echo.
	set JAVA_HOME=!thispath!java\!javalocal!
	set PATH=!JAVA_HOME!\bin;!PATH!
)
SETLOCAL DisableDelayedExpansion
echo # Starting SEPIA
echo #
echo # Checking Elasticsearch access...
cd sepia-assist-server
FOR /F "delims=|" %%I IN ('DIR "sepia-core-tools-*.jar" /B /O:D') DO SET TOOLS_JAR=%%I
java -jar %TOOLS_JAR% connection-check httpGetJson -url=http://localhost:20724 -maxTries=3 -waitBetween=1000
set exitcode=%errorlevel%
cd..
if "%exitcode%" == "0" (
	echo # Elasticsearch is running.
) else (
	echo # Starting Elasticsearch, please wait ...
	cd elasticsearch\bin
	start /MIN "Elasticsearch" elasticsearch.bat
	cd..\..
	REM timeout 12
	cd sepia-assist-server
	java -jar %TOOLS_JAR% connection-check httpGetJson -url=http://localhost:20724 -maxTries=25 -waitBetween=2000
	cd..
)
echo # Checking Elasticsearch setup ...
cd sepia-assist-server
java -jar %TOOLS_JAR% connection-check httpGetJson -url=http://localhost:20724/users -maxTries=3 -waitBetween=1000
set exitcode=%errorlevel%
cd..
if "%exitcode%" == "0" (
	echo # Elasticsearch looks GOOD.
) else (
	echo # Elasticsearch is NOT yet setup ^(or not running with default settings^)^! Run setup.bat first.
	pause
	exit
)
echo # Checking extensions ...
SETLOCAL EnableDelayedExpansion
IF EXIST "sepia-assist-server\Xtensions\TTS\marytts\bin\marytts-server.bat" (
	echo # Found MaryTTS Text-To-Speech extension. 
	echo # Looking for TTS server at default address "http://localhost:59125" ...
	cd sepia-assist-server
	java -jar !TOOLS_JAR! connection-check httpGetJson -url=http://localhost:59125/voices -maxTries=3 -waitBetween=1000
	set exitcode=!errorlevel!
	if "!exitcode!" == "0" (
		echo # MaryTTS server is running.
		cd..
	) else (
		echo # Starting MaryTTS server, please wait ...
		cd Xtensions\TTS\marytts\bin
		set MARYTTS_SERVER_OPTS="-Xmx300m"
		start /MIN "MaryTTS-Server" marytts-server.bat
		cd..\..\..\..
		java -jar !TOOLS_JAR! connection-check httpGetJson -url=http://localhost:59125/voices -maxTries=30 -waitBetween=2000
		set exitcode=!errorlevel!
		if "!exitcode!" == "0" (
			echo # MaryTTS server looks GOOD.
		) else (
			echo # MaryTTS server did NOT respond, ignoring it for now.
			echo # Plz check "sepia-assist-server\Xtensions\TTS\marytts" for more info.
		)
		cd..
	)
)
SETLOCAL DisableDelayedExpansion
timeout 2 > nul
echo # Starting SEPIA Assist-Server, please wait ...
cd sepia-assist-server
start /b "SEPIA-Assist" run.bat > nul
timeout 3 > nul
java -jar %TOOLS_JAR% connection-check httpGetJson -url=http://localhost:20721/ping -maxTries=10 -waitBetween=2500 -expectKey=result -expectValue=success
cd..
echo # Starting SEPIA Chat-Server, please wait ...
cd sepia-websocket-server-java
start /b "SEPIA-Chat" run.bat > nul
cd..
timeout 2 > nul
echo # Starting SEPIA Teach-Server, please wait ...
cd sepia-teach-server
start /b "SEPIA-Teach" run.bat > nul
cd..
echo #
echo # DONE - please check the individual log-files for errors (sepia-*/log.out).
echo # NOTE: Closing this window will shutdown the SEPIA servers."
echo #
echo # Testing connections (keep this window open if everything is OK) ...
call "test-cluster.bat"
