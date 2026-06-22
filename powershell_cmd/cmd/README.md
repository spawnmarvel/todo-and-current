# CMD quick guide


# Commands



robocopy

```cmd

robocopy src dest /e


REM Robocopy (just file structure)
robocopy C:\tmp C:\temp2 /e /xf *


REM Robocopy (files and folders)
robocopy C:\ProgramData\BTech\B1PE\Files\Templates \\s789weVWMYMWBYBW.file.core.windows.net\B1PE-production\Files\Templates /e

REM Robocopy (files and folders, security and log file)
Robocopy "c:\Program Files (x86)\folder\folder2" "c:\Program Files (x86)\folder\folder2" /e /r:1 /w:5 /sec /secfix /timfix /log:"c:\Program Files (x86)\folder\folder2\robo_log.log" /np



```

* /e, Copies subdirectories. This option automatically includes empty directories.
* /secfix, Fixes file security on all files, even skipped ones.
* /timefix, Fixes file times on all files, even skipped ones.


https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/robocopy

Reg service / sc create

Change var service_name and file for:

* ReqWinService.bat, run as admin from foldere where config is. 

Change only var service_name for:

* UnReqWinService.bat, run as admin from foldere where config is.

```cmd
set service_name=
set file=
```