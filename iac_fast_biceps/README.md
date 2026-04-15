# Deploy resources fast

Continue from Azure Automation bicep and labs

https://github.com/spawnmarvel/azure-automation-bicep-and-labs/blob/main/README.md


## Deploy Linux vm with public ip into exissting vnet

This is just for fast deploy and remove.

### Deploy vm
Template and script for vm in ./linux_deploy_and_remove

💠 Store Tenant ID in Environment Varibles-> User variables

💠t_id =

💠 Login Azure with ps1

```ps1
# Get the id
$t_id =[System.Environment]::GetEnvironmentVariable("t_id", "User")
# connect
connect-AzAccount -TenantId $t_id
# [...]
# Deploy resources
```

### Remove the deployd vm and resource group
