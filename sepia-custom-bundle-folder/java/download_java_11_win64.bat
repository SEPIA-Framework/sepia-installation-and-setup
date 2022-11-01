@echo off
setlocal enabledelayedexpansion
echo.
SET thispath=%~dp0
SET javaurl="https://api.adoptium.net/v3/binary/latest/11/ga/windows/x64/jdk/hotspot/normal/eclipse?project=jdk"
echo Downloading Java OpenJDK 11. This might take a few minutes ...
echo.
echo URL: %javaurl%
echo.
IF EXIST java_tmp.zip (
	del java_tmp.zip
)
powershell.exe -command "[Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12; (new-object System.Net.WebClient).DownloadFile('%javaurl%','java_tmp.zip')"
if "%errorlevel%" == "1" (
	echo Download failed!
	goto bottom
) else (
	echo Extracting Zip file ...
	cscript //nologo unzip.vbs "%thispath%" "%thispath%java_tmp.zip"
	SET errorcode=!errorlevel!
	if "!errorcode!" == "1" (
		echo Extraction failed!
		goto bottom
	) else (
		echo Cleaning up ...
		del java_tmp.zip
		echo Done.
		FOR /d %%F IN (*.*) DO (
			set javafolder=%%F
			goto setversion
		)
		goto bottom
	)
)
:setversion
IF "%javafolder%"=="" (
	del version
) ELSE (
	echo Set Java version to: %javafolder%
	echo %javafolder%> version
)
:bottom
echo.
pause
exit