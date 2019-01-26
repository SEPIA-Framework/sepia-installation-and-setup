@echo off
SET NOW=%date:~6,4%_%date:~3,2%_%date:~0,2%_%time:~0,2%%time:~3,2%%time:~6,2%
FOR /F "delims=|" %%I IN ('DIR "sepia-mesh-node-*.jar" /B /O:D') DO SET JAR_NAME=%%I
REM echo Making backup of log-file
copy log.out "logs\backup_%NOW%.out" > nul
del log.out > nul
echo Running SEPIA Mesh-Node (%JAR_NAME%) - Date: %NOW% >> log.out 2>&1
java -Dfile.encoding=utf-8 -jar -Xms24m -Xmx24m %JAR_NAME% --my >> log.out 2>&1