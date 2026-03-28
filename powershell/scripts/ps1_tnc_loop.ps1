$test = @('remotehostname:80','remotehostname:9548','remotehostname:4561', 'remotehostname:4562')

Write-Output "Checking connectivity from: $($env:COMPUTERNAME)"
Write-Output "--------------------------------------------"

foreach ($t in $test) {
    # Splitting the string into Host and Port
    $parts = $t.Split(':')
    $source = $parts[0]
    $port   = [int]$parts[1]

    Write-Host "Connecting to $source on port $port..." -NoNewline

    try {
        # Using Test-NetConnection is the modern, "non-lazy" way 
        # It handles the socket creation and timeout logic for you
        $connection = Test-NetConnection -ComputerName $source -Port $port -WarningAction SilentlyContinue
        
        if ($connection.TcpTestSucceeded) {
            Write-Host " [SUCCESS]" -ForegroundColor Green
        } else {
            Write-Host " [FAILED]" -ForegroundColor Red
        }
    }
    catch {
        Write-Host " [ERROR]" -ForegroundColor Yellow
        Write-Warning $_.Exception.Message
    }
}