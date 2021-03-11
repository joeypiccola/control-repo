
[CmdletBinding()]
Param (
    [Parameter(Mandatory)]
    [string]$username,
    [Parameter(Mandatory)]
    [string]$password,
    [Parameter(Mandatory)]
    [string]$vcenter
)


$username = 'svc_vmware@ad.piccola.us'
$password = 'Catz&Dogs1234'
$vcenter  = 'vcenter.ad.piccola.us'

[securestring]$secStringPassword = ConvertTo-SecureString $password -AsPlainText -Force
[pscredential]$credObject = New-Object System.Management.Automation.PSCredential ($username, $secStringPassword)


$mods = ('VMware.VimAutomation.Cis.Core','VMware.VimAutomation.Common','VMware.VimAutomation.Core','VMware.VimAutomation.Sdk')
Import-Module $mods

$pcli = Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -ParticipateInCeip:$false -Scope AllUsers -Confirm:$false -DisplayDeprecationWarnings:$false
$connectcli = Connect-VIServer -Server $vcenter -Credential $credObject
get-vm | select -ExpandProperty name | ConvertTo-Json
$disconnectcli = Disconnect-VIServer -Confirm:$false -Force
