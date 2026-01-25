# Sys admin

## Tools

* open ssl, https://slproweb.com/products/Win32OpenSSL.html
* baretail, https://baremetalsoft.com/baretail/

Sysinternals Networking Utilites

TCPView is a Windows program that will show you detailed listings of all TCP and UDP endpoints on your system, including the local and remote addresses and state of TCP connections.

* tcpview, https://learn.microsoft.com/en-us/sysinternals/downloads/tcpview

Active Directory Explorer (AD Explorer) is an advanced Active Directory (AD) viewer and editor.

* ad explorer, https://learn.microsoft.com/en-us/sysinternals/downloads/adexplorer

ProcDump is a command-line utility whose primary purpose is monitoring an application for CPU spikes and generating crash dumps during a spike that an administrator or developer can use to determine the cause of the spike

* procdump, https://learn.microsoft.com/en-us/sysinternals/downloads/procdump

Ever wondered which program has a particular file or directory open? Now you can find out. Process Explorer shows you information about which handles and DLLs processes have opened or loaded.

* process explorer, https://learn.microsoft.com/en-us/sysinternals/downloads/process-explorer

How many times have you walked up to a system in your office and needed to click through several diagnostic windows to remind yourself of important aspects of its configuration, such as its name, IP address, or operating system version?

* bginfo, https://learn.microsoft.com/en-us/sysinternals/downloads/bginfo


## Capture packets and analyze general

Network shell (netsh)

* https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/netsh

netsh trace

* https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/netsh-trace

```ps1
netsh trace start capture=yes report=disabled tracefile=c:\trace.etl

# Trace configuration:
# -------------------------------------------------------------------
# Status:             Running
# Trace File:         c:\trace.etl
# Append:             Off
# Circular:           On
# Max Size:           512 MB
# Report:             Disabled

# Reproduce the network issue or desired connection to generate TCP traffic

netsh trace stop

# then you have a file
c:\trace.etl
```

How to view it, download etl2pcapng.exe at https://github.com/microsoft/etl2pcapng/releases

The tool etl2pcapng.exe is a popular open-source utility (often used in Windows networking diagnostics) to make packet captures readable in standard protocol analyzers.

Lets move the files to c:\network-analysis

```ps1
cd C:\network-analysis\
dir
# -a---          25.01.2026    11:38         163872 etl2pcapng.exe
# -a---          25.01.2026    11:35        8912896 trace.etl
```

Then we need to convert the file to a wireshark file

```ps1
etl2pcapng.exe trace.etl trace.pcapng

```

Now open it in wireshark.











