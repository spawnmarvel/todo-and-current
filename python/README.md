# Python quikc guide

## Version, pip and pip install

```bash

python --version
# Python 3.13.2

pip freeze
# et_xmlfile==2.0.0
# numpy==2.3.5
# openpyxl==3.1.5

pip freeze >> requirements.txt

```

Offline pip is also possible:
* Download with pip install what you need on a vm that has internet acces
* Then move it to remote vm

## Virtual env


1. Create your project folder: mkdir my-new-project
2. Enter the folder: cd my-new-project
3. Create the venv inside: python -m venv .venv
4. Activate it: (See the OS-specific commands from before)

* python: Runs the Python interpreter.
* -m venv: Tells Python to run the virtual environment module.
* .venv: This is the name of the folder that will be created. You can name it anything, but .venv is the standard convention.

Activate the Environment

Operating System,Command
* Windows (Command Prompt),   .venv\Scripts\activate
* Windows (PowerShell),       .\.venv\Scripts\Activate.ps1
* macOS / Linux,source        .venv/bin/activate



Example

```bash
mkdir my-new-projec

cd .\my-new-projec\

python -m venv .venv

ls

# Directory: C:\Users\jekl\my-new-projec
# Mode                 LastWriteTime         Length Name
# ----                 -------------         ------ ----
# d----          05.01.2026    14:07                .venv

 .\.venv\Scripts\activate
(.venv) PS C:\Users\jekl\my-new-projec>

pip install pika

pip freeze
# pika==1.3.2

```
Make a script to test

```py
import pika
print("Success")
```

Run it

```bash
python .\run_pika.py
Success
```

Deactivate env/ stop

```bash
deactivate
```

