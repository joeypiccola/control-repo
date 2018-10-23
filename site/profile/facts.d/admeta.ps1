[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseConsistentWhitespace", "", Justification = "just can't fix this")]
[CmdletBinding()]
Param()

$directorySearcher = New-Object System.DirectoryServices.DirectorySearcher
$directorySearcher.Filter = "(&(objectCategory=Computer)(Name=$env:ComputerName))"
$searcherPath = $directorySearcher.FindOne()
$getDirectoryEntry = $searcherPath.GetDirectoryEntry()


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

Write-Output ($adobj | ConvertTo-Json)