$folderPath = "C:\Path\To\Your\Folder"
$searchTerm = "moving"

# 1. Get the files
$files = Get-ChildItem -Path $folderPath -Filter *.xml
$totalSearched = $files.Count
$foundFiles = New-Object System.Collections.Generic.List[string]

Write-Host "Starting search in $folderPath...`n" -ForegroundColor Cyan

# 2. Loop through and check each file
foreach ($file in $files) {
    if (Select-String -Path $file.FullName -Pattern $searchTerm -Quiet) {
        # Prints matching file in Green
        Write-Host "[MATCH] $($file.Name)" -ForegroundColor Green
        $foundFiles.Add($file.Name)
    } else {
        # Prints non-matching file in Gray (similar to previous scripts)
        Write-Host "[NO MATCH ] $($file.Name)" -ForegroundColor Gray
    }
}

# 3. Final Summary Report
Write-Host "`n==========================================" -ForegroundColor Yellow
Write-Host "              SEARCH SUMMARY              " -ForegroundColor White
Write-Host "==========================================" -ForegroundColor Yellow
Write-Host "Total Files Searched : $totalSearched"
Write-Host "Total Matches Found  : $($foundFiles.Count)" -ForegroundColor Green

if ($foundFiles.Count -gt 0) {
    Write-Host "Found in these files :" -ForegroundColor White
    foreach ($name in $foundFiles) {
        Write-Host "   - $name" -ForegroundColor Cyan
    }
} else {
    Write-Host "Found in these files : None" -ForegroundColor Red
}

Write-Host "==========================================`n" -ForegroundColor Yellow