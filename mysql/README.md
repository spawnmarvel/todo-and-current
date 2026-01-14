# MySQL quick guide

https://www.w3schools.com/MySQL/default.asp

## Linux install mysql client

Ubuntu 24.04.3 LTS 192.168.3.5 server connect mysql

```bash

sudo apt update -y

# On ubuntu where we have installed mysql server default since we are running zabbix and mysql on the same host
cat /etc/os-release 
# PRETTY_NAME="Ubuntu 24.04.3 LTS"

sudo apt install mysql-client -y

# since we already have installed mysql server we get all other tools also, like the client

mysql --version
# mysql  Ver 8.0.44-0ubuntu0.24.04.2 for Linux on x86_64 ((Ubuntu))

sudo mysql

Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 771
Server version: 8.0.44-0ubuntu0.24.04.2 (Ubuntu)

``` 
Chromebook install mysql-client

```bash
# On chromebook ths is a debian derived distro
cat /etc/os-release
# PRETTY_NAME="Debian GNU/Linux 12 (bookworm)"
# So here we could only install mariadb client
sudo apt install default-mysql-client

mysql --version
# mysql  Ver 15.1 Distrib 10.11.14-MariaDB, for debian-linux-gnu (x86_64) using  EditLine wrapper
```


Chromebook Azure MySql flexible server connect

```bash

mysql -h name.mysql.database.azure.com -u imsdal --password=xxxxxxxxx

Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MySQL connection id is 19
Server version: 8.0.42-azure Source distribution

``` 
Chromebook Azure MySql flexible server connect get mysql version

```sql
select version();
-- 8.0.42-azure
```

Ubuntu 24.04.3 LTS 192.168.3.5 server connect mysql none tls (already done) and tls

```bash

# lets try to connect from the ubuntu server 192.168.3.5 without ssl
mysql -h name.mysql.database.azure.com -u imsdal --password=xxxxxxxxx

# that did not work, lets add the server public ip , this is the private ip 192.168.3.5
# to network on the azure mysql flexible server
# we could set up vnet peering, but this is just for test, so lets allow the public ip.
# go to Azure Database for MySQL flexible server-> networking and add the ip and save, try again.

mysql -h name.mysql.database.azure.com -u imsdal --password=xxxxxxxxx

Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 20
Server version: 8.0.42-azure Source distribution

# lets check tls
# go to Azure Database for MySQL flexible server->server paramters, check tls version, the were already set to
# tls 1.2 and tls 1.3
# Azure Database for MySQL Flexible Server has the require_secure_transport parameter set to ON by default
# which enforces all client connections to use TLS/SSL. 
# but how could we connect with
mysql -h name.mysql.database.azure.com -u imsdal --password=xxxxxxxxx

# reason:
# It is a common point of confusion, but there is a simple reason for this: modern MySQL clients automatically attempt
# an SSL/TLS connection by default
# Why it works without the flag
# The mysql command-line tool (version 5.7 and 8.0+) uses a default setting called --ssl-mode=PREFERRED

# If you were to explicitly tell the client not to use SSL by adding --ssl-mode=DISABLED, 
# the connection would fail immediately with an error like:
mysql -h name.mysql.database.azure.com -u imsdal --ssl-mode=DISABLED --password=xxxxxxxxx

ERROR 3159 (HY000): Connections using insecure transport are prohibited while --require_secure_transport=ON.

# Should you use the CA Certificate anyway?
# While you can connect without pointing to a certificate file, you are currently using "Encryption without Verification." 
# This protects your data from being read, but it doesn't protect you 
# from a Man-in-the-Middle (MitM) attack (where someone pretends to be your database).
# You need the correct root certificate authority (CA) file to establish trust. 
# For recent servers, the required certificate is typically DigiCertGlobalRootG2.crt.pem. 

wget --no-check-certificate https://cacerts.digicert.com/DigiCertGlobalRootG2.crt.pem
# https://learn.microsoft.com/en-us/azure/mysql/flexible-server/security-tls-how-to-connect

mysql -h name.mysql.database.azure.com -u user -p --ssl-mode=REQUIRED --ssl-ca=DigiCertGlobalRootG2.crt.pem --password=xxxxxxxxx

WARNING: no verification of server certificate will be done. Use --ssl-mode=VERIFY_CA or VERIFY_IDENTITY.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 22
Server version: 8.0.42-azure Source distribution

# the warning, Think of REQUIRED as saying: "I want a secure tunnel, and I don't care who is on the other end."
# how to fix this
# VERIFY_CA = High (Ensures the server is an official Azure server)
# VERIFY_IDENTITY = Highest (Ensures the server is exactly name.mysql.database.azure.com)

mysql -h name.mysql.database.azure.com -u user -p --ssl-mode=VERIFY_CA --ssl-ca=DigiCertGlobalRootG2.crt.pem --password=xxxxxxxxx

Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 23
Server version: 8.0.42-azure Source distribution

mysql -h name.mysql.database.azure.com -u user -p --ssl-mode=VERIFY_IDENTITY --ssl-ca=DigiCertGlobalRootG2.crt.pem --password=xxxxxxxxx

Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 24
Server version: 8.0.42-azure Source distribution
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


