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
}

if ($erroronfail) {
    Write-Error "Unable to connect to $hostname on tcp\$port."
} else {
    Write-Output $test
}
