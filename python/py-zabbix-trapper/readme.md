#  Python zabbix trapper

## Table of content

- [Python zabbix trapper](#python-zabbix-trapper)
  - [Table of content](#table-of-content)
  - [Native Binary Shipping](#native-binary-shipping)
  - [Input file examples for windows](#input-file-examples-for-windows)
    - [Make py-zabbix-trapper.exe TODO](#make-py-zabbix-trapperexe-todo)
      - [1. Step-by-step PyInstaller Compilation Process](#1-step-by-step-pyinstaller-compilation-process)
        - [Install PyInstaller](#install-pyinstaller)
        - [Analyze Application \& Dependencies](#analyze-application--dependencies)


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

### Make py-zabbix-trapper.exe TODO

To create a self-contained executable from a Python script, the most popular and easiest tool to use is PyInstaller. It bundles your Python script, the Python interpreter, and all required dependencies into a single file that can run on computers without Python installed.



#### 1. Step-by-step PyInstaller Compilation Process

* Install PyInstaller: Use pip to add PyInstaller to your Python build environment.

* Analyze Application & Dependencies: PyInstaller inspects your entry script, recursive module imports, and external runtime requirements.

* Configure Build Settings: Specify packaging options such as single-file versus single-directory (--onedir), console visibility, and custom icon files using flags or a .spec file.

* Bundle Non-Code Data & Binaries: Configure PyInstaller to include required static assets, configuration files, and external compiled binaries (such as zabbix_sender.exe in bin/).

* Generate Executable Package: Compile the Python bytecode, interpreter DLLs, and bundled assets into the destination dist/ directory.

* Verify Standalone Deployment: Run the generated executable on a clean target machine without Python installed to confirm path resolution and service execution.

##### Install PyInstaller

```bash
python -m pip install --upgrade pip
Requirement already satisfied: pip in C:\Python314\Lib\site-packages (26.2.1)
python -m pip install pyinstaller pywin32

# verify it
pyinstaller --version
6.22.3
```

##### Analyze Application & Dependencies

