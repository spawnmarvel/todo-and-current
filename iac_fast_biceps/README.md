# Deploy resources fast

Continue from Azure Automation bicep and labs

https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/README.md

## vmhybrid01 (must be started for DNS and internet access)

The Azure "Bridge" vmhybrid01 (In the Portal) use domain controller vm as DNS server.

By doing this at the VNet level, every other VM you create in the future will automatically use vmhybrid01 as its DNS server via DHCP. This makes "Domain Joining" other VMs effortless.

Since your Linux machines are now going to ask 192.168.3.7 for everything (including google.com or Ubuntu update mirrors), you must ensure the Windows DC knows how to "pass the ball."

```bash
# vmhybrid01 no started
ping www.ba.no

# vmhybrid01 started
ping www.ba.no
PING web.avis.api.no.cdn.cloudflare.net (104.18.23.107) 56(84) bytes of data.
64 bytes from 104.18.23.107: icmp_seq=1 ttl=54 time=7.48 ms
```

https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/az-ad-ds-windows-server-hybrid-core-infrastructure/README_cloud-only-hybrid-Lab_2_install-ad.md

## Deploy Linux vm with public ip into existing vnet

This is just for fast deploy and remove.

### Deploy vm linux

Template and script for vm in ./linux_deploy_and_remove

💠 Store Tenant ID in Environment Varibles-> User variables

💠t_id = Tenant ID

```ps1
# Get the id example
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
``txt
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
### Remove vm linux and ***


```ps1
.\remove.ps1

Warning: This will delete everything inside RG-uks-temp-resources-001!
```
