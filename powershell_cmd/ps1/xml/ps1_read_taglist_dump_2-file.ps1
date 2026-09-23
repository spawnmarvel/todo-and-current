# Input and output files
$xmlFile = "C:\temp2\xml\taglist_lima_lab.xml"
$outputFile = "C:\temp2\xml\taglist_lima_lab.txt"

[xml]$xml = Get-Content $xmlFile

$tagNames = $xml.GetElementsByTagName("TagName") | ForEach-Object {
    $_.InnerText
}

$tagNames | Set-Content $outputFile

Write-Host "Total tags written: $($tagNames.Count)"