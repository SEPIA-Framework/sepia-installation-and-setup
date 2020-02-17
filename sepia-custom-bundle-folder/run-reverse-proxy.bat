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
echo # Starting SEPIA Reverse-Proxy, please wait ...
cd sepia-reverse-proxy
start /MIN "SEPIA-Proxy" run_no_ssl.bat
cd..
echo # DONE - you can close this window now
pause
exit