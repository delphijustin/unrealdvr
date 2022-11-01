@echo off
set SelDev=B
if not exist "%windir%\system32\schtasks.exe" goto noschtasks
if exist "%programfiles%\UnrealStreaming\UArchivalServer\UArchivalServer.exe" goto founduas
if exist "%ProgramFiles(x86)%\UnrealStreaming\UArchivalServer\UArchivalServer.exe" goto founduas
echo Archival Server is not installed on this computer.
pause
goto done
:noschtasks
echo %windir%\system32\schtasks.exe does not exist.
pause
goto done
:setdate
set udvr_date=%3
goto done
:founduas
if "%1"=="/?" goto help
if "%1"=="/date" goto setdate
if "%1"=="/stop" goto stop
if not "%1"=="" goto record
regdword.exe hkcu\SOFTWARE\Justin\UnrealDVR ArduinoPort 0
set ArduinoPort=COM%errorlevel%
if not "%ArduinoPort%"=="COM0" goto prompt
regdword.exe hkcu\SOFTWARE\Justin\UnrealDVR Configured 0
if errorlevel 1 goto prompt
echo Do you want the to be able to change channels?
choice /C YNC /M "Press Y for yes, N for no or C for cancel"
set config_choice=%errorlevel%
if "%config_choice%"=="3" goto done
md %systemdrive%\delphijustin
md %systemdrive%\delphijustin\DVRTasks
cls
copy /Y %0 %systemdrive%\delphijustin
::copy /Y comsend.exe %systemdrive%\delphijustin
copy /Y remote.vbs %systemdrive%\delphijustin
::comsend stopped working so remote.vbs was borned
copy /Y regdword.exe %systemdrive%\delphijustin
copy /Y timewait.exe %systemdrive%\delphijustin
if "%config_choice%"=="2" goto prompt
:setcomport
powershell -command [System.IO.Ports.SerialPort]::getportnames()|find "COM"
set /p comport=Enter serial port number: COM
reg add HKCU\Software\Justin\UnrealDVR /v ArduinoPort /t REG_DWORD /d %comport% /F
pause
:prompt
reg add HKCU\Software\Justin\UnrealDVR /v Configured /t REG_DWORD /d 1 /F
cls
echo Serial Port is %ArduinoPort%
echo Selected devicee is %SelDev%
echo.
echo What would you like to do?
echo Z. Change Device Letter
echo P. Change COM Port
echo C. Change Channel
echo S. Stop recording
echo A. Add a new scheduled recording
echo D. Delete a scheduled recording
echo R. Start recording
echo X. Exit
choice /C ZPCSADRX /M "Pick a letter"
if errorlevel 8 goto done
if errorlevel 7 goto manualrec
if errorlevel 6 goto delete
if errorlevel 5 goto newtask
if errorlevel 4 goto userstop
if errorlevel 3 goto callch
if errorlevel 2 goto setcomport
if errorlevel 1 goto setdev
pause
goto prompt
:setdev
echo Choose a device letter, or press C to cancel
echo A should be for DVD players,etc
echo B should be used for TV Shows as it is the default device
choice /C ABC /M "Pick a letter"
if errorlevel 3 goto prompt
if errorlevel 2 set SelDev=B
if errorlevel 1 set SelDev=A
:userstop
net stop uarchivalserver
pause
goto prompt
:newtask
set taskid=%random%
if exist %SystemDrive%\delphijustin\DVRTasks\%taskid%.txt goto newtask
if "%passwd%"=="" set /p passwd=Enter password for %USERDOMAIN%\%USERNAME%:
cls
set /p taskDesc=Enter a name for this recording:
if "%ArcPath%"=="" set /p ArcPath=Enter the full path where archival server stores videos(no ending backslash and no spaces):
if not "%moveto%"=="" goto skipmoveto
set /p moveto=Enter the path where the video will be moved to(no ending backslash allowed and no spaces):
:skipmoveto
set schtasks_params=/create /RU %USERDOMAIN%\%USERNAME% /RP %passwd% /TN "delphijustin\UDVR%taskid%"
echo Select a type of mode for this recording
echo O: one time
echo E: everyday
echo W: weekly
echo C: Cancel
choice /C OEWC /M "Pick a letter"
if errorlevel 4 goto prompt
if errorlevel 3 goto weekly
if errorlevel 2 goto everyday
if errorlevel 1 goto onetime
echo Unknown choice
pause
goto prompt
:onetime
set schtasks_params=%schtasks_params% /SC ONCE
goto tasktime
:everyday
set schtasks_params=%schtasks_params% /SC DAILY
goto tasktime
:weekly
set schtasks_params=%schtasks_params% /SC WEEKLY /D
echo Choose a day of the week:
echo M. MON
echo T. TUE
echo W. WED
echo H. THU
echo F. FRI
echo S. SAT
echo U. SUN
echo X. Cancel
choice /C MTWHFSUX /M "Pick a letter"
set dayindex=%errorlevel%
if "%dayindex%"=="8" goto prompt
if "%dayindex%"=="7" set schtasks_params=%schtasks_params% SUN
if "%dayindex%"=="6" set schtasks_params=%schtasks_params% SAT
if "%dayindex%"=="5" set schtasks_params=%schtasks_params% FRI
if "%dayindex%"=="4" set schtasks_params=%schtasks_params% THU
if "%dayindex%"=="3" set schtasks_params=%schtasks_params% WED
if "%dayindex%"=="2" set schtasks_params=%schtasks_params% TUE
if "%dayindex%"=="1" set schtasks_params=%schtasks_params% MON
:tasktime
call %0 /date %date%
set taskdate=%udvr_date%
echo Default Date: %udvr_date%
set /p taskdate=Enter start date:
echo AM Hours in 24-hour format: 12=00 01=01 02=02 03=03 04=04 05=05 06=06 07=07 08=08 09=09 10=10 11=11
echo PM Hours in 24-hour format: 12=12 01=13 02=14 03=15 04=16 05=17 06=18 07=19 08=20 09=21 10=22 11=23
set /p starttime=Enter start time(in 24-hour format,no date):
set schtasks_params=%schtasks_params% /ST %starttime% /SD %taskdate%
set /p Endtime=Enter the time when the recording should stop(in 24-hour format, no date):
set TaskCh=/noch
set /p TaskCh=Enter Channel number(just press enter for no channel):
choice /C YN /M "Create task"
if errorlevel 2 goto prompt
schtasks %schtasks_params% /TR "%SYSTEMDRIVE%\delphijustin\udvr.bat %TaskCh% %endtime% %ArcPath% %moveto%\%TaskDesc%"
if errorlevel 1 goto taskfailed
echo ID UDVR%TaskID% - %taskDesc% - Channel %taskch% - Start: %Taskdate% %starttime% End: %endtime%>%SystemDrive%\delphijustin\DVRTasks\%TaskID%.txt
:taskfailed
pause
goto prompt
:delete
for %%t in (%systemdrive%\delphijustin\DVRTasks\*.txt) do type %%t
set /p taskid=Task ID: UDVR
choice /C YN /M "Are you sure you want to delete"
if errorlevel 2 goto prompt
SCHTASKS /DELETE /TN "delphijustin\UDVR%taskid%" /f
del %Systemdrive%\delphijustin\dvrtasks\%TaskID%.txt
pause
goto prompt
:callch
set /p channel=Enter Channel number:
%systemdrive%\delphijustin\remote.vbs /COMPort:%ArduinoPort% /C:%channel% /dev:%SelDev% /sw:1
goto prompt
:stop
net stop uarchivalserver
goto done
:help
echo Usage: %0 [/man] [/noch] [/stop] channel [endtime archival_storage_path move_to]
echo Parameters:
echo /man		Start manualy recording. endtime is the duration. Also /noch and channel parameters cannot be used with this option.
echo /noch		Don't attempt to change channel.
echo /stop		Stops archival server.
echo channel		TV Channel
echo endtime		The time the show ends: example 05:00pm(no spaces allowed in the 12-hour format)
echo archival_storage	Where archival server stores it's videos.
echo move_to		First part of the filename and path
echo.
echo example: %0 660 5:00pm C:\archival C:\myshows\simpsons
echo NOTE That simpsons is the first part of the filename.
goto done
:manualrec
if "%ArcPath%"=="" set /p ArcPath=Enter the full path where archival server stores videos(no ending backslash and spaces):
set /p savepath=Enter path to folder to save video(without ending backslash and no spaces): 
set /p duration=Enter duration(example 1 hour 23 minutes 01:23): 
call %0 /man %duration% %ArcPath% %savepath%\Recording
pause
goto prompt
:record
%systemdrive%\delphijustin\regdword hkcu\SOFTWARE\Justin\UnrealDVR ArduinoPort 0
set ArduinoPort=COM%errorlevel%
if "%2"=="" goto justChangeChannel
title Recording in progress...
net start uarchivalserver
if "%1"=="/noch" goto skipch
if "%1"=="/man" goto skipch
if not "%ArduinoPort%"=="COM0" %systemdrive%\delphijustin\remote.vbs /COMPort:%ArduinoPort% /sw:7 /dev:%SelDev% /C:%1
:skipch
if "%1"=="/man" %systemdrive%\delphijustin\timewait.exe 00:00 %2
if not "%1"=="/man" %systemdrive%\delphijustin\timewait.exe %2
net stop uarchivalserver
for /R %3 %%v in (*.mp4) do move "%%v" "%4-%random%-%random%-%random%-%random%.mp4"
%systemdrive%\delphijustin\timewait.exe 00:00:00 00:00:15>nul
title %comspec%
goto done
:justChangeChannel
echo Changing channel to %1 on %ArduinoPort%...
start /w %systemdrive%\delphijustin\remote.vbs /COMPort:%ArduinoPort% /sw:1 /dev:%SelDev% /C:%1
echo Finished.
:done