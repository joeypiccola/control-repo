[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseConsistentWhitespace", "", Justification = "just can't fix this")]
[CmdletBinding()]
Param()

# get the domain role of the machine
$DomainRole = (Get-WmiObject -Class Win32_ComputerSystem -Property DomainRole).DomainRole
# if the machine is not a Standalone Workstation or a Standalone Server then attempt to query ad
if ($DomainRole -notmatch '^(0|2)') {
    # query ad
    $directorySearcher = New-Object System.DirectoryServices.DirectorySearcher
    $directorySearcher.Filter = "(&(objectCategory=Computer)(Name=$env:ComputerName))"
    $searcherPath = $directorySearcher.FindOne()
    $getDirectoryEntry = $searcherPath.GetDirectoryEntry()

    # make the results pretty
    $dn = $getDirectoryEntry.distinguishedName.tostring() # <-- psv2 requires the tostring()
    $compobj = [PSCustomObject]@{
        dn           = $getDirectoryEntry.distinguishedName.ToString().ToLower()
        ou           = $dn.substring(($dn.split(',')[0].length + 1), ($dn.Length - ($dn.split(',')[0].length + 1))).ToLower()
        whenCreated  = $getDirectoryEntry.whenCreated.ToString()
        whenChanged  = $getDirectoryEntry.whenChanged.ToString()
        site         = [System.DirectoryServices.ActiveDirectory.ActiveDirectorySite]::GetComputerSite().Name.ToLower()
        outputMethod = $host.Version.Major
    }
    $adobj = [PSCustomObject]@{
        activedirectory_meta = $compobj
    }

    # write out structured data in a way that works on PSv2-*
    if ($host.Version.Major -gt 2) {
        Write-Output ($adobj | ConvertTo-Json)
    } else {
        Write-Output "{`"activedirectory_meta`": {`"dn`": `"$($compobj.dn)`",`"ou`": `"$($compobj.ou)`",`"whenCreated`": `"$($compobj.whenCreated)`",`"whenChanged`": `"$($compobj.whenChanged)`",`"site`": `"$($compobj.site)`",`"outputMethod`": `"$($compobj.outputMethod)`"}}"
    }
}
