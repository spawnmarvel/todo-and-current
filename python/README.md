# Python quick guide


## Table of content

- [Python quick guide](#python-quick-guide)
  - [Table of content](#table-of-content)
  - [The Python Standard Library](#the-python-standard-library)
  - [Install, pip, verify and eol](#install-pip-verify-and-eol)
  - [Virtual env](#virtual-env)
  - [PEP 8 – Style Guide for Python Code](#pep-8--style-guide-for-python-code)
  - [Positional arguments or string concatenation](#positional-arguments-or-string-concatenation)
  - [Minimal boilerplate 3.14.7](#minimal-boilerplate-3147)
  - [Why pycache Needs Cleaning](#why-pycache-needs-cleaning)
  - [Cross-Platform Runtime Support](#cross-platform-runtime-support)
  - [Self-contained executable](#self-contained-executable)


## The Python Standard Library

* Try to use this most of the time
* Dependencies are risky sometimes

https://docs.python.org/3/library/index.html

## Install, pip, verify and eol


Python for windows

* https://www.python.org/downloads/windows/


Status of Python versions and EOL

* https://devguide.python.org/versions/


Lets install python-3.14.7-amd64.exe

* Check "Add python.exe to PATH":

Always check this box at the bottom before proceeding. It allows you to run python, pip, and Virtualenvs directly from PowerShell, Command Prompt, or terminal windows without manually adding environment variables later.

* Check "Use admin privileges when installing py.exe"

Checking this ensures the Python launcher (py.exe) is registered system-wide, making it easier to invoke specific Python versions across the system.

* Customize installation (yes)

If you prefer to install to a system-wide path like C:\Python314 instead of the user AppData folder

* Make folder C:\Python314 and use that.

Hit install.



Now lets check it.

```bash

# check it
python --version
Python 3.14.7

# check pip
pip
Usage:
  pip <command> [options]


# pip install a packet
pip install pika
Collecting pika
  Downloading pika-1.4.4-py3-none-any.whl.metadata (13 kB)
Downloading pika-1.4.4-py3-none-any.whl (165 kB)
Installing collected packages: pika
Successfully installed pika-1.4.4

# view what we installed
pip freeze
pika==1.4.4

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

## Positional arguments or string concatenation


```py
# Option A: Logging format string with positional argument (Recommended)
self.logger.info("Successfully loaded configuration from %s", config_file)

# Option B: String concatenation
self.logger.info("Successfully loaded configuration from " + str(config_file))
```

* Python executes str(complex_object) and creates a new string in memory before calling self.logger.debug(). If your log level is set to INFO or WARNING, the debug message is immediately discarded, meaning the memory allocation and string conversion work was wasted.

* The logging module checks the current log level first. If DEBUG is disabled, it drops the call immediately without executing str(complex_object) or allocating new string memory.


## Minimal boilerplate 3.14.7

1. Architecture & Component Blueprint
Config Layer: Reads and parses JSON settings into a strongly typed data structure with fallback defaults if the file is missing or invalid.

* ***Logging Layer***: Configures structured stream and file handlers using standard logging without external dependencies.

* ***Application Engine***: Receives the logger and config instances via dependency injection, encapsulating the main execution pipeline and error handling.

* ***Entry Point (main)***: Orchestrates component setup, executes the application, and exits cleanly with appropriate system exit codes.

GOTO .\boilerplate

## Why pycache Needs Cleaning

Python compiles source files (.py) into bytecode (.pyc) stored inside hidden __pycache__ folders to speed up module import times.

* In long-running Windows Server services, Docker builds, or PyInstaller deployments, outdated .pyc files cause:

* Stale Code Execution: Executing old cached logic despite editing source .py files.

* PyInstaller Build Artifact Errors: Bundling outdated bytecode into dist/ binaries.

* Version Control Pollution: Unwanted .pyc tracking if .gitignore is missing


1. PowerShell (Windows / Windows Server)

```ps1
# Remove all __pycache__ directories recursively
Get-ChildItem -Path . -Recurse -Directory -Filter "__pycache__" | Remove-Item -Recurse -Force

# Remove all standalone .pyc files
Get-ChildItem -Path . -Recurse -Filter "*.pyc" | Remove-Item -Force
```

2. Bash (Linux / macOS / Docker Containers)

```bash
# Find and remove all __pycache__ directories recursively
find . -type d -name "__pycache__" -exec rm -rf {} +

# Find and remove all standalone .pyc files
find . -type f -name "*.pyc" -delete
```



## Cross-Platform Runtime Support

Python boilerplate runs identically across Linux (including Docker containers running Linux/Debian/Alpine base images) and Windows (bare-metal, PowerShell, CMD, or Windows Containers).


```txt
┌─────────────────────────────────────────────────────────────────────────────┐
│                       HOST EXECUTION ENVIRONMENT                            │
│  [ Linux (Ubuntu/Debian) ]  │  [ Windows (10/11/Server) ]  │  [ Docker Container ] │
└──────────────────────────────────────┬──────────────────────────────────────┘
                                       │
                                       │ (1) Execute Python process
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│ run_main.py (v1.3)                                                          │
│  │                                                                          │
│  ├─► (2) Instantiate CustomAppLogger() ───────────────────────────────────┐ │
│  │                                                                        │ │
│  ├─► (6) Register SIGTERM handler (Linux/Docker & Windows compatibility) │ │
│  │                                                                        │ │
│  ├─► (7) Log: "Main module started <timestamp>"                           │ │
│  ├─► (8) Log: "Main PID: <PID>"                                          │ │
│  │                                                                        │ │
│  ├─► (9) Instantiate CustomApplication() ───────────────────────────────┐ │ │
│  │                                                                      │ │ │
│  ├─► (13) Call worker.run() ───────────────────────────────────────────┐ │ │ │
│  │                                                                    │ │ │ │
│  ├─► (15) Evaluate worker.valid_config & logger_wrapper.is_valid_config() │ │ │
│  │                                                                    │ │ │ │
│  └─► (16) Exit cleanly (sys.exit(0))                                  │ │ │ │
└───────────────────────────────────────────────────────────────────────┼─┼─┼─┘
                                                                        │ │ │
       ┌────────────────────────────────────────────────────────────────┘ │ │
       │                                                                  │ │
       ▼                                                                  │ │
┌───────────────────────────────────────────────────────────────────────┐ │ │
│ custom_app_logger.py (v1.8 - Singleton)                               │ │ │
│  │                                                                    │ │ │
│  ├─► (3) Read & pre-validate args via _verify_ini_file()              │ │ │
│  │       └──► Reads [logging_config.ini] (Cross-platform OS path)     │ │ │
│  │                                                                    │ │ │
│  ├─► (4) Initialize fileConfig() or basicConfig() fallback            │ │ │
│  │                                                                    │ │ │
│  └─► (5) Return shared logger instance via .get() ────────────────────┼─┼─┘
└───────────────────────────────────────────────────────────────────────┘ │ │
                                                                          │ │
       ┌──────────────────────────────────────────────────────────────────┘ │
       │                                                                    │
       ▼                                                                    │
┌─────────────────────────────────────────────────────────────────────────┐ │
│ custom_application.py (v1.3)                                            │ │
│  │                                                                      │ │
│  ├─► (10) Get logger instance via CustomAppLogger().get()              │ │
│  │                                                                      │ │
│  ├─► (11) Execute _load_config()                                        │ │
│  │       └──► Reads & parses [config.json] via Path.cwd()               │ │
│  │                                                                      │ │
│  ├─► (12) Set valid_config = True / False                               │ │
│  │                                                                      │ │
│  └─► (14) Execute run() workload loop (5 iterations) ◄──────────────────┘ │
└─────────────────────────────────────────────────────────────────────────┘
```
## Self-contained executable

To create a self-contained executable from a Python script, the most popular and easiest tool to use is PyInstaller. It bundles your Python script, the Python interpreter, and all required dependencies into a single file that can run on computers without Python installed.

GOTO .\boilerplate_selfcontained

* https://pyinstaller.org/en/stable/operating-mode.html