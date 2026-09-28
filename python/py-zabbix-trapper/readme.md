#  Python zabbix trapper

## Table of content

- [Native Binary shipping](#native-binary-shipping)


## Native Binary Shipping

Shipping the official zabbix_sender.exe binary alongside your code is a standard, highly reliable strategy for Windows deployments.

Instead of relying on Python-based Zabbix API/trapper client libraries from pip (which require additional dependencies and maintaining socket protocols in Python), your application uses Python's standard subprocess module to invoke zabbix_sender.exe directly.


## Add zabbix bin to this code

The use paramters, then we do not need a lib


zabbix_sender.exe -z 192.168.1.113 -i data_values.txt

https://www.zabbix.com/documentation/4.0/en/manpages/zabbix_sender

# Read a txt file from external

External can be:

* Powershell
* cmd
* Sql save file
* Other

Output file on iteration one, delete the file on iteration 2 and save a new file with new data

We then read the file present.

## Pyinstaller