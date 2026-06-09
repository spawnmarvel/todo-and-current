# Version 1.0.4 - POST request with authentication
# This script sends a POST request with XML data

$baseUrl  = "https://server.domain.com/LudoExplorer/LudoData/LudoYourDataREST.dll/HistoryFunction?"

# The XML request
$xmlRequest = '<Q f="D" allQuotes="1"><Tag><N><![CDATA[LIM-TAG]]></N><D><![CDATA[LIM]]></D><F><![CDATA[VAL]]></F><HF>0</HF><St>1777442973000</St><Et>1777446573000</Et><RT>0</RT><X>1000</X><O>1</O></Tag></Q>'

# Prompt for credentials
$cred = Get-Credential

Write-Host "Connecting to: $baseUrl" -ForegroundColor Cyan

try {
    # Send POST request with XML body
    $result = Invoke-RestMethod `
        -Uri $baseUrl `
        -Method Post `
        -Credential $cred `
        -Body $xmlRequest `
        -ContentType "application/xml"

    Write-Host "Result Received:" -ForegroundColor Green
    $result | Format-List
}
catch {
    Write-Host "Error: Could not retrieve data." -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
}