Welcome back! Here is the clean, structured breakdown for **Chapter 2: The Permission Denied Rabbit Hole**. You can copy this directly into your `README.md`.

---

## Chapter 2: The "Permission Denied" Rabbit Hole

**Focus:** Advanced Permissions, File Attributes, and Ownership.

### 1. The Scenario

Standard Linux permissions (`rwx`) are only the tip of the iceberg. In this chapter, we encounter files that refuse to be modified even by the `root` user, and directories that prevent deletion despite having "full" access.

### 2. The Sabotage (Setup)

Run these commands to create the broken environment:

```bash
# Task A: The Immutable Script
echo -e '#!/bin/bash\necho "App 1: Execution Successful"' > ~/secret_app.sh
chmod 644 ~/secret_app.sh
sudo chattr +i ~/secret_app.sh

# Task B: The Ghost Owner
sudo useradd ghostuser 2>/dev/null
echo -e '#!/bin/bash\necho "App 2: Secure Run Successful"' | sudo tee /usr/local/bin/secure_run.sh
sudo chown ghostuser:ghostuser /usr/local/bin/secure_run.sh
sudo chmod 700 /usr/local/bin/secure_run.sh

# Task C: The Sticky Folder
sudo mkdir -p /var/www/shared
sudo chmod 1777 /var/www/shared
sudo touch /var/www/shared/system.log

```

### 3. Your Mission

You must complete the following three objectives:

* **Objective A:** Make `~/secret_app.sh` executable and run it. You will find that even `sudo chmod +x` fails until you find and remove the **Immutable (+i)** attribute.
* **Objective B:** Successfully execute `/usr/local/bin/secure_run.sh`. You must change the **ownership** from `ghostuser` to your current user and fix the permissions.
* **Objective C:** Delete `/var/www/shared/system.log` as a regular user (without using `sudo rm`). You will need to understand how the **Sticky Bit** on the parent directory is blocking the deletion.

### 4. Diagnostic Toolkit

* `lsattr`: To see extended file attributes (the "hidden" locks).
* `chattr`: To change extended attributes.
* `ls -la`: To inspect the 4th column (owner) and 5th column (group).
* `chown`: To change file/directory ownership.
* `chmod`: To change standard permissions and special bits (like `-t`).

---

**Would you like the solutions for these objectives now, or do you want to try solving them on your VM first and check back with me?**