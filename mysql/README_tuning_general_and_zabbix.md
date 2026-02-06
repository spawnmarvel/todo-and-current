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