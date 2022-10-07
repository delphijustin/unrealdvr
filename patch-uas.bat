net stop uarchivalserver
reg add HKLM\SYSTEM\CurrentControlSet\Services\UArchivalServer /v Start /t REG_DWORD /d 3 /f
pause