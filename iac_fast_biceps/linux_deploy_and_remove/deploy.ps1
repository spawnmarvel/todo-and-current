# 1. Retrieve the Tenant ID
$t_id = [System.Environment]::GetEnvironmentVariable("t_id", "User")

if ([string]::IsNullOrEmpty($t_id)) {
    Write-Error "Tenant ID (t_id) not found in environment variables."
    return
}

# 2. Connect
Connect-AzAccount -TenantId $t_id

# 3. Define Variables
$rgName = "RG-uks-temp-resources-001"
$location = "uksouth"
$templatePath = ".\main.bicep"

# 4. Create Resource Group if it doesn't exist
Write-Host "Checking for Resource Group: $rgName..." -ForegroundColor Cyan
$existingRg = Get-AzResourceGroup -Name $rgName -ErrorAction SilentlyContinue

if ($null -eq $existingRg) {
    Write-Host "Resource Group not found. Creating it now in $location..." -ForegroundColor Yellow
    New-AzResourceGroup -Name $rgName -Location $location
    
    Write-Host "Waiting 60 seconds for Azure replication..." -ForegroundColor Gray
    Start-Sleep -Seconds 60
} else {
    Write-Host "Resource Group already exists." -ForegroundColor Green
}

# 5. Run the What-If Analysis
Write-Host "Running What-If analysis..." -ForegroundColor Yellow

New-AzResourceGroupDeployment `
    -ResourceGroupName $rgName `
    -TemplateFile $templatePath `
    # -WhatIf

# 5. Confirmation (Optional)
# If the What-If output looks good, you can then run the command 
# again WITHOUT the -WhatIf switch to actually deploy.