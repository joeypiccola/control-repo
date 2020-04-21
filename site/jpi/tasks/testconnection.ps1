Param (
    [Parameter()]
    [string]$hostname,
    [int]$port,
    [switch]$erroronfail
)

$ErrorActionPreference = 'stop'

try {
    (New-Object Net.Sockets.TcpClient).Connect($hostname, $port)
    $test = $true
} catch {
    Write-Error "Unable to connect to $hostname on tcp\$port. Error: $($_.Exception.Message)."
}

Write-Output $test
