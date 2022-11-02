# unrealdvr
DVR for unreal media server
This app allows you to record shows while streaming them.

It uses archival server to record them.

It does the following steps when it is suppose to record:
* Starts archival server.
* changes the channel by arduino(if enabled)
* waits for ending time to pass
* stops archival server
* Searches for any new recordings and moves them.

Features
* Record with a date and a time(not just a time)
* Stream and record at the same time.
* (Optional) Be able to change the channel via Arduino and IR LED

For installing please follow those steps in the correct order:
* Install Unreal media,live and archival servers
* Open "patch-uas.bat" file.
* Add one live stream and set start and end time from 00:00 to 23:59
* Set file duration to 1440 minutes under the storage settings
* Open udvr.bat
* If you plan on having the computer change the channel then press Y otherwise N
* If you pressed Y then enter the COM Port used by the arduino.
* When asked to enter the full path where archival server stores videos, it will be the root folder setting under storage settings
* To add more shows open %SystemDrive%\delphijustin\udvr.bat
