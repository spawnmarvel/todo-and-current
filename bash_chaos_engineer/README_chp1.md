
Excellent. Let's kick things off with **Phase 1, Chapter 1: The Mystery of the Missing Space**.

In DevOps, one of the most common (and annoying) tickets you'll get is a server reporting it is out of disk space, even when `du` tells you the files don't add up.

---

### Step 1: The Sabotage (Run this on your VM)

To simulate this "Sad Server" scenario, copy and paste the following block into your terminal. This will create a "ghost" file—a file that is deleted but still being written to, consuming space that you can't see with a simple `ls`.

```bash
# Create a large 500MB file and hold it open with a background process
dd if=/dev/zero of=/tmp/ghost_file.log bs=1M count=500
tail -f /tmp/ghost_file.log > /dev/null &
# Delete the file immediately
rm /tmp/ghost_file.log

```

---

### Step 2: The Brief

**Symptom:** You receive an alert that `/tmp` (or your root partition) is filling up.
**The Problem:** When you run `ls -lh /tmp`, the 500MB file is nowhere to be found. However, if you run `df -h`, you will see that the disk space is still being consumed.

```bash
df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/root        29G  2.4G   26G   9% /
```

**Your Mission:** 1. Identify which process is holding onto the deleted file.
2. Free up the disk space **without** rebooting the server (rebooting is the "coward's way out" in production!).

---

### Step 3: Useful Tools

To solve this, you might want to look into these commands:

* `df -h` (To see the "truth" of the disk usage)
* `du -sh /*` (To see why the "truth" doesn't match the file sizes)
* `lsof` (List Open Files—this is your best friend here)
* `lsof 2>/dev/null` (remove permission denied)
* `sudo lsof / 2>/dev/null | awk '{if($7 > 0) print $7, $1, $9}' | sort -n -r | head -n 20` (return the 20 biggest files)

```log
524288000 tail /tmp/ghost_file.log
524288000 tail /tmp/ghost_file.log
524288000 tail /tmp/ghost_file.log
524288000 tail /tmp/ghost_file.log
12292411 systemd-u /usr/lib/udev/hwdb.bin
12292411 systemd-u /usr/lib/udev/hwdb.bin
8388608 systemd-j /var/log/journal/bb39db9968da4c93991ab05df69a3bf1/user-1000.journal
8388608 systemd-j /var/log/journal/bb39db9968da4c93991ab05df69a3bf1/user-1000.journal

``` 
* notice how tail is showing up
* `kill` or `truncate`

```bash
sudo pkill -9 tail
# or find the pid and kill it
ps aux | grep tail
sudo kill -9 # the number

df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/root        29G  1.9G   27G   7% /
```


---

**Once you have successfully reclaimed the space (checked via `df -h`), tell me:**

1. How did you find the "ghost" file?, checking big open files and sorted top 20
2. What command did you use to release the space?, killed tail

**Ready to investigate?**