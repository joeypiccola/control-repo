$Win32_ComputerSystem = Get-WmiObject -Class Win32_ComputerSystem
if ($Win32_ComputerSystem.PartOfDomain) {
    Write-Output "win_domain=$($Win32_ComputerSystem.domain)"
} else {
    Write-Output 'win_domain=workgroup'
}