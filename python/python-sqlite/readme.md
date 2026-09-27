# Python and built in sqlite

Python comes with built-in support for SQLite via the sqlite3 module. You do not need to install any external dependencies or servers.

# Table of content

- [](#docs)
- 

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

