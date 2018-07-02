@echo off
cd sepia-assist-server
FOR /F "delims=|" %%I IN ('DIR "sepia-assist-*.jar" /B /O:D') DO SET JAR_NAME=%%I
echo. 
echo Checking Elasticsearch access ...
java -jar connection-check.jar httpGetJson -url=http://localhost:20724 -maxTries=3 -waitBetween=1000
set exitcode=%errorlevel%
if "%exitcode%" == "0" (
	echo OK
) else (
	echo KO
)
echo. 
echo Checking Assist API ...
java -jar connection-check.jar httpGetJson -url=http://localhost:20721/ping -maxTries=3 -waitBetween=1000 -expectKey=result -expectValue=success
set exitcode=%errorlevel%
if "%exitcode%" == "0" (
	echo OK
) else (
	echo KO
)
echo. 
echo Checking Teach API ...
java -jar connection-check.jar httpGetJson -url=http://localhost:20722/ping -maxTries=3 -waitBetween=1000 -expectKey=result -expectValue=success
set exitcode=%errorlevel%
if "%exitcode%" == "0" (
	echo OK
) else (
	echo KO
)
echo. 
echo Checking Chat Server ...
java -jar connection-check.jar httpGetJson -url=http://localhost:20723/ping -maxTries=3 -waitBetween=1000 -expectKey=result -expectValue=success
set exitcode=%errorlevel%
if "%exitcode%" == "0" (
	echo OK
) else (
	echo KO
)
echo. 
echo DONE
pause
exit