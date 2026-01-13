# MySQL quick guide

https://www.w3schools.com/MySQL/default.asp

## Linux install mysql client

```bash

sudo apt update -y

sudo apt install mysql-client

# Alternatively, install mariadb client
# Maybe since I am on 
uname -a
# Linux penguin 6.6.99-08879-gd6e365e8de4e #1 SMP PREEMPT_DYNAMIC Thu, 23 Oct 2025 06:15:52 -0700 x86_64 GNU/Linux

sudo apt install default-mysql-client

mysql --version
# mysql  Ver 15.1 Distrib 10.11.14-MariaDB, for debian-linux-gnu (x86_64) using  EditLine wrapper
```

Azure MySql flexible server

```bash

mysql -h name.mysql.database.azure.com -
u user -p

# if using cert, ref azure mysql flexible server tls enabled and forced, we need the ca cert
# You need the correct root certificate authority (CA) file to establish trust. For recent servers, the required certificate is typically DigiCertGlobalRootG2.crt.pem. 

wget --no-check-certificate https://cacerts.digicert.com/DigiCertGlobalRootG2.crt.pem
# https://learn.microsoft.com/en-us/azure/mysql/flexible-server/security-tls-how-to-connect

mysql -h name.mysql.database.azure.com -u user -p --ssl-mode=REQUIRED --ssl-ca=DigiCertGlobalRootG2.crt.pem

``` 

## DDL (data definition language)

* create
* alter
* drop
* truncate
* rename

```sql
show databases;

create database bookstore;

use bookstore;

create table books (
    book_id INT NOT NULL AUTO_INCREMENT,
    book_title VARCHAR(200) NOT NULL,
    book_genere VARCHAR(100) NOT NULL,
    book_author VARCHAR(200) NOT NULL,
    PRIMARY KEY (book_id)
);

show tables;

-- alter the name of column

alter table books rename column book_genere to book_genre;

show columns from books;

-- if we needed to remove all rows in the table but not the table
truncate table books;

-- if we want to remove the table or drop it
drop table books;

show tables;
```

In Azure Database for MySQL flexible server go to settings->databases you then see a database called bookstore that can be opened in power bi for example.

## DML (data manipulation langauge)

* insert
* update
* delete
* select

```sql

insert into books (book_title, book_genre, book_author) values ("meditations", "bio", "marcus aurelius");

insert into books (book_title, book_genre, book_author) values ("star wars", "fantasy", "george lucas");

select * from books;

```

## DCL (data control language)

```sql

show databases;

use mysql;

select user, host from mysql.user
-- imsdal %
-- azure_superuser 120.0.0.1

```


