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
echo # Starting SEPIA Assist-Server, please wait ...
cd sepia-assist-server
start /b "SEPIA-Assist" run.bat > nul
cd..
timeout 4 > nul
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