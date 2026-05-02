# 1. Retrieve the Tenant ID
$t_id = [System.Environment]::GetEnvironmentVariable("t_id", "User")

if ([string]::IsNullOrEmpty($t_id)) {
    Write-Error "Tenant ID (t_id) not found in environment variables."
    return
}

# Toggle this: $true for dry run, $false for real deployment
$WhatIfMode = $false 

# 2. Connect
Connect-AzAccount -TenantId $t_id

# 3. Define Variables
$rgName = "RG-swc-temp-resources-001"
$location = "swedencentral"
$templatePath = ".\main.bicep"
$vmName = "vm-swc-temp-001"

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

# 5. Execute Deployment or What-If
if ($WhatIfMode) {
    Write-Host "Running What-If analysis..." -ForegroundColor Yellow
    New-AzResourceGroupDeployment `
        -ResourceGroupName $rgName `
        -TemplateFile $templatePath `
        -WhatIf
} else {
    Write-Host "Starting actual deployment..." -ForegroundColor Cyan
    $deployment = New-AzResourceGroupDeployment `
        -ResourceGroupName $rgName `
        -TemplateFile $templatePath

    # 6. Print Public IP only if we deployed
    Write-Host "Deployment complete! Fetching Public IP..." -ForegroundColor Green
    $pip = Get-AzPublicIpAddress -ResourceGroupName $rgName -Name "${vmName}-pip"
    $ipAddress = $pip.IpAddress

    Write-Host "`n==========================================" -ForegroundColor Yellow
    Write-Host "VM: $vmName"
    Write-Host "Public IP: $ipAddress" -ForegroundColor Cyan
    Write-Host "SSH: ssh username@$ipAddress"
    Write-Host "==========================================" -ForegroundColor Yellow
}