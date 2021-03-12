
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

# secure creds
[securestring]$secStringPassword = ConvertTo-SecureString $password -AsPlainText -Force
[pscredential]$credObject = New-Object System.Management.Automation.PSCredential ($username, $secStringPassword)
# load mods
$mods = ('VMware.VimAutomation.Cis.Core','VMware.VimAutomation.Common','VMware.VimAutomation.Core','VMware.VimAutomation.Sdk')
Import-Module $mods | Out-Null
# connect to vmware
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -ParticipateInCeip:$false -Scope AllUsers -Confirm:$false -DisplayDeprecationWarnings:$false | Out-Null
Connect-VIServer -Server $vcenter -Credential $credObject | Out-Null

# validate the vm

# split the passed name into hostname only
$vm = Get-VM -Name $target_node.Split('.')[0] -ErrorAction Stop
# if a vm was found ensure passed FQDN matches hostname known by VMware Tools
if ($vm.Guest.HostName -eq $system) {
    $vm | Select-Object -Property name, powerstate, guest, vmhost, memorygb, numcpu, folder, resourcepool, version | ConvertTo-Json -Depth 1
} else {
    Write-Error "VM found for $target_name does not match VMware guest hostname of $($vm.Guest.HostName)."
}

# disconnect from vmware
Disconnect-VIServer -Confirm:$false -Force | Out-Null
