#  Python zabbix trapper

## Table of content

- [Python zabbix trapper](#python-zabbix-trapper)
  - [Table of content](#table-of-content)
  - [Native Binary Shipping](#native-binary-shipping)
  - [Input file examples for windows](#input-file-examples-for-windows)


## Native Binary Shipping

Shipping the official zabbix_sender.exe binary alongside your code is a standard, highly reliable strategy for Windows deployments.

Instead of relying on Python-based Zabbix API/trapper client libraries from pip (which require additional dependencies and maintaining socket protocols in Python), your application uses Python's standard subprocess module to invoke zabbix_sender.exe directly.

## Input file examples for windows

Now lets make some code for reading the file and for sending to Zabbix.


1. Read a txt file from a location that something (external) else updates:

External can be:

* Powershell
* cmd
* bash (just as example)

```bash
echo "host1; mykey; 12;" > send2zabbix.txt
```

* Sql save file
* Task scheduler
* SQLPlus (save to file)
* Other

