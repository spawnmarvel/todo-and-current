# Example self contained windows

## Table of content
- [Example self contained windows](#example-self-contained-windows)
  - [Table of content](#table-of-content)
  - [Architecture \& Windows Service Strategy](#architecture--windows-service-strategy)
  - [Custom Application Service Wrapper (run\_main.py)](#custom-application-service-wrapper-run_mainpy)

## Architecture & Windows Service Strategy

To create a self-contained executable package for Windows Server without requiring Python installed on the target machine

Windows Services manage background process lifecycles via the Service Control Manager (SCM). Standard Python CLI loops must handle SCM signaling protocols (start, stop, pause) to run cleanly without throwing Service Control Error 1053.

To achieve this:

* servicemanager Integration: Use win32serviceutil.ServiceFramework (from pywin32) so the Windows SCM can start, stop, and report status without crashing.

* Dependencies (pip install): Install pywin32 and pyinstaller before compiling.

* SCM Registration (sc.exe): Compile using PyInstaller in --onedir mode, then register run_main.exe using sc.exe create.

## Custom Application Service Wrapper (run_main.py)

