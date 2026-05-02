# 1. Retrieve the Tenant ID
$t_id = [System.Environment]::GetEnvironmentVariable("t_id", "User")

# 2. Connect (if not already connected)
Connect-AzAccount -TenantId $t_id -ErrorAction SilentlyContinue

# 3. Define the target
$rgName = "RG-swc-temp-resources-001"

# 4. Remove the Resource Group and everything inside it
Write-Host "Warning: This will delete everything inside $rgName!" -ForegroundColor Red

Remove-AzResourceGroup -Name $rgName -Force
# Add -AsJob to the line above if you don't want to wait for it to finish.

Write-Host "The Resource Group $rgName has been scheduled for deletion." -ForegroundColor Green