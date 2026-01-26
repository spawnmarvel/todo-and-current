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

-- 1. The MySQL Door (The inner door)
-- The % wildcard in your mysql.user table means that from MySQL’s perspective, 
-- the user imsdal is allowed to attempt a login from any IP address in the world.

--- 2. The Azure Firewall (The outer door)
--Even if MySQL says "come on in," Azure has its own network-level firewall that sits in front of the database.

-- 3. If your IP is not in the "Firewall Rules" (Found in the Azure Portal under Networking), 
-- your connection will be dropped before it ever reaches the MySQL engine.

-- This is why imsdal@% is safe to have on Azure—it only works for people coming from "Approved" IP addresses.


select user, host, plugin from mysql.user;
-- imsdal	%	mysql_native_password
-- azure_superuser	127.0.0.1	mysql_native_password
-- mysql.infoschema	localhost	caching_sha2_password

-- show grants
SHOW GRANTS FOR 'imsdal'@'%';

-- How to check your current user's power
SHOW GRANTS FOR CURRENT_USER;

-- verify
SELECT user, host, plugin FROM mysql.user WHERE user = 'imsdal';

-- create new user and db example

CREATE DATABASE maka12_db;

CREATE USER 'maka12'@'%' IDENTIFIED WITH 'mysql_native_password' BY 'YourSafePassword123!';

GRANT ALL PRIVILEGES ON maka12_db.* TO 'maka12'@'%';
FLUSH PRIVILEGES;

-- verify
SHOW DATABASES LIKE 'maka12_db';
SHOW GRANTS FOR 'maka12'@'%';

-- set new pass run as admin user
ALTER USER 'maka12'@'%' 
IDENTIFIED WITH 'mysql_native_password' BY 'New_Strong_Password_123!';

FLUSH PRIVILEGES;
```

After you create an Azure Database for the MySQL server, you can use the first server admin account to create more users and grant admin access to them. You can also use the server admin account to create less privileged users with access to individual database schemas.

Why the docs say "Yes" but the Error says "No"
There is a subtle difference in how Azure handles "Admin Access":

1. The Provisioning Admin: This is your current imsdal@%. It is born with the azure_superuser role.

2. Created Admins: When you create a second user, Azure allows them to have ALL PRIVILEGES on *.*, which makes them a Schema/Data Admin.

3. The "System" Lock: Azure often blocks the transfer of the actual azure_superuser Role because that role has the power to modify the underlying Azure management hooks (like internal backup users).


https://learn.microsoft.com/en-us/azure/mysql/flexible-server/security-how-to-create-users


1. The MySQL Door (The inner door)
The % wildcard in your mysql.user table means that from MySQL’s perspective, the user imsdal is allowed to attempt a login from any IP address in the world.

2. The Azure Firewall (The outer door) Even if MySQL says "come on in," Azure has its own network-level firewall that sits in front of the database.

3. If your IP is not in the "Firewall Rules" (Found in the Azure Portal under Networking), your connection will be dropped before it ever reaches the MySQL engine.

This is why imsdal@% is safe to have on Azure—it only works for people coming from "Approved" IP addresses.

## Add plugin parameters to azure mysql server

![add param](https://github.com/spawnmarvel/todo-and-current/blob/main/mysql/images/add_param.png)

Check plugin azure mysql flexible server

```sql
SELECT * FROM mysql.password_history;

-- %	maka12	2026-01-26 10:48:58.592145	*663DEED53899140D858E294BE8C424FA76820B7D
-- %	maka12	2026-01-26 10:48:50.581617	*57E98802102EF534E245DC72EB2B0095BA03E1C7
			
```

## MySql 8.0 upgrade to 8.4 on clean database (for use with Zabbix 7.0 LTS)

```bash
sudo apt update
sudo apt upgrade -y

sudo apt install mysql-server -y

sudo systemctl status mysql

mysql --version
mysql  Ver 8.0.44-0ubuntu0.24.04.2 for Linux on x86_64 ((Ubuntu))
# this should work since it is minor
# Zabbix Server 7.0 LTS is fully compatible and widely used with MySQL 8.0, including version 8.0.44

sudo mysql_secure_installation
# n, y,y,y,y,y

sudo systemctl enable mysql

# we must upgrade mysql to 8.4 since 8.0 is soon out.
https://dev.mysql.com/downloads/repo/apt/
# (mysql-apt-config_0.8.36-1_all.deb)

# firewall shpould be open for a short time for any
# try download
wget https://dev.mysql.com/get/mysql-apt-config_0.8.36-1_all.deb
# works perfect

# Run the configuration tool:
sudo dpkg -i mysql-apt-config_0.8.36-1_all.deb

# Which MySQL product do you wish to configure? Select MySQL Server & Cluster.
# Which server version do you wish to receive? Select mysql-8.4-lts.
# view highligted version
# Finalize: Scroll to Ok and press Enter.

# perform the upgrade
sudo apt update

# Now, tell Ubuntu to install the new version. It will detect that 8.0 is already there and perform an "in-place" upgrade.
sudo apt install mysql-server


# verify
mysql --version
# mysql  Ver 8.4.7 for Linux on x86_64 (MySQL Community Server - GPL)

sudo mysql

# root has no password, we must fix this.
sudo mysql -u root

# ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'password';
# FLUSH PRIVILEGES;

sudo mysql -u root -p
# password


```

## MySql workbench


After you login with super user, like this:

You could be missing the Metadata and Internal Schemas.

![metadata internal](https://github.com/spawnmarvel/todo-and-current/blob/main/mysql/images/meta_internal.png)

Here is how to fix it:

*  Edit->preferences->sql editor->show metadata and internal schemas, tick it

![meta success](https://github.com/spawnmarvel/todo-and-current/blob/main/mysql/images/meta_success.png)

Here we are connected to Azure Database for MySQL flexible server

![mysql azure](https://github.com/spawnmarvel/todo-and-current/blob/main/mysql/images/mysql_azure.png)

You can also save or use default snippets.

![mysql snippets](https://github.com/spawnmarvel/todo-and-current/blob/main/mysql/images/snippets.png)

Download workbench

https://www.mysql.com/products/workbench/

## Azure Database for MySQL flexible server endpoints

The connection now through Allow public access to this resource through the internet using a public IP address
* mysqlzabbix0101 | Networking where we add client ip.

Lets change that to, Create private endpoints to allow hosts in the selected virtual network to access this server.
