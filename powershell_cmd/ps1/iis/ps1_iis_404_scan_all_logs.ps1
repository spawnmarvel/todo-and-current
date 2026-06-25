# Version: 1.5.0
# Scan the last 10 modified IIS log files to count 404 errors for font and style assets.

# --- Configuration ---
$LogDirectory = "F:\logs\W3SVC1"
$AssetPattern = "\.woff2|\.woff|\.css"
$FilesToScanCount = 100
# ---------------------

Write-Host "Starting multi-log statistical asset 404 scan pipeline..."

# Verify if the target log directory exists
if (-not (Test-Path -Path $LogDirectory)) {
    Write-Host "Directory not found: $LogDirectory" -ForegroundColor Red
    exit
}

# Fetch the last 10 modified log files in the directory
$LogFiles = Get-ChildItem -Path $LogDirectory -Filter "*.log" | 
            Sort-Object -Property LastWriteTime -Descending | 
            Select-Object -First $FilesToScanCount

if (-not $LogFiles) {
    Write-Host "Found in these files : None" -ForegroundColor Red
    exit
}

Write-Host "Matching asset pattern: $AssetPattern (Filtering for HTTP 404)" -ForegroundColor Cyan
Write-Host "Scanning the last $FilesToScanCount log files..." -ForegroundColor Cyan
Write-Host "------------------------------------------------------------------"

$StatisticsTable = @()
$TotalOverall404s = 0

# Process each log file one by one
foreach ($File in $LogFiles) {
    $MatchCount = 0
    
    # Scan the file for lines matching our asset extensions
    $AssetMatches = Select-String -Path $File.FullName -Pattern $AssetPattern
    
    if ($AssetMatches) {
        # Filter for the specific 404 pattern inside those asset matches
        $ErrorsOnly = $AssetMatches | Where-Object { $_.Line -match " 404 " }
        $MatchCount = $ErrorsOnly.Count
    }
    
    $TotalOverall404s += $MatchCount
    
    # Append data to the statistics matrix
    $StatisticsTable += [PSCustomObject]@{
        "Log File"      = $File.Name
        "Date Modified" = $File.LastWriteTime.ToString("yyyy-MM-dd HH:mm")
        "404 Count"     = $MatchCount
    }
}

# Output the compiled statistics into a clean text table
$StatisticsTable | Format-Table -AutoSize

Write-Host "------------------------------------------------------------------"
Write-Host "Total aggregate font/CSS 404 errors across all 10 logs: $TotalOverall404s" -ForegroundColor Green