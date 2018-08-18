@echo off
FOR /F "delims=|" %%I IN ('DIR "sepia-reverse-proxy-*.jar" /B /O:D') DO SET JAR_NAME=%%I
java -jar -Xms25m -Xmx25m %JAR_NAME% tiny -ssl=false