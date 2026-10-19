# MySQL General tunning


# Table of Contents

- [MySQL General tunning](#mysql-general-tunning)
- [Table of Contents](#table-of-contents)
  - [Key MySQL Configuration Parameters](#key-mysql-configuration-parameters)
  - [Zabbix-Specific Workload Characteristics](#zabbix-specific-workload-characteristics)
  - [General guidelines and useful queries scenario 1](#general-guidelines-and-useful-queries-scenario-1)
    - [1. MySQL Configuration (/etc/mysql/mysql.conf.d/mysqld.cnf)](#1-mysql-configuration-etcmysqlmysqlconfdmysqldcnf)
    - [2. InnoDB Flushing \& Redo Log Optimization](#2-innodb-flushing--redo-log-optimization)
    - [2.1 Test and restart](#21-test-and-restart)
    - [3. Systemd \& Resource Limits (override.conf)](#3-systemd--resource-limits-overrideconf)
    - [4. Storage \& Filesystem Tuning](#4-storage--filesystem-tuning)
    - [5. Verification \& Zabbix Health Checks](#5-verification--zabbix-health-checks)
  - [Healthy and unhealty zabbix sceanrio with 20GB database](#healthy-and-unhealty-zabbix-sceanrio-with-20gb-database)

---


## Key MySQL Configuration Parameters

🔵 innodb_buffer_pool_size: Allocate 60% to 80% of total system RAM on dedicated servers to cache database data and indexes directly in memory.

🔵 innodb_buffer_pool_instances: Divide the buffer pool into multiple instances (typically 4 to 8) to reduce lock contention on multi-core systems.

🔵 innodb_flush_log_at_trx_commit: Set to 1 for full ACID compliance, or 2 to write to OS cache on commit and flush once per second for a massive write performance boost.

🔵 innodb_flush_method: Use O_DIRECT on Linux to bypass kernel page caching and prevent double-buffering of database pages in memory.

🔵 innodb_redo_log_capacity: Increase capacity (e.g., 1GB to 2GB+) to buffer write-heavy operations and smooth out disk write spikes.

🔵 max_connections: Right-size connection limits based on actual application concurrency to prevent high thread memory overhead and CPU thrashing.

🔵 thread_cache_size: Cache idle server threads to eliminate the CPU overhead of creating and destroying connections repeatedly.

🔵 tmp_table_size & max_heap_table_size: Increase these equally (e.g., 64M to 256M) to prevent complex intermediate query operations from spilling to slow disk storage.


## Zabbix-Specific Workload Characteristics

Zabbix generates a heavily write-intensive workload characterized by high-volume INSERT streams (trends, history data) alongside periodic background housekeeping deletes or partitioning routines. 

Since the database host is dedicated to MySQL and serving a remote Zabbix server, the configuration is adjusted to maximize disk flush efficiency and lower overhead per remote connection

## General guidelines and useful queries scenario 1

Hardware & OS Profile Assessment

* OS: Ubuntu 26.04 LTS (Kernel 6.x series)
* CPU / vCPU: 2 vCPUs
* RAM: 8 GB total (~7 GB allocatable to MySQL and OS caches)
* Storage Setup: 60 GB external block storage mounted for MySQL data directory (/var/lib/mysql or custom path)

### 1. MySQL Configuration (/etc/mysql/mysql.conf.d/mysqld.cnf)


Update your /etc/mysql/mysql.conf.d/mysqld.cnf file with these settings optimized for Zabbix on 8 GB RAM and 2 vCPUs:

To keep Zabbix snappy, you need to move away from default settings and tune for high-throughput concurrency.

The innodb_buffer_pool_size is the most critical setting. This is where MySQL caches data and indexes. For a dedicated Zabbix database server, you should allocate 50% to 75% of your total system RAM to this pool.

```ini
[mysqld]
# ----------------------------------------------------------------------
# Memory & InnoDB Buffer Pool
# ----------------------------------------------------------------------
# Allocate ~70% of 8 GB RAM to InnoDB Buffer Pool (5.5 GB)
# Keeps history/trends data cached for faster dashboard reads
innodb_buffer_pool_size = 5.5G

# Divide buffer pool into 4 instances (~1.37 GB each) to reduce lock contention
innodb_buffer_pool_instances = 4

# ----------------------------------------------------------------------
# Remote Connections & Threading
# ----------------------------------------------------------------------
# Remote Zabbix pollers and trappers use short-lived connections
# Set to handle Zabbix server pool without consuming excessive memory
max_connections = 200

# Cache active threads to minimize CPU cost from constant remote reconnects
thread_cache_size = 32

# Buffer memory per query thread
tmp_table_size = 64M
max_heap_table_size = 64M
sort_buffer_size = 2M
join_buffer_size = 2M

# ----------------------------------------------------------------------
# Write-Intensive Workload & Redo Log Tuning
# ----------------------------------------------------------------------
# 1.5 GB capacity handles continuous insert bursts from Zabbix history writes
innodb_redo_log_capacity = 1.5G

# Bypass OS page caching and flush directly to the external data disk
innodb_flush_method = O_DIRECT

# Direct I/O threads tuned for 2 vCPUs
innodb_read_io_threads = 4
innodb_write_io_threads = 4
innodb_purge_threads = 2

# ----------------------------------------------------------------------
# Log & Lock Optimization for Zabbix
# ----------------------------------------------------------------------
# Disable lock waiting overhead on long housekeeping routines
innodb_lock_wait_timeout = 50

# Slow query logging
slow_query_log = 1
slow_query_log_file = /var/log/mysql/mysql-slow.log
long_query_time = 2
log_queries_not_using_indexes = 0
```

### 2. InnoDB Flushing & Redo Log Optimization

Zabbix continuously writes metrics, making transaction log flushing a key area for performance balancing:

Default (ACID Compliant): innodb_flush_log_at_trx_commit = 1 guarantees zero data loss on power failure or crash.

High Performance Option: If losing up to 1 second of non-critical metric history during an unexpected power loss on the database host is acceptable, set:

```ini
innodb_flush_log_at_trx_commit = 2
```
This reduces disk write I/O operations significantly and frees up CPU cycles for the 2 vCPUs.

innodb_flush_log_at_trx_commit = 2: This is the "magic" setting. Instead of flushing to disk on every single transaction (1), it flushes once per second. In the event of an OS crash, you might lose 1 second of data, but the performance gain is massive.


### 2.1 Test and restart

```bash
# Test configuration syntax before restarting
mysqld --validate-config

# Restart the service
sudo systemctl restart mysql
# or on RHEL/CentOS
sudo systemctl restart mysqld

# Verify active status
sudo systemctl status mysql
```

### 3. Systemd & Resource Limits (override.conf)

Remote Zabbix traffic requires high file descriptor limits for open sockets and database tables.

Create the override directory:

```bash
sudo mkdir -p /etc/systemd/system/mysql.service.d/

```

Create /etc/systemd/system/mysql.service.d/override.conf:

```ini
[Service]
LimitNOFILE=65535
LimitMEMLOCK=infinity
```
Reload systemd and restart MySQL:

```bash
sudo systemctl daemon-reload
sudo systemctl restart mysql
```


### 4. Storage & Filesystem Tuning

For the external 60 GB data disk containing /var/lib/mysql:

Mount Options (/etc/fstab):
Verify the mount entry includes noatime to stop unnecessary write operations whenever Zabbix reads data tables.

```txt
UUID=your-60gb-disk-uuid /var/lib/mysql ext4 defaults,noatime 0 2
```

Linux Swappiness (/etc/sysctl.conf):

Set low swappiness so the 5.5 GB Buffer Pool remains in memory without being paged to disk by Ubuntu 26.04.

```ini
vm.swappiness = 10
```

Apply setting:

```bash
sudo sysctl -p
```

### 5. Verification & Zabbix Health Checks

Run these commands on MySQL to check thread connections and buffer usage:

```sql
-- Check connection activity from the remote Zabbix host
SHOW STATUS LIKE 'Threads_connected';
SHOW STATUS LIKE 'Max_used_connections';

-- Verify buffer pool dirty pages (high numbers indicate heavy background writing)
SHOW STATUS LIKE 'Innodb_buffer_pool_pages_dirty';

-- Monitor redo log flush rate
SHOW STATUS LIKE 'Innodb_os_log_pending_writes';
```

## Healthy and unhealty zabbix sceanrio with 20GB database

The "Health Report" Recap
Ingestion Rate: 50 NVPS is roughly 4.3 million values per day. For a modern CPU and SSD, this is a very light load.

* Database Volume: 20GB database is large enough that you should be mindful of your Buffer Pool, but small enough that backups and migrations are still fast.

* Housekeeper Performance: Your 2-minute cleanup time confirms that your disk I/O is currently faster than your data growth. You are "winning" the race against storage.

![zabbix health scale](https://github.com/spawnmarvel/todo-and-current/blob/main/mysql/images/zabbix_life.png)

Default + Minor Tuning

1. Memory: The "Right-Sized" Buffer Pool
At 20GB, your database doesn't need 80% of your RAM, but it does need enough to keep the indexes in memory.
* Set innodb_buffer_pool_size to 4G or 8G (depending on your total System RAM).

1. Efficiency: The "Magic" Flush Setting
This is the single most impactful change for any Zabbix user.
* Set innodb_flush_log_at_trx_commit = 2

1. Disk Access: Bypassing the OS Cache
Without this, your Linux OS and MySQL both try to cache the same data (Double Buffering)
* Set innodb_flush_method = O_DIRECT

1. Throughput: Sizing the Redo Logs
Larger log files allow MySQL to "smooth out" the writing process.
* innodb_log_file_size = 512M or 1G.

