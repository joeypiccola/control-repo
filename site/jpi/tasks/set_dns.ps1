[CmdletBinding()]
Param(
    [Parameter(Mandatory = $true)]
    [IPAddress]$Primary,
    [Parameter(Mandatory = $false)]
    [IPAddress]$Secondary,
    [Parameter(Mandatory = $false)]
    [IPAddress]$Tertiary,
    [Parameter(Mandatory = $false)]
    [Boolean]$ProcessMultipleNICs
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
    $funcInterface = Get-WmiObject -Class 'Win32_NetworkAdapterConfiguration' | Where-Object {$_.Index -eq $InterfaceIndex}
    # set static, gateway, netmase an dns
    $funcInterface.SetDNSServerSearchOrder($ServerAddresses)
}

# build an empty array and only add provided DNS client server addresses by string to array (strings required by SetDNSServerSearchOrder method)
$ServerAddresses = @()
$primary, $secondary, $tertiary | Where-Object { $null -ne $_ } | ForEach-Object { $ServerAddresses += $_.IPAddressToString }

# get all NICs with IPs and DNS client server addresses
$activeNICs = Get-WmiObject -Class 'Win32_NetworkAdapterConfiguration'| Where-Object { ($null -ne $_.IPAddress) -and ($null -ne $_.DNSServerSearchOrder) }

# if we have a single NIC or ProcessMultipleNICs has been specified then proceed setting DNS client server addresses
if ( (($activeNICs | Measure-Object).count -eq 1) -or ($ProcessMultipleNICs) ) {
    foreach ($activeNIC in $activeNICs) {
        # try and set DNS client server addresses on the current active NIC
        try {
            # call set function. da heck is this #2 biz?! Best effort to maintain Server 08r2 backwards compatibility
            Set-DnsClientServerAddress2 -ServerAddresses $ServerAddresses -InterfaceIndex $activeNIC.Index
        } catch {
            Write-Error "Failed to set DNS client server addresses on Interface Index $($activeNIC.Index). Exception: $($_.Exception.Message)."
        }
    }
}
