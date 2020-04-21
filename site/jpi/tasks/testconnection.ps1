[CmdletBinding()]
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
    $test = $false
    $errorVar = $_.Exception.Message
}

if (($erroronfail) -and ($test -eq $false)) {
    Write-Error "Unable to connect to $hostname on tcp\$port. Error: $errorVar."
} else {
    Write-Output $test
}
