# Version: 1.0
# Description: Searches for a specific text pattern inside all .txt files within a target directory and lists the results.

$folderPath = "C:\Path\To\Your\Folder"
$searchTerm = "moving"

# 1. Get the files
$files = Get-ChildItem -Path $folderPath -Filter *.txt
$totalSearched = $files.Count
$foundFiles = New-Object System.Collections.Generic.List[string]

Write-Host "Starting search in $folderPath...`n"

# 2. Loop through and check each file
foreach ($file in $files) {
    if (Select-String -Path $file.FullName -Pattern $searchTerm -Quiet) {
        Write-Host "[MATCH] $($file.Name)"
        $foundFiles.Add($file.Name)
    }
    else {
        Write-Host "[NO MATCH ] $($file.Name)"
    }
}

# 3. Final Summary Report
Write-Host "`n=========================================="
Write-Host "              SEARCH SUMMARY              "
Write-Host "=========================================="
Write-Host "Total Files Searched : $totalSearched"
Write-Host "Total Matches Found  : $($foundFiles.Count)"

if ($foundFiles.Count -gt 0) {
    Write-Host "Found in these files :"
    foreach ($name in $foundFiles) {
        Write-Host "   - $name"
    }
}
else {
    Write-Host "Found in these files : None"
}

Write-Host "==========================================`n"