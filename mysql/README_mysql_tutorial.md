# MySQL Tutorial Quick Reference

https://www.mysqltutorial.org/

## Table of Contents
* [1. Load the Sample Database into MySQL Server](#1-load-the-sample-database-into-mysql-server)
* [2. Querying Data](#2-querying-data)
* [3. Managing Databases](#3-managing-databases)
* [4. Managing Tables](#4-managing-tables)
* [5. MySQL Constraints](#5-mysql-constraints)
* [6. Insert Data](#6-insert-data)
* [7. Update Data](#7-update-data)
* [8. Delete Data](#8-delete-data)
* [9. MySQL Data Types](#9-mysql-data-types)
* [10. MySQL Globalization](#10-mysql-globalization)
* [11. MySQL Import and Export](#11-mysql-import-and-export)


## 1. Load the Sample Database into MySQL Server

We use the classicmodels database as a MySQL sample database to help you work with MySQL quickly and effectively.

The classicmodels database is a retailer of scale models of classic cars. It contains typical business data, including information about customers, products, sales orders, sales order line items, and more.

EER diagram

https://www.mysqltutorial.org/getting-started-with-mysql/mysql-sample-database/


* Launch MySQL Workbench
* Click on the Administration tab (next to Schemas)
* Click Data Import/Restore
* Import from Self-Contained File: Choose this if your entire database backup is saved inside a single .sql file. Click the ... button to browse and select your file.
* Set the Target Schema (Database Name)
* New database: If you need to create a fresh container, click the New... button next to the dropdown menu, type your desired database name, and click OK.
* Note: If your .sql file contains a built-in CREATE DATABASE command, you can leave this option blank
* In the dropdown under "Select Database Objects to Import", choose Dump Structure and Data to import both the tables and their contents
* Click the Start Import button located in the bottom-right corner of the window.
* Verify your Data

![classic models](https://github.com/spawnmarvel/todo-and-current/blob/main/mysql/images/classicmodels.png)


## 2. Querying data

https://www.mysqltutorial.org/mysql-basics/mysql-select-from/

## 3. Managing databases

https://www.mysqltutorial.org/mysql-basics/selecting-a-mysql-database-using-use-statement/

## 4. Managing tables

https://www.mysqltutorial.org/mysql-basics/mysql-create-table/

## Mysql constraints

https://www.mysqltutorial.org/mysql-basics/mysql-primary-key/

## Insert data

https://www.mysqltutorial.org/mysql-basics/mysql-insert/

## Update data

https://www.mysqltutorial.org/mysql-basics/mysql-update/

## Delete data

https://www.mysqltutorial.org/mysql-basics/mysql-delete-join/

## Mysql Data types

https://www.mysqltutorial.org/mysql-basics/mysql-bit/

## Mysql Globalization

https://www.mysqltutorial.org/mysql-basics/mysql-character-set/

## Mysql import and export

https://www.mysqltutorial.org/mysql-basics/import-csv-file-mysql-table/