
[CmdletBinding()]
Param (
    [Parameter(Mandatory)]
    [string]$drive_letter
)

Get-Partition -DriveLetter $drive_letter
