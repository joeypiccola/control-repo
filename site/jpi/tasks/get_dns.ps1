# define pref vars
$ErrorActionPreference = 'Stop'
$WarningPreference     = 'Continue'
$VerbosePreference     = 'Continue'

# get all NICs with IPs and DNS client server addresses
$activeNICs = Get-WmiObject -Class 'Win32_NetworkAdapterConfiguration'| Where-Object { ($null -ne $_.IPAddress) -and ($null -ne $_.DNSServerSearchOrder) }
# write out data on found NICs. JSON where we can :(
if ($host.Version.Major -gt 2) {
    $activeNICs | Select-Object -Property Index, IPAddress, DNSServerSearchOrder, MACAddress | ConvertTo-Json
} else {
    $activeNICs | Format-Table -Property Index, IPAddress, DNSServerSearchOrder, MACAddress -AutoSize | Out-String -Width 4096
}
