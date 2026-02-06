# MySQL General tunning

Configuration: Tuning the "Engine"
For a general-purpose server, the goal is to balance memory usage and disk efficiency.

* innodb_buffer_pool_size: On a dedicated database server, set this to 70-80% of RAM. If the server shares RAM with other apps (like a web server), keep it around 40-50%.

* innodb_dedicated_server = ON: If you are on a dedicated server with MySQL 8.0+, enable this. MySQL will automatically detect your RAM and CPU and tune the buffer pool and log sizes for you.

* innodb_log_file_size: Aim for enough space to hold about 1 hour of write activity. For general workloads, 1GB to 2GB is the gold standard.

* innodb_io_capacity: Tell MySQL how fast your disks are.

- Standard HDD: 200
- SATA SSD: 2,000
- NVMe SSD: 10,000+


## Healthy and unhealty zabbix

The "Health Report" Recap
Ingestion Rate: 50 NVPS is roughly 4.3 million values per day. For a modern CPU and SSD, this is a very light load.

* Database Volume: 20GB is large enough that you should be mindful of your Buffer Pool, but small enough that backups and migrations are still fast.

* Housekeeper Performance: Your 2-minute cleanup time confirms that your disk I/O is currently faster than your data growth. You are "winning" the race against storage.

![zabbix health scale](https://github.com/spawnmarvel/todo-and-current/blob/main/mysql/images/zabbix_life.png)

Default + Minor Tuning

1. Memory: The "Right-Sized" Buffer Pool
At 20GB, your database doesn't need 80% of your RAM, but it does need enough to keep the indexes in memory.
* Set innodb_buffer_pool_size to 4G or 8G (depending on your total System RAM).

2. Efficiency: The "Magic" Flush Setting
This is the single most impactful change for any Zabbix user.
* Set innodb_flush_log_at_trx_commit = 2

3. Disk Access: Bypassing the OS Cache
Without this, your Linux OS and MySQL both try to cache the same data (Double Buffering)
* Set innodb_flush_method = O_DIRECT

4. Throughput: Sizing the Redo Logs
Larger log files allow MySQL to "smooth out" the writing process.
* innodb_log_file_size = 512M or 1G.

Summary Checklist (my.cnf)
Add or edit these lines under the [mysqld] section of your configuration file (usually /etc/mysql/my.cnf or /etc/my.cnf):

```ini
[mysqld]
# Memory Allocation
innodb_buffer_pool_size = 4G     # Adjust based on available RAM
innodb_buffer_pool_instances = 4 # Helps with memory concurrency

# Write Optimization
innodb_flush_log_at_trx_commit = 2
innodb_flush_method = O_DIRECT
innodb_log_file_size = 512M

# Connection Handling
max_connections = 200            # Plenty for 50 NVPS
```

1. Edit your config file: sudo nano /etc/mysql/my.cnf
2. Save and exit.
3. Restart MySQL: sudo systemctl restart mysql (Note: This will briefly disconnect Zabbix).

Since your database is 20GB, you can't fit the whole thing in memory, but at 50 NVPS, a 4GB buffer pool is more than enough to cache the "hot" data (recent history and configuration) so that your Zabbix dashboard stays fast.


## MySQL General tunning zabbix

Mysql zabbix tuning. Optimizing MySQL for Zabbix is a high-impact task because Zabbix is notoriously write-heavy. It constantly streams "history" data (metrics) and "trends" (summaries) into the database, which can lead to disk I/O bottlenecks.

To keep Zabbix snappy, you need to move away from default settings and tune for high-throughput concurrency.

1. Tune the InnoDB Buffer Pool

The innodb_buffer_pool_size is the most critical setting. This is where MySQL caches data and indexes. For a dedicated Zabbix database server, you should allocate 50% to 75% of your total system RAM to this pool.

* Goal: Keep as much of the working data set in memory as possible to avoid disk reads.

* Tip: If your pool is > 8GB, set innodb_buffer_pool_instances to 8 or 16 to reduce lock contention.

2. Implement Database Partitioning

Zabbix tables like history and trends grow indefinitely. The default "Housekeeper" process deletes old data using DELETE statements, which is slow and fragments the database.

* The Fix: Use MySQL Partitioning. Instead of deleting row-by-row, Zabbix simply "drops" an entire partition (e.g., one day's worth of data).

* Benefit: This eliminates Housekeeper overhead and keeps your disk I/O flat.

3. Optimize Disk I/O & Log Flushing

Zabbix generates a lot of small writes. You can significantly boost performance by adjusting how MySQL handles the "Doublewrite" buffer and log commits.

* innodb_flush_log_at_trx_commit = 2: This is the "magic" setting. Instead of flushing to disk on every single transaction (1), it flushes once per second. In the event of an OS crash, you might lose 1 second of data, but the performance gain is massive.