# Project Linux Day2 Operations

## Tips

```bash
sudo apt-get update
sudo apt-get install -y snmp

# vs
sudo apt update
sudo apt install -y snmp

# WARNING: apt does not have a stable CLI interface. Use with caution in scripts.
# — is a standard message whenever the apt command is used programmatically or in scripts.  
# It’s informing you that apt is intended for interactive use, and that scripting against it could 
# break in future versions (since its options/output format may change). **For scripts**, the 
# recommended command is apt-get or apt-cache instead, 
# because they have a stable interface meant for automation.  

```