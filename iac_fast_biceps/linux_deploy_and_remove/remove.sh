#!/bin/bash

# 1. Retrieve the Tenant ID from environment variables
# Note: In Linux/macOS, ensure you exported this: export t_id="your-id"
# --- 1. ENVIRONMENT CHECK ---
# We check once. If it's missing, we try to fix it. If we can't fix it, we exit.
if [[ -z "$t_id" ]]; then
    printf "${YELLOW}t_id not in environment. Checking ~/.bashrc...${NC}\n"

    t_id_backup=$(grep "export t_id=" ~/.bashrc | cut -d'=' -f2 | tr -d '"' | tr -d "'")

    if [[ -n "$t_id_backup" ]]; then
        export t_id="$t_id_backup"
        echo "Success: Recovered t_id from .bashrc"
    else
        printf "${RED}Error: Tenant ID not found. Run 'export t_id=...' and restart.${NC}\n"
        exit 1
    fi
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
