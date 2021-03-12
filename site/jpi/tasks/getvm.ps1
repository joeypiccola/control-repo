
[CmdletBinding()]
Param (
    [Parameter(Mandatory)]
    [string]$username,
    [Parameter(Mandatory)]
    [string]$password,
    [Parameter(Mandatory)]
    [string]$vcenter,
    [Parameter(Mandatory)]
    [string]$target_node
)

[securestring]$secStringPassword = ConvertTo-SecureString $password -AsPlainText -Force
[pscredential]$credObject = New-Object System.Management.Automation.PSCredential ($username, $secStringPassword)

$mods = ('VMware.VimAutomation.Cis.Core','VMware.VimAutomation.Common','VMware.VimAutomation.Core','VMware.VimAutomation.Sdk')
Import-Module $mods | Out-Null

Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -ParticipateInCeip:$false -Scope AllUsers -Confirm:$false -DisplayDeprecationWarnings:$false | Out-Null
Connect-VIServer -Server $vcenter -Credential $credObject | Out-Null
Get-VM $target_node | Select-Object -Property name, powerstate, guest, vmhost, memorygb, numcpu, folder, resourcepool, version | ConvertTo-Json -Depth 1
Disconnect-VIServer -Confirm:$false -Force | Out-Null
