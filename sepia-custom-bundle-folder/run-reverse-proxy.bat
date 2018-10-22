@echo off
echo # Starting SEPIA Reverse-Proxy, please wait ...
cd sepia-reverse-proxy
start /MIN "SEPIA-Proxy" run_no_ssl.bat
cd..
echo # DONE - you can close this window now
pause
exit