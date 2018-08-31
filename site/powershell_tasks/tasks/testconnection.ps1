[CmdletBinding()]
Param (
    [Parameter()]
    [string]$hostname,
    [int]$port
)

try {
    (New-Object Net.Sockets.TcpClient).Connect($hostname, $port)
    $test = $true
} catch {
    $test = $false
}

Write-Output $test