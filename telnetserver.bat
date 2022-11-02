@echo off
regdword.exe hkcu\SOFTWARE\Justin\UnrealDVR ArduinoPort 0
set comport=%errorlevel%
if "%comport%"=="0" goto nocom
:checktcp
regdword.exe hkcu\SOFTWARE\Justin\UnrealDVR TCPPort 0
set TCPPort=%errorlevel%
if "%TCPPort%"=="0" goto notcp
:start
%SystemDrive%\delphijustin\com2tcp.exe --baud 9600 --ignore-dsr \\.\com%comport% %tcpport%
pause
goto done
:nocom
echo Choose a COM Port:
powershell -command [System.IO.Ports.SerialPort]::getportnames()|find "COM"
set /p comport=Enter serial port number: COM
reg add HKCU\Software\Justin\UnrealDVR /v ArduinoPort /t REG_DWORD /d %comport% /F
goto checktcp
:notcp
set /p TCPPort=Enter Telnet Server Port#: 
reg add HKCU\Software\Justin\UnrealDVR /v TCPPort /t REG_DWORD /d %tcpport% /F
goto start
:done
