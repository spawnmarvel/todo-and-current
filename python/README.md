# Python quick guide


## Table of content

- [Python quick guide](#python-quick-guide)
  - [Table of content](#table-of-content)
  - [The Python Standard Library](#the-python-standard-library)
  - [Version, pip and eol](#version-pip-and-eol)
  - [Virtual env](#virtual-env)
  - [PEP 8 – Style Guide for Python Code](#pep-8--style-guide-for-python-code)
  - [Logging](#logging)
  - [Minimal boilerplate](#minimal-boilerplate)
  - [Self-contained executable](#self-contained-executable)


## The Python Standard Library

* Try to use this most of the time
* Dependencies are risky sometimes

https://docs.python.org/3/library/index.html

## Version, pip and eol


Python for windows

* https://www.python.org/downloads/windows/

Status of Python versions and EOL

* https://devguide.python.org/versions/

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

## PEP 8 – Style Guide for Python Code

| Category  | Naming Convention  | Examples                          |
| --------- | ------------------ | --------------------------------- |
| Vars      | `snake_case`       | `user_id`, `total_cost`           |
| Functions | `snake_case`       | `calculate_total()`, `get_data()` |
| Methods   | `snake_case`       | `user.get_profile()`              |
| Classes   | `PascalCase`       | `UserProfile`, `ShoppingCart`     |
| Constants | `UPPER_SNAKE_CASE` | `MAX_LIMIT`, `PI`                 |
| Modules   | `snake_case`       | `file_parser.py`, `utils.py`      |
| Packages  | `flatcase`         | `requests`, `urlparse`            |


* https://peps.python.org/pep-0008/

## Logging

## Minimal boilerplate

1. Architecture & Component Blueprint
Config Layer: Reads and parses JSON settings into a strongly typed data structure with fallback defaults if the file is missing or invalid.

* Logging Layer: Configures structured stream and file handlers using standard logging without external dependencies.

* Application Engine: Receives the logger and config instances via dependency injection, encapsulating the main execution pipeline and error handling.

* Entry Point (main): Orchestrates component setup, executes the application, and exits cleanly with appropriate system exit codes.

## Self-contained executable

To create a self-contained executable from a Python script, the most popular and easiest tool to use is PyInstaller. It bundles your Python script, the Python interpreter, and all required dependencies into a single file that can run on computers without Python installed.


* https://pyinstaller.org/en/stable/operating-mode.html