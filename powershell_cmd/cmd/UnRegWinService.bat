
REM Description: Script to install the connector as a Windows Service
REM Author:      
REM Parameters:  Run the script without parameters to install and use the /u parameter to uninstall the service

echo off
REM UnInstall the application as a windows service
set service_name=ApplicationName.1
set sc_path=%windir%\system32
%sc_path%\sc.exe stop "%service_name%"
%sc_path%\sc.exe delete "%service_name%"

pause
exit
