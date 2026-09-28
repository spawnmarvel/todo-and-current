# Python quick guide


## Table of content

- [Python quick guide](#python-quick-guide)
  - [Table of content](#table-of-content)
  - [The Python Standard Library](#the-python-standard-library)
  - [Install, pip, verify and eol](#install-pip-verify-and-eol)
  - [Virtual env](#virtual-env)
  - [PEP 8 – Style Guide for Python Code](#pep-8--style-guide-for-python-code)
  - [Positional arguments or string concatenation](#positional-arguments-or-string-concatenation)
  - [Why pycache Needs Cleaning](#why-pycache-needs-cleaning)
  - [Optimize python for speed](#optimize-python-for-speed)
  - [Minimal boilerplate](#minimal-boilerplate)
  - [Cross-Platform Runtime Support boilerplate](#cross-platform-runtime-support-boilerplate)
  - [Run boilerplate example](#run-boilerplate-example)
  - [Self-contained executable py-zabbix-trapper example](#self-contained-executable-py-zabbix-trapper-example)


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

## Optimize python for speed

1. Algorithm & Data Structure Selection
* Use Sets and Dictionaries for $O(1)$ Lookups: Checking membership (item in container) in a list takes linear time $O(n)$, whereas set and dict lookups execute in constant time $O(1)$.
* Use collections.deque for FIFO Queues: Appending or popping from the left side of a standard Python list takes $O(n)$ time because all elements must shift in memory. collections.deque provides $O(1)$ operations at both ends.
* Avoid Unnecessary Allocations with Generators: Use generator expressions (x for x in data) instead of list comprehension [x for x in data] when iterating over large datasets to minimize memory footprint and avoid triggering frequent Garbage Collection (GC) pauses.
* 
2. Built-in Functions & Standard Library Optimization
* Prefer C-Builtins Over Python Loops: Standard library functions like map(), filter(), sum(), min(), max(), and itertools are implemented in native C. They execute iterations substantially faster than equivalent explicit for loops in Python.
* Local Scope Variable Cache: Accessing local variables inside functions is faster than accessing global variables because locals are stored in a fixed-size array in CPython frame objects (LOAD_FAST instruction vs LOAD_GLOBAL).
* Fast String Concatenation: Avoid repeatedly concatenating strings in loops using + (which creates a new string object each time). Accumulate string segments in a list and combine them with ''.join(string_list).
* 
3. Vectorization & External Libraries
* Vectorize Math Operations with NumPy
* Compile Critical Loops with Cython or Numba:
* Use Numba (@jit(nopython=True)) for Just-In-Time (JIT) compilation of heavy math/array functions directly to machine code at runtime.
* Use Cython or C extensions for compute-bound algorithms that cannot easily be vectorized.
* ***Offload CPU-Bound Work via multiprocessing: Python's Global Interpreter Lock (GIL) limits a single Python process to one CPU core. Use concurrent.futures.ProcessPoolExecutor or multiprocessing to run CPU-heavy tasks in parallel across all available processor cores.***
* 
4. Memory Management & Bytecode Compilation
*Prevent Bytecode Overhead in Production: Set the environment variable PYTHONDONTWRITEBYTECODE=1 during ephemeral runs, or use python -O (optimize) to strip assert statements and debug code from compiled .pyc files.
* Use __slots__ in Data Classes: When instantiating millions of small class instances, define __slots__ = ('attr1', 'attr2') to prevent the creation of __dict__ attribute lookup dictionaries for every instance, significantly reducing RAM usage and speeding up attribute access.
* Disable Garbage Collection During Critical Cycles: Temporarily disable automatic GC using gc.disable() inside time-critical loops to prevent unannounced collector pauses, then manually invoke gc.collect() after completion.
* 
5. Profiling Before Optimizing
* Never optimize without benchmarking to locate the exact bottleneck.

Deterministic Profiling: Use the standard library cProfile module to measure function execution frequency and cumulative execution time:

```ps1
python -m cProfile -s cumulative run_main.py
```
Line-by-Line Profiling: Use line_profiler to inspect CPU time spent on individual lines within specific functions.


## Minimal boilerplate 

Let's create a boilerplate for all future python code.


1. Architecture & Component Blueprint
   
Config Layer: Reads and parses JSON settings into a strongly typed data structure with fallback defaults if the file is missing or invalid.

* ***Logging Layer***: Configures structured stream and file handlers using standard logging without external dependencies.

* ***Application Engine***: Receives the logger and config instances via dependency injection, encapsulating the main execution pipeline and error handling.

* ***Entry Point (main)***: Orchestrates component setup, executes the application, and exits cleanly with appropriate system exit codes.

2. Classes and modules
   
boilerplate classes:

* Controller, AppLogger, run_main

Worker classes:

* AMQP consume or produce messages
* API get data
* Database insert or fetch data
* Read file, parse content, write file
* Zabbix trapper send data
* Add more classes as needed


GOTO .\boilerplate

## Cross-Platform Runtime Support boilerplate

Python boilerplate runs identically across Linux (including Docker containers running Linux/Debian/Alpine base images) and Windows (bare-metal, PowerShell, CMD, or Windows Containers).


```txt
┌────────────────────────┐
               │    run_main.py         │ (Entry point & SIGTERM handler)
               └───────────┬────────────┘
                           │
                           ▼
               ┌────────────────────────┐
               │  controller.Controller │ (Orchestrator & config loader)
               └─────┬────────────┬─────┘
                     │            │
                     ▼            ▼
 ┌──────────────────────┐   ┌──────────────────────────┐
 │  app_logger.py       │   │  AmqpWorker              │
 │  (AppLogger)         │   │  (AMQP operations)       │
 └──────────────────────┘   └──────────────────────────┘
```

## Run boilerplate example


Run it

```ps1
python .\run_main.py
```

The log result show the working result and all config sections are loaded.

When we code we just alter the config.json and copy the class we need or make it.

```log
2026-09-28 20:27:13,526 - 34008 - 39912 - app_logger.py - 43 -             __init__() root - INFO - *******************
2026-09-28 20:27:13,526 - 34008 - 39912 - app_logger.py - 44 -             __init__() root - INFO - Successfully loaded logging configuration from C:\giti2026\todo-and-current\python\boilerplate\logging_config.ini
2026-09-28 20:27:13,526 - 34008 - 39912 - run_main.py - 36 -             <module>() root - INFO - *******************
2026-09-28 20:27:13,526 - 34008 - 39912 - run_main.py - 37 -             <module>() root - INFO - Main module started 2026-09-28 20:27:13.526921
2026-09-28 20:27:13,527 - 34008 - 39912 - run_main.py - 38 -             <module>() root - INFO - *******************
2026-09-28 20:27:13,527 - 34008 - 39912 - run_main.py - 42 -             <module>() root - INFO - Main PID: 39912
2026-09-28 20:27:13,527 - 34008 - 39912 - controller.py - 43 -         _load_config() root - INFO - Successfully loaded application configuration from C:\giti2026\todo-and-current\python\boilerplate\config.json
2026-09-28 20:27:13,527 - 34008 - 39912 - controller.py - 133 -                  run() root - INFO - Application is running with multiple available configurations to choose from: ['app', 'amqp', 'database', 'zabbix', 'file', 'api']
2026-09-28 20:27:13,527 - 34008 - 39912 - controller.py - 99 -      database_config() root - INFO - Retrieving database configuration...
2026-09-28 20:27:13,527 - 34008 - 39912 - controller.py - 101 -      database_config() root - INFO - Database Configuration: {'$database_comments': 'The database configuration section provides settings for connecting to the database.', 'host': 'localhost', 'port': 3306, 'username': 'user', 'password': 'password', 'database_name': 'boilerplate_db', 'ca_cert': 'path/to/ca_cert.pem', 'ssl_enabled': False}
2026-09-28 20:27:13,528 - 34008 - 39912 - controller.py - 140 -                  run() root - INFO - Application loop step 1/...
2026-09-28 20:27:13,528 - 34008 - 39912 - controller.py - 140 -                  run() root - INFO - Application loop step 2/...
2026-09-28 20:27:13,528 - 34008 - 39912 - controller.py - 140 -                  run() root - INFO - Application loop step 3/...
2026-09-28 20:27:13,528 - 34008 - 39912 - controller.py - 140 -                  run() root - INFO - Application loop step 4/...
2026-09-28 20:27:13,528 - 34008 - 39912 - controller.py - 140 -                  run() root - INFO - Application loop step 5/...
2026-09-28 20:27:13,528 - 34008 - 39912 - controller.py - 140 -                  run() root - INFO - Application loop step 6/...
2026-09-28 20:27:13,528 - 34008 - 39912 - controller.py - 140 -                  run() root - INFO - Application loop step 7/...
2026-09-28 20:27:13,528 - 34008 - 39912 - controller.py - 140 -                  run() root - INFO - Application loop step 8/...
2026-09-28 20:27:13,528 - 34008 - 39912 - controller.py - 140 -                  run() root - INFO - Application loop step 9/...
2026-09-28 20:27:13,529 - 34008 - 39912 - controller.py - 140 -                  run() root - INFO - Application loop step 10/...
2026-09-28 20:27:13,529 - 34008 - 39912 - run_main.py - 64 -             <module>() root - INFO - Application finished successfully

```

## Self-contained executable py-zabbix-trapper example

To create a self-contained executable from a Python script, the most popular and easiest tool to use is PyInstaller. It bundles your Python script, the Python interpreter, and all required dependencies into a single file that can run on computers without Python installed.

* https://pyinstaller.org/en/stable/operating-mode.html

To create a self-contained executable package for Windows Server without requiring Python installed on the target machine

Windows Services manage background process lifecycles via the Service Control Manager (SCM). Standard Python CLI loops must handle SCM signaling protocols (start, stop, pause) to run cleanly without throwing Service Control Error 1053.

To achieve this:

* servicemanager Integration: Use win32serviceutil.ServiceFramework (from pywin32) so the Windows SCM can start, stop, and report status without crashing.

* Dependencies (pip install): Install pywin32 and pyinstaller before compiling.

* SCM Registration (sc.exe): Compile using PyInstaller in --onedir mode, then register run_main.exe using sc.exe create.


1. Copy the following files from the boilerplate
2. controller.py
3. app_logger.py
4. run_main.py
5. worker_zabbix_trapper.py

GOTO .\ py-zabbix-trapper, we will use this as an example

```cmd
dir

    Directory: C:\giti2026\todo-and-current\python\py-zabbix-trapper
    
Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---          27.09.2026    22:12           4326 app_logger.py
-a---          28.09.2026    20:26           2400 config.json
-a---          27.09.2026    22:12           5409 controller.py
-a---          27.09.2026    22:12            640 logging_config.ini
-a---          28.09.2026    20:23            998 readme.md
-a---          27.09.2026    22:12           2450 run_main.py
-a---          27.09.2026    22:12            443 worker_zabbix_trapper.py
```

