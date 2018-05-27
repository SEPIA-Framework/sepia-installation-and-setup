@echo off
echo "# Starting Elasticsearch, please wait ..."
cd elasticsearch\bin
start "Elasticsearch" elasticsearch.bat
cd..\..
timeout 12
echo "# Starting SEPIA Assist-Server, please wait ..."
cd sepia-assist-server
start "SEPIA-Assist" run.bat
cd..
timeout 4
echo "# Starting SEPIA Chat-Server, please wait ..."
cd sepia-websocket-server-java
start "SEPIA-Chat" run.bat
cd..
timeout 2
echo "# Starting SEPIA Teach-Server, please wait ..."
cd sepia-teach-server
start "SEPIA-Teach" run.bat
cd..
echo "# DONE - please check the individual windows for errors."
timeout 10