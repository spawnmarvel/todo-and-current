# Deploy resources fast

Continue from Azure Automation bicep and labs

https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/README.md

## vmhybrid01 (must be started for DNS and internet access)

The Azure "Bridge" vmhybrid01 (In the Portal) use domain controller vm as DNS server.

By doing this at the VNet level, every other VM you create in the future will automatically use vmhybrid01 as its DNS server via DHCP. This makes "Domain Joining" other VMs effortless.

Since your Linux machines are now going to ask 192.168.3.7 for everything (including google.com or Ubuntu update mirrors), you must ensure the Windows DC knows how to "pass the ball."

If you haven't done this yet, do it now on vmhybrid01:

* Open DNS Manager.

* Right-click vmhybrid01 > Properties > Forwarders.

* Add 168.63.129.16 (Azure's DNS).

💠 There is auto shutdown at every night for this vm also.

```bash
# vmhybrid01 not started
ping www.ba.no

# vmhybrid01 started
ping www.ba.no
PING web.avis.api.no.cdn.cloudflare.net (104.18.23.107) 56(84) bytes of data.
64 bytes from 104.18.23.107: icmp_seq=1 ttl=54 time=7.48 ms
```

https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-ad-ds-windows-server-hybrid-core-infrastructure/README_cloud-only-hybrid-Lab_2_install-ad.md

## Deploy Linux vm with public ip into existing vnet (vmhybrid01 you must start)

This is just for fast deploy and remove.

### Deploy vm linux with powershell or bash

Template and script for vm in ./linux_deploy_and_remove

💠  Windows

* Store Tenant ID in Environment Varibles-> User variables

* t_id = Tenant ID

💠 Linux

* export t_id="your-tenant-id-here"


Example used in deploy.ps1

```ps1
# Get the id 
$t_id =[System.Environment]::GetEnvironmentVariable("t_id", "User")
# connect
connect-AzAccount -TenantId $t_id
# [...]

```

💠 Run script deploy.ps1 it will ask for login to azure, then username and password for vm

```ps1
.\deploy.ps1

```
Output
```txt
Checking for Resource Group: RG-uks-temp-resources-001...
Resource Group not found. Creating it now in uksouth...
Account                 SubscriptionName TenantId                             Environment
```
This will be deploy

![linux vm](https://github.com/spawnmarvel/todo-and-current/blob/main/iac_fast_biceps/images/linux_vm.png)

```bash
# login, get public ip
ssh user@public-ip

```
💠 Run script deploy.sh it will ask for login to azure, then username and password for vm

```bash
# this is for session only, after close shell is gone
export t_id="your-tenant-id-here"

# make it permanent one line
echo 'export t_id="6dae3ddb-0cf5-4fa6-a49c-c32ae6589d1f""' >> ~/.bashrc
# verify it
grep "t_id" ~/.bashrc

# or add it 
nano ~/.bashrc
export t_id="your-tenant-id-here"
source ~/.bashrc

# Now run your script normally
./deploy.sh

```

Using export for a Tenant ID is like carrying a master key in your shirt pocket—it’s incredibly handy until you change your shirt (or close the terminal). 

Moving it into a .bashrc alias or letting the az CLI handle it turns that master key into a biometric lock; it's there when you need it, and you don't have to worry about where you put it.

### Remove vm linux with powershell or bash and ***  (vmhybrid01 you must stop)


💠  remove.ps1

```ps1
.\remove.ps1

```
Output

```txt
Warning: This will delete everything inside RG-uks-temp-resources-001!
```

💠  remove.sh

```bash
export t_id="your-tenant-id-here"
# Now run your script normally
./remove.sh

```

### Storage account with files and scripts

Lets make a storage account and use blobs for uploading:

* .exe, .deb
* .ps1, .sh

Networking Tab (The Firewall)

🔵 Public network access: Set to Enabled from selected virtual networks and IP addresses.

🔵 Virtual networks: Click + Add existing virtual network and select the VNet/Subnet where your Linux VMs live. This allows your VMs to "talk" to the storage directly.

🔵 Firewall (IP Addresses): Check the box that says "Add your client IP address".

Note: Since you want to upload from "any machine," you will need to click this button or manually add your current public IP whenever you are at a new location (e.g., home vs. office).

🔵 Resource instances: (Optional) If you use other Azure services (like Logic Apps or Backup), select the "Microsoft.Storage/storageAccounts" resource type here to allow them through.

Then we can fast deploy our files and scripts

stscriptspackets001 | Containers

* fileslinux (and same for windows)
* scriptslinux (and same for windows)

#### Download and run a script

💠 Linux download a script from storage acount (DNS server must be running)

Step 1: Generate the link in Azure Portal
Go to your storage account and click on Containers.

Click into your fileslinux container.

Click the three dots (...) next to your script (e.g., install.sh) and select Generate SAS.

Permissions: Ensure "Read" is checked.

Expiry: Set it for a few hours (or however long you need).

Click Generate SAS token and URL.

Copy the Blob SAS URL (it will be a very long link).

```bash
# we are on the linuc vm we deployed with iac
vm-uks-temp-001

# lets get the script install_tentacle_linux.sh
# go to the script in the portal and generate sas token and url
# start DNS server

wget -O install_linux_tentacle.sh "https://youraccount.blob.core.windows.net/fileslinux/install.sh?sp=r&st=2026-04-19..."

# Give it permission to run
chmod +x install_linux_tentacle.sh 

# Run it
./install_linux_tentacle.sh 

# To set up a Tentacle instance, run the following script:
/opt/octopus/tentacle/configure-tentacle.sh

# check it
which tentacle

```

#### Download and run a file

💠 Linux download a file from storage acount (DNS server must be running)

tep 1: Generate the link in Azure Portal
Go to your storage account and click on Containers.

Click into your fileslinux container.

Click the three dots (...) next to your script (e.g., install.sh) and select Generate SAS.

Permissions: Ensure "Read" is checked.

Expiry: Set it for a few hours (or however long you need).

Click Generate SAS token and URL.

Copy the Blob SAS URL (it will be a very long link).

```bash
wget -O libmecab2_0.996-14build9_amd64.deb"https://youraccount.blob.core.windows.net/fileslinux/install.sh?sp=r&st=2026-04-19..."

# install it
sudo dpkg -i libmecab2_0*.deb

```