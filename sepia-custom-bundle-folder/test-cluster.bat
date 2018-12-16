@echo off
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
echo. 
echo DONE.
echo If all looks OK you should be able to reach your SEPIA server via: %computername%.local
pause
exit