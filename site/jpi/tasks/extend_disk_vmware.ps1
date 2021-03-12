[CmdletBinding()]
Param (
    [Parameter(Mandatory)]
    [string]$username,
    [Parameter(Mandatory)]
    [string]$password,
    [Parameter(Mandatory)]
    [string]$vcenter,
    [Parameter(Mandatory)]
    [string]$target_node,
    [Parameter(Mandatory)]
    [ValidateRange(1,100)]
    [int]$gb_to_add
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

# validate the vm and do stuff

# split the passed name into hostname only
$vm = Get-VM -Name $target_node.Split('.')[0] -ErrorAction Stop
# if a vm was found ensure passed FQDN matches hostname known by VMware Tools
if ($vm.Guest.HostName -eq $target_node) {
    # hacky AF, lets just get a functional demo before we spend hours finding a way to validate guest OS disk matches vmware disk (FML)
    $diskToExtend = $vm | Get-HardDisk | Select-Object -Last 1
    $diskToExtend | Set-HardDisk -CapacityGB ($diskToExtend.CapacityGB + $gb_to_add)

} else {
    Write-Error "VM found for $target_node does not match VMware guest hostname of $($vm.Guest.HostName)."
}

# disconnect from vmware
Disconnect-VIServer -Confirm:$false -Force | Out-Null
