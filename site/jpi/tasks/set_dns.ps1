[CmdletBinding()]
Param(
    [Parameter(Mandatory = $true)]
    [IPAddress]$primary,
    [Parameter(Mandatory = $false)]
    [IPAddress]$secondary,
    [Parameter(Mandatory = $false)]
    [IPAddress]$tertiary
)

# define pref vars
$ErrorActionPreference = 'Stop'
$WarningPreference = 'Continue'

# define helper functions
function Set-DnsClientServerAddress2 {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [IPAddress[]]$ServerAddresses,
        [Parameter(Mandatory = $true)]
        [Int]$InterfaceIndex
    )
    # get the NIC via the provided index
    $activeNIC = Get-WmiObject -Class 'Win32_NetworkAdapterConfiguration' | Where-Object {$_.Index -eq $InterfaceIndex}
    # set static, gateway, netmase an dns
    $activeNIC.SetDNSServerSearchOrder($ServerAddresses)
}

# build an empty array and only add provided DNS client server addresses by string to array
$ServerAddresses = @()
$primary, $secondary, $tertiary | Where-Object { $null -ne $_ } | ForEach-Object { $ServerAddresses += $_.IPAddressToString }

# find all the NICs with default gateway IPs (best effort logic to determine primary adapter)
$DefaultIPGatewayNICs = Get-WmiObject -Class 'Win32_NetworkAdapterConfiguration' | Where-Object {$_.DefaultIPGateway -ne $null}

# switch out depending on how many NICs with default gateway IPs were found
switch (($DefaultIPGatewayNICs | Measure-Object).count) {
    '0' {
        Write-Error 'No NICs found with default gateways IPs.'
    }
    '1' {
        # for the single NIC detected as having a default gateway check to see if it currenlty has DNS servers set
        if ($null -ne $DefaultIPGatewayNICs.DNSServerSearchOrder) {
            # try and set DNS client server addresses on the single NIC detected as having a default gateway
            try {
                # call set function. da heck is this #2 biz?! Best effort to maintain Server 08r2 backwards compatibility
                Set-DnsClientServerAddress2 -ServerAddresses $ServerAddresses -InterfaceIndex $DefaultIPGatewayNICs.Index
            } catch {
                Write-Error "Failed to set DNS client server addresses on Interface Index $($DefaultIPGatewayNICs.Index). Exception: $($_.Exception.Message)."
            }
        } else {
            Write-Error "Existing client DNS server settings not detected. No action taken."
        }
    }
    {$_ -gt 1} {
        Write-Error 'More than one NIC found with default gateway IPs.'
    }
}
