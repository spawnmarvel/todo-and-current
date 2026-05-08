# Version: 1.0.5
# Kerberos-forced POST request with XML data

$baseUrl = "https://server.domain.com/LudoExplorer/LudoData/LudoYourDataREST.dll/HistoryFunction?"

# The XML request
$xmlRequest = '<Q f="D" allQuotes="1"><Tag><N><![CDATA[LIM-TAG]]></N><D><![CDATA[LIM]]></D><F><![CDATA[VAL]]></F><HF>0</HF><St>1777442973000</St><Et>1777446573000</Et><RT>0</RT><X>1000</X><O>1</O></Tag></Q>'

Write-Host "Connecting to: $baseUrl"

try {
    # Note: Kerberos works best with -UseDefaultCredentials. 
    # If the Tentacle/User is logged in, this is the preferred method.
    
    $result = Invoke-RestMethod `
        -Uri $baseUrl `
        -Method Post `
        -UseDefaultCredentials `
        -Body $xmlRequest `
        -ContentType "application/xml"

    Write-Host "Result Received:"
    $result | Format-List
}
catch {
    Write-Host "Error: Could not retrieve data."
    Write-Host $_.Exception.Message
}