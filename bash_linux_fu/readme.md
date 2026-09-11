# Linux Journey Exercises & Command Reference

A practical, step-by-step hands-on terminal exercise guide and command reference based on the **Grasshopper**, **Journeyman**, and **Networking Nomad** learning tracks.

Inspiration from https://linuxvoyage.github.io/

---

![fu](https://github.com/spawnmarvel/todo-and-current/blob/main/bash_linux_fu/images/fu.png)

## Table of Contents
- [Linux Journey Exercises \& Command Reference](#linux-journey-exercises--command-reference)
  - [Table of Contents](#table-of-contents)
  - [Track 1: baby yoda ](#track-1-baby-yoda)
    - [Getting Started](#getting-started)
    - [Command Line](#command-line)
    - [Text-Fu](#text-fu)
    - [Advanced Text-Fu](#advanced-text-fu)
    - [User Management](#user-management)
    - [Permissions](#permissions)
    - [Processes](#processes)
    - [Packages](#packages)
  - [Track 2: Walking yoda](#track-2-walking-yoda)
    - [Devices](#devices)
    - [The Filesystem](#the-filesystem)
    - [Boot the System](#boot-the-system)
    - [Kernel](#kernel)
    - [Init](#init)
    - [Process Utilization](#process-utilization)
    - [Logging](#logging)
  - [Track 3: Networking yoda](#track-3-networking-yoda)
    - [Network Sharing](#network-sharing)
    - [Network Basics](#network-basics)
    - [Subnetting](#subnetting)
    - [Routing](#routing)
    - [Network Config](#network-config)
    - [Troubleshooting](#troubleshooting)
    - [DNS](#dns)
  - [Track 4: Jedi yoda](#track-4-jedi-yoda)

---

## Track 1: Baby yoda

### Getting Started
* **Concepts:** Linux distributions, shell interface, system info discovery.
* **Key Commands:** `uname -a`, `cat /etc/os-release`, `hostnamectl`, `whoami`
* **Practical Tasks:**
  1. Display detailed kernel and OS architecture information using `uname -a`.
  2. Print the operating system release details by reading `/etc/os-release`.
  3. Check your system hostname and active user identity using `hostnamectl` and `whoami`. 

<details>
<summary>Click to expand answer</summary>

```bash
# 1
uname -a

# 2
cat /etc/os-release

# 3
hostnamectl
whoami
```
</details>

### Command Line
* **Concepts:** File system navigation, directory creation, file moving, and inspection.
* **Key Commands:** `pwd`, `ls -la`, `cd`, `mkdir -p`, `touch`, `cp`, `mv`, `rm -rf`
* **Practical Tasks:**
  1. Create a nested directory structure `/tmp/lab/project/src` in a single command.
  2. Create an empty file named `main.c` inside `/tmp/lab/project/src`, then copy it to `/tmp/lab/project/src/main.c.bak`.
  3. Move `main.c.bak` up to `/tmp/lab/project/` and rename it to `backup.c`.


<details>
<summary>Click to expand answer</summary>

```bash
# 1
# The -p flag creates parent directories automatically
mkdir -p /tmp/lab/projects/src
# 2
touch /tmp/lab/projects/src/main.c
cp /tmp/lab/projects/src/main.c /tmp/lab/projects/src/main.c.bak
# 3
mv /tmp/lab/projects/src/main.c.bak /tmp/lab/projects/backup.c
```
</details>

### Text-Fu
* **Concepts:** Standard output streams, file content inspection, piping, and filtering.
* **Key Commands:** `cat`, `less`, `head`, `tail`, `grep`, `wc -l`, `cut`, `sort`, `uniq`
* **Practical Tasks:**
  1. Create a text file with 10 lines of plain text and display only the first 3 lines using `head`.
  2. Search for all lines containing the word "error" (case-insensitive) in `/var/log/syslog` or `/var/log/messages`.
  3. Count the total number of lines in `/etc/passwd` using `wc -l`.


<details>
<summary>Click to expand answer</summary>

```bash
# 1

# 2

# 3
```
</details>

### Advanced Text-Fu
* **Concepts:** Command line text editing, stream manipulation, pattern searching, and execution.
* **Key Commands:** `nano`, `vim`, `sed`, `awk`, `find`, `xargs`
* **Practical Tasks:**
  1. Use `sed` to replace all occurrences of the word "localhost" with "127.0.0.1" in a sample copy of `/etc/hosts`.
  2. Use `find` to locate all `.log` files in `/var/log` modified in the last 7 days.
  3. Extract only the first column (usernames) from `/etc/passwd` using `awk -F: '{print $1}'`.


<details>
<summary>Click to expand answer</summary>

```bash
# 1

# 2

# 3
```
</details>

### User Management
* **Concepts:** User creation, modifying accounts, group assignments, and switching contexts.
* **Key Commands:** `useradd`, `usermod`, `userdel`, `passwd`, `groupadd`, `id`, `su`, `sudo`
* **Practical Tasks:**
  1. Create a new local user named `labuser` with a home directory and default bash shell.
  2. Add `labuser` to the `sudo` (or `wheel`) group.
  3. Verify the UID, GID, and secondary groups assigned to `labuser` using the `id` command.

<details>
<summary>Click to expand answer</summary>

```bash
# 1

# 2

# 3
```
</details>
```

### Permissions
* **Concepts:** File modes (read, write, execute), numeric/symbolic notation, ownership.
* **Key Commands:** `chmod`, `chown`, `umask`
* **Practical Tasks:**
  1. Create a file `/tmp/script.sh` and make it executable only for the file owner.
  2. Set the permissions of `/tmp/script.sh` to read/write for owner, read-only for group, and no permissions for others (`640`) using numeric notation.
  3. Change the ownership of `/tmp/script.sh` to `labuser`.

<details>
<summary>Click to expand answer</summary>

```bash
# 1

# 2

# 3
```
</details>

### Processes
* **Concepts:** Process lifecycles, signal handling, background execution, and job control.
* **Key Commands:** `ps aux`, `pgrep`, `kill`, `pkill`, `jobs`, `bg`, `fg`
* **Practical Tasks:**
  1. List all active processes owned by your current user using `ps`.
  2. Start a background process (`sleep 300 &`), identify its Process ID (PID), and terminate it using `kill`.
  3. Find the PID of a specific running process using `pgrep`.

<details>
<summary>Click to expand answer</summary>

```bash
# 1

# 2

# 3
```
</details>

### Packages
* **Concepts:** Package managers across Debian/Ubuntu (`apt`) and RHEL/Fedora (`dnf`).
* **Key Commands:** `apt update`, `apt install`, `apt remove`, `dpkg`, `dnf`, `rpm`
* **Practical Tasks:**
  1. Update local package manager indices (`apt update` or `dnf check-update`).
  2. Install a lightweight utility like `curl` or `htop`.
  3. Query the installed package database to verify the installation status of `curl`.

<details>
<summary>Click to expand answer</summary>

```bash
# 1

# 2

# 3
```
</details>

---

## Track 2: Walking yoda

### Devices
* **Concepts:** Block devices, character devices, kernel pseudo-filesystems (`/dev`, `/sys`, `/proc`).
* **Key Commands:** `lsblk`, `fdisk -l`, `blkid`, `lspci`, `lsusb`, `udevadm`
* **Practical Tasks:**
  1. List all block devices and their mount points using `lsblk`.
  2. Inspect the UUIDs and filesystem types of all local block devices using `blkid`.
  3. Display details about connected PCI or USB devices using `lspci` or `lsusb`.

<details>
<summary>Click to expand answer</summary>

```bash
# 1

# 2

# 3
```
</details>


### The Filesystem
* **Concepts:** Mount points, virtual filesystems, inodes, and disk space usage.
* **Key Commands:** `df -h`, `du -sh`, `mount`, `umount`, `ls -i`, `ln -s`, `stat`
* **Practical Tasks:**
  1. Check human-readable disk space usage across all mounted filesystems using `df -h`.
  2. Identify the top 5 largest directories under `/var` using `du -sh` and sorting.
  3. Create a symbolic link pointing from `/tmp/softlink` to `/etc/passwd`.


<details>
<summary>Click to expand answer</summary>

```bash
# 1

# 2

# 3
```
</details>

### Boot the System
* **Concepts:** Firmware (BIOS/UEFI), bootloaders (GRUB), initrd/initramfs, and kernel initialization.
* **Key Commands:** `dmesg`, `journalctl -b`, `grub2-mkconfig`
* **Practical Tasks:**
  1. Inspect kernel boot messages filtered for hardware or memory initialization using `dmesg`.
  2. View log messages generated during the current system boot cycle using `journalctl -b`.
  3. Inspect the contents of `/boot` to identify the active kernel image (`vmlinuz`) and initramfs files.

<details>
<summary>Click to expand answer</summary>

```bash
# 1

# 2

# 3
```
</details>

### Kernel
* **Concepts:** Loadable kernel modules (LKMs), kernel parameters, runtime tuning (`/proc/sys`).
* **Key Commands:** `lsmod`, `modinfo`, `modprobe`, `rmmod`, `sysctl`
* **Practical Tasks:**
  1. List all currently loaded kernel modules using `lsmod`.
  2. Display detailed information about a specific kernel module (e.g., `e1000e` or `ext4`) using `modinfo`.
  3. Display the active setting for IPv4 packet forwarding using `sysctl net.ipv4.ip_forward`.

<details>
<summary>Click to expand answer</summary>

```bash
# 1

# 2

# 3
```
</details>

### Init
* **Concepts:** Service management, targets/runlevels, systemd unit files.
* **Key Commands:** `systemctl status`, `systemctl start`, `systemctl stop`, `systemctl restart`, `systemctl enable --now`, `systemctl daemon-reload`
* **Practical Tasks:**
  1. Check the status of the `SSH` or `cron` service using `systemctl status`.
  2. Restart a target service and confirm its main PID has changed.
  3. List all currently active systemd service units.

<details>
<summary>Click to expand answer</summary>

```bash
# 1

# 2

# 3
```
</details>

### Process Utilization
* **Concepts:** System performance metrics, CPU/memory pressure, I/O bottlenecks.
* **Key Commands:** `top`, `htop`, `uptime`, `free -h`, `vmstat`, `iostat`, `sar`
* **Practical Tasks:**
  1. Launch `top` or `htop` to identify the process consuming the highest CPU load.
  2. Check total and available system RAM and swap memory using `free -h`.
  3. Display system uptime and average CPU load over 1, 5, and 15 minutes using `uptime`.

<details>
<summary>Click to expand answer</summary>

```bash
# 1

# 2

# 3
```
</details>

### Logging
* **Concepts:** System log files, systemd journal queries, log rotation configurations.
* **Key Commands:** `journalctl -u`, `journalctl -p`, `tail -f`, `logrotate`
* **Practical Tasks:**
  1. Stream real-time log entries for the last 20 lines of `/var/log/syslog` or `/var/log/messages` using `tail -f`.
  2. Use `journalctl` to display logs filtered strictly by high-severity priority levels (`err` and higher).
  3. Query system logs for a specific systemd unit over the last hour.

<details>
<summary>Click to expand answer</summary>

```bash
# 1

# 2

# 3
```
</details>

---

## Track 3: Networking yoda

### Network Sharing
* **Concepts:** Secure file transfer, remote directory synchronization, network file systems.
* **Key Commands:** `scp`, `rsync -avzP`, `showmount -e`
* **Practical Tasks:**
  1. Use `scp` to transfer a local test file to `/tmp` on a remote host (or `localhost`).
  2. Synchronize a local directory to a target backup directory using `rsync -avzP`.
  3. Verify RPC/NFS shares on a target IP address using `showmount -e` (or inspect `/etc/exports`).

<details>
<summary>Click to expand answer</summary>

```bash
# 1

# 2

# 3
```
</details>

### Network Basics
* **Concepts:** IP address inspection, network interfaces, MAC addresses, link state.
* **Key Commands:** `ip addr show`, `ip link show`, `ping`, `arp -n`, `ip neighbor`
* **Practical Tasks:**
  1. Display all active network interfaces, assigned IP addresses, and MAC addresses using `ip addr show`.
  2. Send 4 ICMP echo requests to `8.8.8.8` to test basic network connectivity using `ping`.
  3. Display the local ARP table mapping IP addresses to physical MAC addresses using `ip neighbor` or `arp -n`.

<details>
<summary>Click to expand answer</summary>

```bash
# 1

# 2

# 3
```
</details>

### Subnetting
* **Concepts:** Classless Inter-Domain Routing (CIDR), network masks, broadcast domains.
* **Key Commands:** `ipcalc`, `ip addr show`
* **Practical Tasks:**
  1. Calculate network, broadcast, and host range details for `192.168.1.50/26` using `ipcalc`.
  2. Determine the network prefix length and netmask for an interface using `ip addr show`.
  3. Calculate the maximum host capacity of a `/28` subnet.

<details>
<summary>Click to expand answer</summary>

```bash
# 1

# 2

# 3
```
</details>
```

### Routing
* **Concepts:** Routing tables, default gateways, packet paths.
* **Key Commands:** `ip route show`, `ip route add`, `ip route del`, `traceroute`, `tracepath`
* **Practical Tasks:**
  1. Display the kernel routing table and identify the default gateway IP using `ip route show`.
  2. Trace the network hop path to `1.1.1.1` using `traceroute` or `tracepath`.
  3. Add a temporary static route targeting a dummy network (e.g., `10.10.0.0/16`) via your local gateway, then remove it.

<details>
<summary>Click to expand answer</summary>

```bash
# 1

# 2

# 3
```
</details>

### Network Config
* **Concepts:** Persistent network configuration, hostname resolution, interface control.
* **Key Commands:** `nmcli`, `nmtui`, `ip link set`, `/etc/resolv.conf`, `/etc/hosts`
* **Practical Tasks:**
  1. Check network connection status and interface settings using `nmcli device status` or `ip link`.
  2. Inspect `/etc/resolv.conf` to identify configured upstream DNS nameservers.
  3. Add a custom hostname-to-IP mapping entry inside `/etc/hosts` and verify resolution via `ping`.

<details>
<summary>Click to expand answer</summary>

```bash
# 1

# 2

# 3
```
</details>

### Troubleshooting
* **Concepts:** Active sockets, open ports, connectivity testing, packet inspection.
* **Key Commands:** `ss -tulpn`, `nc -zv`, `telnet`, `tcpdump`, `curl -I`
* **Practical Tasks:**
  1. List all active TCP listening sockets along with process names and port numbers using `ss -tulpn`.
  2. Test TCP port connectivity to a remote web server on port 80 using `nc -zv` or `telnet`.
  3. Capture 10 ICMP packets on your primary network interface using `tcpdump`.

<details>
<summary>Click to expand answer</summary>

```bash
# 1

# 2

# 3
```
</details>

### DNS
* **Concepts:** Name resolution queries, record types (A, AAAA, MX, CNAME, TXT), propagation checks.
* **Key Commands:** `dig`, `dig MX`, `dig -x`, `nslookup`, `host`, `systemd-resolve`
* **Practical Tasks:**
  1. Perform a DNS lookup for `example.com` to retrieve its `A` record using `dig`.
  2. Query the authoritative Mail Transfer Agent (`MX`) records for a target domain using `dig MX`.
  3. Perform a reverse DNS lookup on an IP address (e.g., `8.8.8.8`) using `dig -x`.

<details>
<summary>Click to expand answer</summary>

```bash
# 1

# 2

# 3
```
</details>

---

## Track 4: Jedi yoda