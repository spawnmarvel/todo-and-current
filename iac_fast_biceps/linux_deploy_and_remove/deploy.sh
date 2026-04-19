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

# Toggle this: true for dry run, false for real deployment
WHAT_IF_MODE=false

# 2. Connect
# This will open a browser or use existing cached credentials
az login --tenant "$t_id" --output none

# 3. Define Variables
RG_NAME="RG-uks-temp-resources-001"
LOCATION="uksouth"
TEMPLATE_PATH="./main.bicep"
VM_NAME="vm-uks-temp-001"

# 4. Create Resource Group if it doesn't exist
echo "Checking for Resource Group: $RG_NAME..."
RG_EXISTS=$(az group exists --name "$RG_NAME")

if [ "$RG_EXISTS" = "false" ]; then
    echo "Resource Group not found. Creating it now in $LOCATION..."
    az group create --name "$RG_NAME" --location "$LOCATION" --output none

    echo "Waiting 60 seconds for Azure replication..."
    sleep 60
else
    echo "Resource Group already exists."
fi

# 5. Execute Deployment or What-If
if [ "$WHAT_IF_MODE" = true ]; then
    echo "Running What-If analysis..."
    az deployment group what-if \
        --resource-group "$RG_NAME" \
        --template-file "$TEMPLATE_PATH"
else
    echo "Starting actual deployment..."
    # The CLI will prompt for adminUsername and adminPassword if not provided
    az deployment group create \
        --resource-group "$RG_NAME" \
        --template-file "$TEMPLATE_PATH" \
        --output none

    # 6. Print Public IP only if we deployed
    echo "Deployment complete! Fetching Public IP..."
    IP_ADDRESS=$(az network public-ip show \
        --resource-group "$RG_NAME" \
        --name "${VM_NAME}-pip" \
        --query "ipAddress" \
        --output tsv)

    echo -e "\n=========================================="
    echo "VM: $VM_NAME"
    echo -e "Public IP: \033[0;36m$IP_ADDRESS\033[0m"
    echo "SSH: ssh username@$IP_ADDRESS"
    echo -e "==========================================\n"
fi
