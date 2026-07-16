# https://www.mysqltutorial.org/

## MySQL Sample Database


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

