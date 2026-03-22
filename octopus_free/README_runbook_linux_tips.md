# Project Linux Day2 Operations

## Tips

### 1. apt or apt-get for install

```bash
# The standard "Automation" way
sudo apt-get update
sudo apt-get install -y snmp

# # The "I'm a Human" way
sudo apt update
sudo apt install -y snmp

# WARNING: apt does not have a stable CLI interface. Use with caution in scripts.
# — is a standard message whenever the apt command is used programmatically or in scripts.  
# It’s informing you that apt is intended for interactive use, and that scripting against it could 
# break in future versions (since its options/output format may change). **For scripts**, the 
# recommended command is apt-get or apt-cache instead, 
# because they have a stable interface meant for automation.  

# The standard "Automation" way
sudo apt-get remove -y snmp

# The "I'm a Human" way
sudo apt remove -y snmp

```

The "Rules of the Road" for 2026

* apt-get is for Scripts/Octopus. It is the "stable" version. Its output doesn't change much between Linux versions, which prevents scripts from breaking unexpectedly.

* apt is for Humans. It has pretty progress bars, colors, and friendly summaries. It's what you type when you are sitting at the keyboard.



### 2. In draft vs publish

In draft mode you can edit, save and it picks up changes at once.

Publishing a runbook will snapshot the runbook process and the associated assets (packages, scripts, variables) as they existed at that moment in time. After publishing a runbook, any future edits made will be considered a “draft.” For a trigger to pick up those new changes, a new publish event will need to occur.

### 3. Before you run a runbook, process->target tags

Before you run a runbook always go to

1. Process
2. Target tags, always check it

![process_always_check_target](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/process_always_check_target.png)

Either a vm or multiple vm's or a environment.

![targets_](https://github.com/spawnmarvel/todo-and-current/blob/main/octopus_free/images/targets_.png)


### 4. Upload a packet to linux

### 5. Use variables

Turn those commands into a Bash or PowerShell script. Replace hardcoded values with variables for automation.

```bash
# Bad: 
mysql --user=root --password=Password123
# Good: 
mysql --user=#{MySQL.User} --password=#{MySQL.Password}
```

### 6 Install MySql

Here we use apt-get and variables


### 7 Upgrade MySql with a packet

Here we use apt-get, variables and we have a downloaded MySql 8.4 packet