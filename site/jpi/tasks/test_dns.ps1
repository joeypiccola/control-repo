Param(
    [Parameter(Mandatory = $true)]
    [IPAddress]$nameserverip,
    [Parameter(Mandatory = $true)]
    [string]$querystring
)

$ErrorActionPreference = 'stop'

if ($host.Version.Major -gt 2) {
    try {
        Resolve-DnsName -NoHostsFile -Name $client -Server $nameserver | Select-Object -Property name, ipaddress | ConvertTo-Json
    } catch {
        Write-Error "Failed to query `"$client`" via name server `"$nameserver`". Error: $($_.Exception.Message)."
    }
} else {
    $errFile = 'C:\Windows\Temp\test_dns_err'
    $outFile = 'C:\Windows\Temp\test_dns_our'
    $spSplat = @{
        Wait                   = $true
        PassThru               = $true
        FilePath               = 'C:\Windows\System32\nslookup.exe'
        ArgumentList           = @($client,$nameserver)
        RedirectStandardError  = $errFile
        RedirectStandardOutput = $outFile
    }

    # try and 1) run nslookup, 2) write err/out to file, 3) get the files' contents and 4) remove the files
    try {
        $spResults = Start-Process @spSplat
        $errFileContent = Get-Content -Path $errFile
        $outFileContent = Get-Content -Path $outFile
    } catch {
        Write-Error $_.Exception.Message
    } finally {
        if (Test-Path -Path $errFile) {
            Remove-Item -Path $errFile
        }
        if (Test-Path -Path $outFile) {
            Remove-Item -Path $outFile
        }
    }
    # eval the results of the errFile and error accordingly
    try {
        if ($errFileContent -match 'Non-existent domain') {
            Write-Error 'Non-existent domain'
        } elseif ($errFileContent -match 'Request to UnKnown timed-out') {
            Write-Error 'Request to UnKnown timed-out'
        } else {
            Write-Output $outFileContent
        }
    } catch {
        Write-Error "Failed to query `"$client`" via name server `"$nameserver`". Error: $($_.Exception.Message)."
    }
}
