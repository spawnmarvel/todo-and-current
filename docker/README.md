# docker commands

```bash
# after apply for example memory: 1024M in compose, you can check it with
docker stats

```
```logs
CONTAINER ID   NAME            CPU %     MEM USAGE / LIMIT   MEM %     NET I/O           BLOCK I/O         PIDS
7b8d147eee27   zabbix-agent    0.01%     11.54MiB / 128MiB   9.02%     10.2kB / 10.7kB   0B / 766kB        8
419dda2d21d7   zabbix-web      1.28%     87.86MiB / 512MiB   17.16%    9.61MB / 7.44MB   0B / 20.5kB       65
5a8311804cfe   zabbix-server   0.25%     122.6MiB / 512MiB   23.95%    39.4MB / 26MB     0B / 3.48MB       79
266ef24851b6   zabbix-db       1.86%     726.3MiB / 1GiB     70.93%    29.3MB / 47.9MB   66.7MB / 1.78GB   71
26a5cb204257   portainer-app   0.00%     94.4MiB / 600MiB    15.73%    2.11MB / 4.45MB   71.8MB / 1.47MB   5
217c3c9eba5b   grafana         1.34%     118.6MiB / 800MiB   14.82%    34.9MB / 33.1MB   100MB / 0B        15
628b027ee1cc   grafana_db      1.16%     467.7MiB / 1GiB     45.68%    32.9MB / 34.8MB   92.5MB / 70.5MB   49
```