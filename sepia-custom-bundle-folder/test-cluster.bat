@echo off
set thispath=%~dp0
SETLOCAL EnableDelayedExpansion
IF EXIST "java\version" (
	set /p javalocal=<java\version
	echo Found local Java version: !javalocal!
	set JAVA_HOME=!thispath!java\!javalocal!
	set PATH=!JAVA_HOME!\bin;!PATH!
)
SETLOCAL DisableDelayedExpansion
cd sepia-assist-server
FOR /F "delims=|" %%I IN ('DIR "sepia-core-tools-*.jar" /B /O:D') DO SET TOOLS_JAR=%%I
echo. 
echo Checking Elasticsearch access ...
java -jar %TOOLS_JAR% connection-check httpGetJson -url=http://localhost:20724 -maxTries=3 -waitBetween=1000
set exitcode=%errorlevel%
if "%exitcode%" == "0" (
	echo OK
) else (
	echo KO
)
echo. 
echo Checking Assist API ...
java -jar %TOOLS_JAR% connection-check httpGetJson -url=http://localhost:20721/ping -maxTries=3 -waitBetween=1000 -expectKey=result -expectValue=success
set exitcode=%errorlevel%
if "%exitcode%" == "0" (
	echo OK
) else (
	echo KO
)
echo. 
echo Checking Teach API ...
java -jar %TOOLS_JAR% connection-check httpGetJson -url=http://localhost:20722/ping -maxTries=3 -waitBetween=1000 -expectKey=result -expectValue=success
set exitcode=%errorlevel%
if "%exitcode%" == "0" (
	echo OK
) else (
	echo KO
)
echo. 
echo Checking Chat Server ...
java -jar %TOOLS_JAR% connection-check httpGetJson -url=http://localhost:20723/ping -maxTries=3 -waitBetween=1000 -expectKey=result -expectValue=success
set exitcode=%errorlevel%
if "%exitcode%" == "0" (
	echo OK
) else (
	echo KO
)
SETLOCAL EnableDelayedExpansion
IF EXIST "Xtensions\TTS\marytts\bin\marytts-server.bat" (
	echo. 
	echo Checking Extension: MaryTTS Server ...
	java -jar !TOOLS_JAR! connection-check httpGetJson -url=http://localhost:59125/voices -maxTries=3 -waitBetween=1000 -expectKey=result -expectValue=success
	set exitcode=!errorlevel!
	if "!exitcode!" == "0" (
		echo OK
	) else (
		echo DEACTIVATED
	)
)
SETLOCAL DisableDelayedExpansion
echo. 
echo DONE.
echo If all looks OK you should be able to reach your SEPIA server via: %computername%.local
echo Example1: %computername%.local:20721/tools/index.html
echo Example2: %computername%.local:20721/app/index.html
echo Example3: http://localhost:20721/app/index.html (recommended for secure context)
echo.
echo For more info about secure context and microphone access in the SEPIA client see:
echo https://github.com/SEPIA-Framework/sepia-docs/wiki/SSL-for-your-Server
pause
exit