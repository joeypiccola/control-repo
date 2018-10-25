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
    $dn = $getDirectoryEntry.distinguishedName
    $compobj = [PSCustomObject]@{
        dn          = $getDirectoryEntry.distinguishedName.ToString()
        ou          = $dn.substring(($dn.split(',')[0].length + 1), ($dn.Length - ($dn.split(',')[0].length + 1)))
        whenCreated = $getDirectoryEntry.whenCreated.ToString()
        whenChanged = $getDirectoryEntry.whenChanged.ToString()
    }
    $adobj = [PSCustomObject]@{
        activedirectory_meta = $compobj
    }
    # write it out
    Write-Output ($adobj | ConvertTo-Json)
}