# CMD quick guide


# Commands



## robocopy

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

Some other examples

```cmd
REM copy all .docx
robocopy c:\Users\lima\Downloads c:\Users\lima\Desktop\temporary_docs "*.docx"

REM remove a file (if you got more then you needed) if you are in folder
del PLA-0003661835.docx
```


https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/robocopy

### Reg service / sc create


```cmd
sc create "MyService" binPath= "C:\path\to\your\executable.exe"

sc delete "MyService"
```