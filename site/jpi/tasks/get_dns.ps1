# define pref vars
$ErrorActionPreference = 'Stop'
$WarningPreference = 'Continue'

# find all the NICs with default gateway IPs (best effort logic to determine primary adapter)
$DefaultIPGatewayNICs = Get-WmiObject -Class 'Win32_NetworkAdapterConfiguration' | Where-Object {$_.DefaultIPGateway -ne $null}

# switch out depending on how many NICs with default gateway IPs were found
switch (($DefaultIPGatewayNICs | Measure-Object).count) {
    '0' {
        Write-Error 'No NICs found with default gateways IPs.'
    }
    '1' {
        if ($null -ne $DefaultIPGatewayNICs.DNSServerSearchOrder) {
            if ($host.Version.Major -gt 2) {
                $DefaultIPGatewayNICs.DNSServerSearchOrder | ConvertTo-Json
            } else {
                $DefaultIPGatewayNICs.DNSServerSearchOrder
            }
        } else {
            Write-Error "Existing client DNS server settings not detected."
        }
    }
    {$_ -gt 1} {
        Write-Error 'More than one NIC found with default gateway IPs.'
    }
}
