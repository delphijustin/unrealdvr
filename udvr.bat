@echo off
set errorfailed=2147483647
set udvrver=2.0
set server=1
set SelDev=B
if not exist "%windir%\system32\schtasks.exe" goto noschtasks
if exist "%programfiles%\UnrealStreaming\UArchivalServer\UArchivalServer.exe" goto founduas
if exist "%ProgramFiles(x86)%\UnrealStreaming\UArchivalServer\UArchivalServer.exe" goto founduas
echo Archival Server is not installed on this computer.
pause
goto done
:donate
echo (P)ayPal
echo (C)ashApp
echo Go (B)ack
choice /C PCB /M "Pick a letter"
if errorlevel 3 goto prompt
if errorlevel 2 start https://www.paypal.com/paypalme/delphijustin/
if errorlevel 1 start https://cash.app/delphijustin/
goto prompt
:noschtasks
echo %windir%\system32\schtasks.exe does not exist.
pause
goto done
:setdate
set udvr_date=%3
goto done
:upxml
%udvrdir%\tvlist.exe 0 %udvrdir%\tvguide.xml
%udvrdir%\tvlist.exe /js
goto done
:founduas
set udvrdir=.
if not exist %systemdrive%\delphijustin\udvr.%udvrver%.ver.txt goto install
set udvrdir=%systemdrive%\delphijustin
if "%1"=="/?" goto help
if "%1"=="/web" goto webremote
if "%1"=="/date" goto setdate
if "%1"=="/stop" goto stop
if "%1"=="/upxml" goto upxml
if not "%1"=="" goto record
%udvrdir%\regdword.exe hkcu\SOFTWARE\Justin\UnrealDVR ArduinoPort 0
set ArduinoPort=COM%errorlevel%
if not "%ArduinoPort%"=="COM0" goto prompt
:install
echo Do you want the to be able to change channels?
choice /C YNC /M "Press Y for yes, N for no or C for cancel"
set config_choice=%errorlevel%
if "%config_choice%"=="3" goto done
set udvrdir=%systemdrive%\delphijustin
md %udvrdir%
md %udvrdir%\DVRTasks
cls
copy /Y %0 %udvrdir%
copy /Y udvr.ico %udvrdir%
copy /Y remote.vbs %udvrdir%
copy /Y regdword.exe %udvrdir%
copy /Y com2tcp.exe %udvrdir%
copy /Y tvlist.exe %udvrdir%
copy /Y systtime.bat %udvrdir%
copy /Y telnetserver.bat %udvrdir%
copy /Y timewait.exe %udvrdir%
copy /Y sortmp4.exe %udvrdir%
copy /B ffmpeg.exe1.split+ffmpeg.exe2.split+ffmpeg.exe3.split+ffmpeg.exe4.split+ffmpeg.exe5.split+ffmpeg.exe6.split ffmpeg.exe
echo Set objShell = WScript.CreateObject("WScript.Shell")>%tmp%\udvrsetup.vbs
echo Set lnk = objShell.CreateShortcut("%appdata%\Microsoft\Windows\Start Menu\Programs\Unreal DVR.lnk")>>%tmp%\udvrsetup.vbs
echo lnk.TargetPath = "%udvrdir%\udvr.bat">>%tmp%\udvrsetup.vbs
echo lnk.Arguments = "">>%tmp%\udvrsetup.vbs
echo lnk.Description = "Configure the Unreal DVR">>%tmp%\udvrsetup.vbs
echo lnk.IconLocation = "%udvrdir%\udvr.ico">>%tmp%\udvrsetup.vbs
echo lnk.WindowStyle = "1">>%tmp%\udvrsetup.vbs
echo lnk.WorkingDirectory = "%udvrdir%">>%tmp%\udvrsetup.vbs
echo lnk.Save>>%tmp%\udvrsetup.vbs
echo Set lnk = Nothing>>%tmp%\udvrsetup.vbs
cscript %tmp%\udvrsetup.vbs
del %tmp%\udvrsetup.vbs
echo @echo off>%udvrdir%\udvrdele.bat
echo set /p dummy=Your about to uninstall Unreal DVR, to do so press enter...>>%udvrdir%\udvrdele.bat
echo del %udvrdir%\udvr.bat>>%udvrdir%\udvrdele.bat
echo del %udvrdir%\lastremo.bat>>%udvrdir%\udvrdele.bat
echo del %udvrdir%\tvguide.xml>>%udvrdir%\udvrdele.bat
echo del %udvrdir%\channels.db>>%udvrdir%\udvrdele.bat
echo del %udvrdir%\tvlist.exe>>%udvrdir%\udvrdele.bat
echo del %udvrdir%\sorted.txt>>%udvrdir%\udvrdele.bat
echo del %udvrdir%\systtime.exe>>%udvrdir%\udvrdele.bat
echo del %udvrdir%\remote.vbs>>%udvrdir%\udvrdele.bat
echo del %udvrdir%\timewait.exe>>%udvrdir%\udvrdele.bat
echo del %udvrdir%\regdword.exe>>%udvrdir%\udvrdele.bat
echo del %udvrdir%\com2tcp.exe>>%udvrdir%\udvrdele.bat
echo del %udvrdir%\sortmp4.exe>>%udvrdir%\udvrdele.bat
echo del %udvrdir%\telnetserver.bat>>%udvrdir%\udvrdele.bat
echo del %udvrdir%\udvr.ico>>%udvrdir%\udvrdele.bat
echo del %udvrdir%\ffmpeg.exe>>%udvrdir%\udvrdele.bat
echo del %udvrdir%\channels.xml>>%udvrdir%\udvrdele.bat
echo del %udvrdir%\udvr.ps1>>%udvrdir%\udvrdele.bat
echo del %udvrdir%\udvr.%udvrver%.ver.txt>>%udvrdir%\udvrdele.bat
echo del %appdata%\Microsoft\Windows\Start Menu\Programs\Unreal DVR.lnk>>%udvrdir%\udvrdele.bat
echo rd /S /Q %udvrdir%\dvrtasks>>%udvrdir%\udvrdele.bat
echo schtasks.exe /Delete /TN \delphijustin\UDVR* /F>>%udvrdir%\udvrdele.bat
echo reg delete HKCU\Software\Justin\UnrealDVR /f>>%udvrdir%\udvrdele.bat
echo reg delete HKCU\Software\software\microsoft\windows\currentversion\run /v UnrealDVRWebRemote /f>>%udvrdir%\udvrdele.bat
echo reg delete HKCU\Software\microsoft\windows\currentversion\uninstall\unrealdvr /f>>%udvrdir%\udvrdele.bat
echo pause>>%udvrdir%\udvrdele.bat
reg add hkcu\Software\Microsoft\Windows\CurrentVersion\Uninstall\UnrealDVR /v UninstallString /d "%udvrdir%\udvrdele.bat" /f
reg add hkcu\Software\Microsoft\Windows\CurrentVersion\Uninstall\UnrealDVR /v DisplayName /d "delphijustin Unreal DVR" /f
cls
echo DO NOT COPY THE *.VER.TXT FILE>%systemdrive%\delphijustin\udvr.%udvrver%.ver.txt
if "%config_choice%"=="2" goto prompt
:setcomport
powershell -command [System.IO.Ports.SerialPort]::getportnames()|find "COM"
set /p comport=Enter serial port number: COM
reg add HKCU\Software\Justin\UnrealDVR /v ArduinoPort /t REG_DWORD /d %comport% /F
set ArduinoPort=COM%comport%
pause
:prompt
set udvrdir=%systemdrive%\delphijustin
reg add HKCU\Software\Justin\UnrealDVR /v InstallDir /v "%systemdrive%\delphijustin"
cls
echo Unreal DVR v%udvrver% By Justin Roeder
echo.
echo Serial Port is %ArduinoPort%
echo Selected devicee is %SelDev%
echo.
echo What would you like to do?
echo L. View listings(requires PHP and xmltvlistings.com account)
echo W. Install/Configure Services
echo M. Donate money
echo Z. Change Device Letter
echo P. Change COM Port
echo C. Change Channel
echo S. Stop recording
echo A. Add a new scheduled recording
echo D. Delete a scheduled recording
echo R. Start recording
echo X. Exit
choice /C LWMZPCSADRX /M "Pick a letter"
if errorlevel 11 goto done
if errorlevel 10 goto manualrec
if errorlevel 9 goto delete
if errorlevel 8 goto newtask
if errorlevel 7 goto userstop
if errorlevel 6 goto callch
if errorlevel 5 goto setcomport
if errorlevel 4 goto setdev
if errorlevel 3 goto donate
if errorlevel 2 goto webinstall
if errorlevel 1 goto listing
echo choice command failed
pause
goto done
:tvlistfailed
echo TVLIST.EXE has failed! Perhaps it is not configured correctly.
pause
goto prompt
:listing
%udvrdir%\tvlist.exe /chan
set channel=%errorlevel%
if "%channel%"=="%errorfailed%" goto tvlisterror
if "%channel%"=="0" goto prompt
cls
set search=*
set /p search=TV Show Search: 
choice /M "Show only listing for the exact timr it is now" /C YN
if errorlevel 2 goto notimelisting
if errorlevel 1 %udvrdir%\tvlist.exe /search %channel% "%search%"
if errorlevel %errorfailed% goto tvlisterror
pause
goto prompt
:notimelisting
%udvrdir%\tvlist.exe /search %channel% "%search%" /-T
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
if exist %udvrdir%\DVRTasks\%taskid%.txt goto newtask
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
:retryD1
set /p taskdate=Enter start date:
%udvrdir%\systtime.exe /vd %taskdate%
if errorlevel 1 goto retryD1
:retryT1
set /p starttime=Enter start time(no date):
%udvrdir%\systtime.exe /vt %starttime%
if errorlevel 1 goto retryT1
set return=1
set time12=%starttime%
goto hour24
:webinstall 
%udvrdir%\regdword.exe hkcu\SOFTWARE\Justin\UnrealDVR ServerVersion 0 >nul
goto webConfigured%errorlevel%
:webConfigured0
if "%passwd%"=="" set /p passwd=Enter password for %USERDOMAIN%\%USERNAME%:
set time12=12:00am
echo Please choice a daily time to update tv listing
echo It should be a time that the computer will be always be on
set /p time12=Enter a time to update tv listings[%time12%]:
set return=3
goto hour24
:timereturn3
set /p M3U8Path=Enter the folder path where unreal media server stores .M3U8 File(not a URL,no ending backslash and no spaces):
reg add hkcu\SOFTWARE\Justin\UnrealDVR /v M3U8Path /t REG_SZ /d "%M3U8Path%" /F
schtasks /create /RU %USERDOMAIN%\%USERNAME% /RP %passwd% /TN "delphijustin\UDVRXML1" /SC DAILY /ST %time24% /TR "%SystemDrive%\delphijustin\udvr.bat /upxml" /F
%udvrdir%\tvlist.exe
choice /M "Download/create files now"
if "%errorlevel%"=="1" call %0 /upxml
echo Set objShell = WScript.CreateObject("WScript.Shell")>%tmp%\udvrsetup.vbs
echo Set lnk = objShell.CreateShortcut("%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\Unreal DVR WebRemote.lnk")>>%tmp%\udvrsetup.vbs
echo lnk.TargetPath = "%udvrdir%\udvr.bat">>%tmp%\udvrsetup.vbs
echo lnk.Arguments = "/web">>%tmp%\udvrsetup.vbs
echo lnk.Description = "">>%tmp%\udvrsetup.vbs
echo lnk.IconLocation = "%udvrdir%\udvr.ico">>%tmp%\udvrsetup.vbs
echo lnk.WindowStyle = "7">>%tmp%\udvrsetup.vbs
echo lnk.WorkingDirectory = "%udvrdir%">>%tmp%\udvrsetup.vbs
echo lnk.Save>>%tmp%\udvrsetup.vbs
echo Set lnk = Nothing>>%tmp%\udvrsetup.vbs
cscript %tmp%\udvrsetup.vbs
del %tmp%\udvrsetup.vbs
reg add hkcu\SOFTWARE\Justin\UnrealDVR\TVList /v configVersion /t REG_DWORD /d %server% /F
:skipWebConfig
choice /C YN /M "Start webremote service"
if errorlevel 2 goto prompt
if errorlevel 1 start %udvrdir%\udvr.bat /web
goto prompt
:webConfigured1
choice /C YN /M "Reconfigure webservices"
if errorlevel 2 goto skipWebConfig
if errorlevel 1 goto webConfigured0
:webremote
title Unreal DVR Service Window
%udvrdir%\regdword.exe hkcu\SOFTWARE\Justin\UnrealDVR ArduinoPort 0 >nul
set ArduinoPort=COM%errorlevel%
if exist %udvrdir%\lastremo.bat call %udvrdir%\lastremo.bat
if exist %udvrdir%\lastremo.bat del %udvrdir%\lastremo.bat
%udvrdir%\tvlist.exe /test
if not "%errorlevel%"=="0" echo [%DATE% %TIME%] HLS may have failed. Error code %errorlevel%
timeout /T 3 >nul
goto webremote
:timereturn1
set starttime24=%time24%
set schtasks_params=%schtasks_params% /ST %starttime24% /SD %taskdate%
:retryT2
set /p Endtime=Enter the time when the recording should stop(in 24-hour format, no date):
set return=2
set time12=%endtime%
:hour24
%udvrdir%\systtime.exe 5 %time12%
set time24=%errorlevel%:
%udvrdir%\systtime.exe 5 %time12%
if not errorlevel 10 set time24=0%time24%
%udvrdir%\systtime.exe 6 %time12%
if errorlevel 10 set time24=%time24%%errorlevel%:
%udvrdir%\systtime.exe 6 %time12%
if not errorlevel 10 set time24=%time24%0%errorlevel%:
%udvrdir%\systtime.exe 7 %time12%
if errorlevel 10 set time24=%time24%%errorlevel%
%udvrdir%\systtime.exe 7 %time12%
if not errorlevel 10 set time24=%time24%0%errorlevel%
goto timereturn%return%
:timereturn2
%udvrdir%\tvlist.exe /chan
set TaskCh=%errorlevel%
if "%Taskch%"=="%errorfailed%" goto tvlisterror
if "%TaskCh%"=="0" echo No channel will be changed
if "%TaskCh%"=="0" set TaskCh=/noch
::set /p TaskCh=Enter Channel number(just press enter for no channel):
choice /C YN /M "Create task"
if errorlevel 2 goto prompt
schtasks %schtasks_params% /TR "%udvrdir%\udvr.bat %TaskCh% %endtime24% %ArcPath% %moveto%\%TaskDesc%"
if errorlevel 1 goto taskfailed
echo ID UDVR%TaskID% - %taskDesc% - Channel %taskch% - Start: %Taskdate% %starttime% End: %endtime%>%udvrdir%\DVRTasks\%TaskID%.txt
:taskfailed
pause
goto prompt
:delete
for %%t in (%udvrdir%\DVRTasks\*.txt) do type %%t
set /p taskid=Task ID: UDVR
choice /C YN /M "Are you sure you want to delete"
if errorlevel 2 goto prompt
SCHTASKS /DELETE /TN "delphijustin\UDVR%taskid%" /f
del %udvrdir%\dvrtasks\%TaskID%.txt
pause
goto prompt
:callch
set /p channel=Enter Channel number:
cscript %udvrdir%\remote.vbs /COMPort:%ArduinoPort% /C:%channel% /dev:%SelDev% /sw:1
goto prompt
:stop
net stop uarchivalserver
goto done
:help
echo Usage: %0 [/web] [/upxml] [/man] [/noch] [/stop] channel [endtime archival_storage_path move_to]
echo Parameters:
echo /man		Start manualy recording. endtime is the duration. Also /noch and channel parameters cannot be used with this option.
echo /noch		Don't attempt to change channel.
echo /stop		Stops archival server.
echo /upxml		Updates XML Database.
echo /web		Starts Web Remote Service.
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
%udvrdir%\systtime.exe 1
set mp4name=%4-%errorlevel%
%udvrdir%\systtime.exe 2
set mp4name=%mp4name%-%errorlevel%
%udvrdir%\systtime.exe 3
set mp4name=%mp4name%-%errorlevel%
%udvrdir%\systtime.exe 4
set mp4name=%mp4name%-%errorlevel%
%udvrdir%\systtime.exe 5
set mp4name=%mp4name%-%errorlevel%
%udvrdir%\systtime.exe 6
set mp4name=%mp4name%-%errorlevel%
%udvrdir%\systtime.exe 7
set mp4name=%mp4name%-%errorlevel%
%udvrdir%\systtime.exe 8
set mp4name=%mp4name%-%errorlevel%
%udvrdir%\regdword hkcu\SOFTWARE\Justin\UnrealDVR ArduinoPort 0
set ArduinoPort=COM%errorlevel%
if "%2"=="" goto justChangeChannel
title Recording in progress...
net start uarchivalserver
if "%1"=="/noch" goto skipch
if "%1"=="/man" goto skipch
if not "%ArduinoPort%"=="COM0" goto makeps1
::cscript %udvrdir%\remote.vbs /COMPort:%ArduinoPort% /sw:7 /dev:%SelDev% /C:%1
:skipch
if "%1"=="/man" goto duration
%udvrdir%\timewait.exe %2
:durationdone
net stop uarchivalserver
type nul>%udvrdir%\sorted.txt
%udvrdir%\systtime.exe 0
set mp4file=%mp4name%-%errorlevel%
for /R %3 %%v in (*.mp4) do echo %%v>>%udvrdir%\sorted.txt
%udvrdir%\sortmp4.exe %udvrdir%\sorted.txt
if errorlevel 2 goto merge
if not errorlevel 1 goto noMP4
for /R %3 %%v in (*.mp4) do move "%%v" "%mp4file%.mp4"
:recdone
%udvrdir%\timewait.exe 00:00:00 00:00:15>nul
title %comspec%
goto done
:makeps1
echo $port = new-Object System.IO.Ports.SerialPort %ArduinoPort%,9600,None,8,one>%udvrdir%\udvr.ps1
echo $port.open()>>%udvrdir%\udvr.ps1
echo Start-Sleep -Seconds 5 >>%udvrdir%\udvr.ps1
echo $port.WriteLine('%SelDev%')>>%udvrdir%\udvr.ps1
echo Start-Sleep -Seconds 5 >>%udvrdir%\udvr.ps1
echo $port.WriteLine('%1')>>%udvrdir%\udvr.ps1
echo Start-Sleep -Seconds 10 >>%udvrdir%\udvr.ps1
echo $port.close() >>%udvrdir%\udvr.ps1
PowerShell.exe -command c:\delphijustin\udvr.ps1
goto skipch
:noMP4
echo No mp4 files found.
goto done
:merge
%udvrdir%\ffmpeg.exe -f concat -safe 0 -i %udvrdir%\sorted.txt -c copy "%mp4file%-merged.mp4"
for /R %3 %%v in (*.mp4) do del "%%v"
goto recdone
:duration
%udvrdir%\systtime.exe %2
timeout /T %errorlevel%
goto durationdone
:justChangeChannel
echo Changing channel to %1 on %ArduinoPort%...
cscript %udvrdir%\remote.vbs /COMPort:%ArduinoPort% /sw:1 /dev:%SelDev% /C:%1
echo Finished.
:done