# Define file paths

# inputfile example
# LAB-198-AT  -E1221
# LAB-198-AT  -E2221

# and taglist_mapping.xml
#
# <TagListMapping xmlns="http://schemas.datacontract.org/2004/07/GOD.DataBridge.Common" xmlns:i="http://www.w3.org/2001/XMLSchema-instance">
#    <EnableMapping>true</EnableMapping>
#    <TagMappingList>
#        <TagMapping>
#            <Src>LAB-198-AT-E1221/DIM</Src>
#            <Tar>LAB-198-AT  -E1221</Tar>
#        </TagMapping>
#        <TagMapping>
#            <Src>LAB-198-AT-E2221/DIM</Src>
#            <Tar>LAB-198-AT  -E2221</Tar>
#        </TagMapping>
#    </TagMappingList>
#</TagListMapping>

$inputFile  = "input_tags.txt"        # Your input tag list
$xmlFile    = "DEV.Datab.Conn.IO.AService_TagListMapping.xml"  # Your XML file
$outputFile = "matched_tags.txt"

# Load XML
[xml]$xmlContent = Get-Content $xmlFile

# Create Namespace Manager
$nsMgr = New-Object System.Xml.XmlNamespaceManager($xmlContent.NameTable)
$nsMgr.AddNamespace("ns", "http://schemas.datacontract.org/2004/07/GOD.DataBridge.Common")

# Get all TagMapping nodes
$tagMappings = $xmlContent.SelectNodes("//ns:TagMapping", $nsMgr)

# Read input tags
$tags = Get-Content $inputFile

$output = @()
$foundCount = 0

foreach ($tag in $tags) {
    $trimmedTag = ($tag -replace '\s+', ' ').Trim()  # normalize spaces

    # Find match ignoring case and space differences
    $matchingNode = $tagMappings | Where-Object {
        (($_.SelectSingleNode("ns:Tar", $nsMgr).InnerText -replace '\s+', ' ').Trim()) -ieq $trimmedTag
    }

    if ($matchingNode) {
        $srcValue = $matchingNode.SelectSingleNode("ns:Src", $nsMgr).InnerText
        $output += "$trimmedTag; $srcValue"
        $foundCount++
    }
    else {
        $output += "$trimmedTag; not found in src"
    }
}

# Write output file
$output | Set-Content $outputFile

# Summary
Write-Host "Done! Matches written to $outputFile"
Write-Host "Found: $foundCount of $($tags.Count) tags."
if ($foundCount -eq $tags.Count) {
    Write-Host "✅ All input tags were found!"
} else {
    Write-Host "❌ Some tags were not found."
}