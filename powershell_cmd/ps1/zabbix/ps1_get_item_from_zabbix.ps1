# Version 1.0.0
# Authenticates to Zabbix API and retrieves the latest value for a specific host item.

[CmdletBinding()]
param (
    [string]$ZabbixUrl = "https://server/zabbix/api_jsonrpc.php",
    [string]$Username  = "name",
    [string]$Password  = "password",
    [string]$HostName  = "myhost",
    [string]$ItemKey   = "http.history.check.pla"
)

# Suppress SSL certificate validation if using self-signed certs (HTTPS)
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}

# 1. Authenticate to Zabbix API
$authBody = @{
    jsonrpc = "2.0"
    method  = "user.login"
    params  = @{
        username = $Username
        password = $Password
    }
    id      = 1
} | ConvertTo-Json

try {
    $authResponse = Invoke-RestMethod -Uri "$ZabbixUrl/api_jsonrpc.php" -Method Post -ContentType "application/json" -Body $authBody
    if ($authResponse.error) {
        Write-Output "Authentication Failed: $($authResponse.error.data)"
        return
    }
    $authToken = $authResponse.result
    Write-Output "Successfully authenticated to Zabbix API."
}
catch {
    Write-Output "Failed to connect to Zabbix API: $_"
    return
}

# 2. Get Item Details and Latest Value
$itemBody = @{
    jsonrpc = "2.0"
    method  = "item.get"
    params  = @{
        output     = @("itemid", "name", "key_", "lastvalue", "lastclock")
        selectHosts = @("host")
        filter     = @{
            host = $HostName
            key_ = $ItemKey
        }
    }
    auth    = $authToken
    id      = 2
} | ConvertTo-Json -Depth 4

try {
    $itemResponse = Invoke-RestMethod -Uri "$ZabbixUrl/api_jsonrpc.php" -Method Post -ContentType "application/json" -Body $itemBody
    
    if ($itemResponse.result.Count -gt 0) {
        $item = $itemResponse.result[0]
        $lastCheck = ([DateTimeOffset]::FromUnixTimeSeconds([long]$item.lastclock)).LocalDateTime
        
        Write-Output "--------------------------------------------------"
        Write-Output "Host:       $HostName"
        Write-Output "Item Name:  $($item.name)"
        Write-Output "Item Key:   $($item.key_)"
        Write-Output "Last Value: $($item.lastvalue)"
        Write-Output "Last Check: $lastCheck"
        Write-Output "--------------------------------------------------"
    }
    else {
        Write-Output "No item found for Host '$HostName' with Key '$ItemKey'."
    }
}
catch {
    Write-Output "Error querying item data: $_"
}
finally {
    # 3. Logout API Session
    if ($authToken) {
        $logoutBody = @{
            jsonrpc = "2.0"
            method  = "user.logout"
            params  = @()
            auth    = $authToken
            id      = 3
        } | ConvertTo-Json

        $null = Invoke-RestMethod -Uri "$ZabbixUrl/api_jsonrpc.php" -Method Post -ContentType "application/json" -Body $logoutBody
    }
}