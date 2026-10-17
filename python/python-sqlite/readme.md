# Python and built in sqlite

Python comes with built-in support for SQLite via the sqlite3 module. You do not need to install any external dependencies or servers.

# Table of content

- [Docs](#docs)
- [Tutorial](#tutorial)
- [simple-crud-app](#simple-crud-app)
- [dbbrowser-for-sqlite](#dbbrowser-for-sqlite)
- [make-py-sqliteexe-todo](#make-py-sqliteexe-todo)

## Docs

https://docs.python.org/3/library/sqlite3.html

## Tutorial

We will now created an SQLite database using the sqlite3 module, inserted data and retrieved values from it in multiple ways.

```py
import sqlite3
con = sqlite3.connect("tutorial.db")
```

You have now created the file tutorial.db

View run_db_tutorial.py for comments on the tutorial


https://docs.python.org/3/library/sqlite3.html#tutorial


## Simple CRUD app



## DbBrowser for SQLite

Open as read can be good if you want to view, else a copy can alter the db.

You must close it before you leave it.



## Make py-sqlite.exe TODO

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

