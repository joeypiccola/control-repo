[CmdletBinding()]
Param (
    [Parameter(Mandatory)]
    [string]$drive_letter
)

$PartitionSupportedSize = Get-PartitionSupportedSize -DriveLetter $drive_letter
Get-Partition -DriveLetter F | Resize-Partition -Size $PartitionSupportedSize.SizeMax
