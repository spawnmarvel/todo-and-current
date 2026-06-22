REM echo off
REM Install the application as a windows service

REM Service Name
set service_name=ApplicationName.1

REM Service location
set path=%~dp0
set file=GOD.DataBridge.Connector.IO.WinService.exe

REM Path to Sc.exe tool (Service Controller)
set sc_path=%windir%\system32
set fullPath=%path%%file%

REM CREATE the service WITHOUT DEPENDANT
%sc_path%\sc.exe create "%service_name%" binPath= "%fullPath%" start= auto

:EOF
pause
exit
