Param(
    [Parameter(Mandatory = $true)]
    [IPAddress]$nameserverip,
    [Parameter(Mandatory = $true)]
    [string]$querystring
)

$ErrorActionPreference = 'stop'

$osVersion = [System.Environment]::OSVersion.Version
if ([version]$osVersion -ge [version]'6.3' ) {
    try {
        Resolve-DnsName -NoHostsFile -Name $querystring -Server $nameserverip | Select-Object -Property name, ipaddress | ConvertTo-Json
    } catch {
        Write-Error "Failed to query `"$querystring`" via name server `"$nameserverip`". Error: $($_.Exception.Message)."
    }
} else {
    $errFile = 'C:\Windows\Temp\test_dns_err'
    $outFile = 'C:\Windows\Temp\test_dns_out'
    $spSplat = @{
        Wait                   = $true
        PassThru               = $true
        FilePath               = 'C:\Windows\System32\nslookup.exe'
        ArgumentList           = @($querystring,$nameserverip)
        RedirectStandardError  = $errFile
        RedirectStandardOutput = $outFile
    }

    # try and 1) run nslookup, 2) write err/out to file, 3) get the files' contents and 4) remove the files
    try {
        $spResults = Start-Process @spSplat
        Start-Sleep -Seconds 2
        $errFileContent = Get-Content -Path $errFile
        $outFileContent = Get-Content -Path $outFile
        Start-Sleep -Seconds 2
    } catch {
        Write-Error $_.Exception.Message
    } finally {
        Start-Sleep -Seconds 2
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
        Write-Error "Failed to query `"$querystring`" via name server `"$nameserverip`". Error: $($_.Exception.Message)."
    }
}
