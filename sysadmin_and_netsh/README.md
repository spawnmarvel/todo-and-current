# Sys admin

## Tools

open ssl

* https://slproweb.com/products/Win32OpenSSL.html

baretail

* https://baremetalsoft.com/baretail/

TeamViewer for Windows

* https://www.teamviewer.com/en/download/windows/

Sysinternals Networking Utilites

TCPView is a Windows program that will show you detailed listings of all TCP and UDP endpoints on your system, including the local and remote addresses and state of TCP connections.

tcpview

* https://learn.microsoft.com/en-us/sysinternals/downloads/tcpview

Active Directory Explorer (AD Explorer) is an advanced Active Directory (AD) viewer and editor.

ad explorer

* https://learn.microsoft.com/en-us/sysinternals/downloads/adexplorer

ProcDump is a command-line utility whose primary purpose is monitoring an application for CPU spikes and generating crash dumps during a spike that an administrator or developer can use to determine the cause of the spike

procdump

* https://learn.microsoft.com/en-us/sysinternals/downloads/procdump

Ever wondered which program has a particular file or directory open? Now you can find out. Process Explorer shows you information about which handles and DLLs processes have opened or loaded.

process explorer

* https://learn.microsoft.com/en-us/sysinternals/downloads/process-explorer

How many times have you walked up to a system in your office and needed to click through several diagnostic windows to remind yourself of important aspects of its configuration, such as its name, IP address, or operating system version?

bginfo

* https://learn.microsoft.com/en-us/sysinternals/downloads/bginfo


## Summary of TCP Transaction Steps

1. Connection Establishment (Three-Way Handshake):
* Client → Server: Send SYN (request to connect).
* Server → Client: Send SYN-ACK (acknowledge SYN and request).
* Client → Server: Send ACK (acknowledge SYN-ACK).

2. Data Transfer:
* Client ↔ Server: Send and acknowledge data segments.
* Server → Client: Send ACK for received segments.
* Client ↔ Server: Retransmit lost segments as needed.

3. Connection Termination (Four-Way Handshake):
* Client → Server: Send FIN (request to terminate).
* Server → Client: Send ACK (acknowledge FIN).
* Server → Client: Send FIN (request to terminate).
* Client → Server: Send ACK (acknowledge FIN).

This flow ensures reliable communication in TCP transactions.


## Network advanced tutorial and checklist

Test-NetConnection and tnc

Yes, your statement is correct.

When using Test-NetConnection in PowerShell to check a remote connection to a specific port, the command will return True (indicating success) only if both of the following conditions are met:

1. The port is open (not blocked by a firewall, router, or security rule).
2. An application/service is actively listening on that port on the target machine.

If the port is open but no application is listening, the connection will fail (return False), as the remote system does not respond to the connection attempt.


netstat is a command-line utility used to display network connections, routing tables, and listening ports on a computer. It shows details like the protocol, local and foreign addresses, and status of each connection. This helps diagnose network problems by identifying active connections, open ports, and listening services. netstat is available on various operating systems (e.g., Linux, macOS, and Windows) and its functionality and syntax may vary slightly across platforms.

Example of Using Test-NetConnection (ps1)

```ps1

Test-NetConnection -ComputerName "remote-server" -Port 80

# Do you need more details
Test-NetConnection -ComputerName "remote-server" -Port 80 -InformationLevel Detailed

# alias
tnc remote-server -port 3389

```

Example ps1 script
```ps1
# ps1 tnc without all extra output
$ip1 = Test-NetConnection -ComputerName vm01 -Port 50050
write-host $ip1.TcpTestSucceeded
# From host
$cn = $env:COMPUTERNAME
write-host $cn

# tnc alias
tnc remote-server -port 3389
```

The Windows PowerShell cmdlet Test-NetConnection is a versatile tool for network diagnostics. It’s not directly mirrored in Linux, but its functionalities can be achieved using a combination of other commands.

```bash
# Windows: Test-NetConnection google.com

Linux: ping -c 4 google.com

# ping is the fundamental network utility to test reachability.
# c 4 sends 4 ICMP (ping) packets and then stops. Omit this for continuous pinging.

# Windows: Test-NetConnection google.com -Port 443

Linux: nc -zv google.com 443
Linux: telnet google.com 443

# nc (netcat) is a versatile tool for making network connections. 
# -z means "zero-I/O mode" (don't send any data)
# -v means "verbose". 
# It tries to connect to the specified host and port, and exits.

# telnet is another option, though often deprecated in favor of nc due to security concerns (it transmits passwords in plain text).
```

netstat (cmd, ps1, bash)

netstat is a command-line utility used to display network connections, routing tables, and listening ports on a computer. It shows details like the protocol, local and foreign addresses, and status of each connection. This helps diagnose network problems by identifying active connections, open ports, and listening services. netstat is available on various operating systems (e.g., Linux, macOS, and Windows) and its functionality and syntax may vary slightly across platforms.

Example of of using netstat check port (ps1 or cmd)

* -a shows all connections and listening ports.
* -n displays addresses and port numbers in numerical form (avoiding DNS resolution).
* -o includes the process ID associated with each connection.

netstat -ano: This command lists all active connections and listening ports, along with their associated process IDs (PIDs).

bash

```bash
netstat -ano | findstr ":1801 "

```
cmd

```bash
netstat -ano | find "1801 "

```


A healthy output for this command would typically look something like this:
```log

  TCP    0.0.0.0:1801         0.0.0.0:0              LISTENING       1234

```
Unhealthy Outputs

Meaning: This indicates that there are no active connections or listening applications on port 1801.

```log
(no output)

```
Connection refused

Meaning: If you see a connection in the TIME_WAIT state, it means that a connection was recently closed on that port, but no application is currently listening for new connections. This may indicate that the service crashed or was stopped.

```log
TCP    192.168.1.2:1801     192.168.1.3:54321      TIME_WAIT       0
```

LISTENING but Unresponsive

Meaning: While the output indicates that there is an application listening on port 1801, if you try to connect to the port and experience timeouts or connection failures, it may suggest that the application is unresponsive or malfunctioning. You can further investigate this by checking the application associated with PID 5678.

```log
TCP    0.0.0.0:1801         0.0.0.0:0              LISTENING       5678
```
Multiple Entries with Different States

Meaning: If you see multiple states such as CLOSE_WAIT, this may indicate that the application is not properly closing connections. An application in CLOSE_WAIT may have issues managing its connections, which can lead to resource exhaustion.

```log
TCP    0.0.0.0:1801         0.0.0.0:0              LISTENING       5678
TCP    192.168.1.2:1801     192.168.1.3:54321      ESTABLISHED     5678
TCP    192.168.1.2:1801     192.168.1.4:12345      CLOSE_WAIT      5678
```

Common SYN States

SYN_SENT: This state indicates that a connection request has been sent to the server, and the client is waiting for a response (SYN-ACK). It means that an application on your machine is trying to connect to a service on port 1801 but has not yet completed the connection.


SYN_RECEIVED: This state means that your machine has received a SYN request from a client and has sent back a SYN-ACK in response. The connection is still being established, and the final ACK from the client is awaited.

SYN_SENT

```log
TCP    192.168.1.2:54321     192.168.1.3:1801      SYN_SENT       0
```
Meaning: In this example, the local machine at 192.168.1.2 is trying to establish a connection from port 54321 to 192.168.1.3 on port 1801, but it has not yet completed the connection or got a response back.

SYN_RECEIVED

```log
TCP    192.168.1.3:1801      192.168.1.2:54321     SYN_RECEIVED   5678
```
Meaning: This indicates that the server at 192.168.1.3 has received a SYN request from the client at 192.168.1.2 and is waiting for the final ACK from the client to complete the connection.


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

Download wireshark 

https://www.wireshark.org/download.html

![open file](https://github.com/spawnmarvel/todo-and-current/blob/main/sysadmin_and_netsh/images/netsh.png)

Example look at port 443

tcp.port == 443

![tcp 443](https://github.com/spawnmarvel/todo-and-current/blob/main/sysadmin_and_netsh/images/443.png)

DisplayFilters

* https://wiki.wireshark.org/DisplayFilters



