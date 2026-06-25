# Version: 1.4.0
# Scan an IIS log file and extract only the 404 errors for font and style assets.

Param (
    [string]$LogFilePath = "F:\Logs\W3SVC1\u_ex260623.log",
    [string]$OutputFilePath = "$Home\Desktop\iis_404_errors_only.txt"
)

# --- Configuration ---
$AssetPattern = "\.woff2|\.woff|\.css"
# ---------------------

Write-Host "Starting 404 isolation pipeline..."

# Verify if the target log file exists
if (-not (Test-Path -Path $LogFilePath -PathType Leaf)) {
    Write-Host "Found in these files : None" -ForegroundColor Red
    exit
}

Write-Host "Analyzing file: $LogFilePath" -ForegroundColor Cyan
Write-Host "Target output destination: $OutputFilePath" -ForegroundColor Cyan
Write-Host "--------------------------------------------------"

# Step 1: Get all lines matching font/css assets
$AssetMatches = Select-String -Path $LogFilePath -Pattern $AssetPattern

if ($AssetMatches) {
    # Step 2: Filter for HTTP status code 404
    # W3C standard format tracks status as 'sc-status sc-substatus sc-win32-status' (e.g., 404 0 0)
    $ErrorsOnly = $AssetMatches | Where-Object { $_.Line -match " 404 " }

    if ($ErrorsOnly) {
        $ErrorsOnly.Line | Out-File -FilePath $OutputFilePath -Encoding utf8
        Write-Host "Success! Exported $($ErrorsOnly.Count) font/CSS 404 error rows to your desktop." -ForegroundColor Green
    } else {
        Write-Host "Found in these files : None" -ForegroundColor Red
        Write-Host "No 404 errors found for font or style assets." -ForegroundColor Green
    }
} else {
    Write-Host "Found in these files : None" -ForegroundColor Red
}