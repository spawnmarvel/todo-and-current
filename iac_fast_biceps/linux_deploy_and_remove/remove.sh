#!/bin/bash

# 1. Retrieve the Tenant ID
if [ -z "$t_id" ]; then
    echo "Error: Tenant ID (t_id) not found in environment variables."
    exit 1
fi

# 2. Connect
az login --tenant "$t_id" --output none

# 3. Define the target
RG_NAME="RG-uks-temp-resources-001"

# 4. Remove the Resource Group and everything inside it
# Using --no-wait makes it behave like PowerShell's -AsJob
echo -e "\033[0;31mWarning: This will delete everything inside $RG_NAME!\033[0m"

az group delete --name "$RG_NAME" --yes --no-wait

echo -e "\033[0;32mThe Resource Group $RG_NAME has been scheduled for deletion.\033[0m"
echo "You can check the progress with: az group show --name $RG_NAME"
