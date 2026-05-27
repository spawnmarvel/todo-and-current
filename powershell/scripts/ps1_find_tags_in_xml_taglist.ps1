## Version: 1.3.0
# Uses explicit XPath navigation to robustly locate TagName elements regardless of XML root schemas.

# Define file paths

# Inputfile example
# LAB-198-AT  -E1221
# LAB-198-AT  -E2221

# and taglist_mapping.xml
#
# TagListConfiguration xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
#  <SubScriptionList>
#    <SubscriptionConfiguration>
#      <Tags>
#        <Tag>
#          <Active>true</Active>
#          <TagName>LAB-ZLL-237</TagName>
#        </Tag>
#        <Tag>
#          <Active>true</Active>
#          <TagName>LAB-ZLL-119</TagName>
#        </Tag>
#      </Tags>
#      <Name>Util_Analog_50</Name>
#      <Active>true</Active>
#      <UpdateRate>50000</UpdateRate>
#      <FromDate>0001-01-01T00:00:00</FromDate>
#      <ToDate>9999-12-31T23:59:59.9999999</ToDate>
#    </SubscriptionConfiguration>
#  </SubScriptionList>
# </TagListConfiguration>



$inputFile  = "C:\Users\lima\input_tags.txt"        # Your input tag list
$xmlFile    = "C:\Users\lima\lima.Databridge.Connector.IO.WinService_TagList.xml"  # Your XML file
$outputFile = "C:\Users\lima\matched_tags.txt"

# Load XML
[xml]$xmlContent = Get-Content $xmlFile

# Read input tags
$tags_input = Get-Content $inputFile

$output = @()
$foundCount = 0

foreach ($tagLine in $tags_input) {
    # Skip empty lines
    if ([string]::IsNullOrWhiteSpace($tagLine)) { continue }
    
    # Normalize spaces for the input tag
    $trimmedTag = ($tagLine -replace '\s+', ' ').Trim()

    # Use robust XPath lookup to find the specific TagName text
    # This searches any <TagName> node anywhere in the document
    $matchingNode = $xmlContent.SelectSingleNode("//TagName[normalize-space(text())='$trimmedTag']")

    if ($matchingNode) {
        $srcValue = $matchingNode.InnerText.Trim()
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
Write-Host "Found: $foundCount of $($tags_input.Count) tags."
if ($foundCount -eq $tags_input.Count) {
    Write-Host "All input tags were found!"
} else {
    Write-Host "Some tags were not found."
}