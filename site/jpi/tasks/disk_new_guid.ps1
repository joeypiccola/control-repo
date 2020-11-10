[CmdletBinding()]
Param(
    [Parameter(Mandatory)]
    [string]$serial
)

$ErrorActionPreference = 'stop'

$disk = get-disk | Where-Object { $_.SerialNumber -eq $serial }
$oldGuid = $disk.guid

if (($disk | Measure-Object).count -eq 1) {
    $newGuid = New-Guid
    $disk | Set-Disk -Guid "{$newGuid}"
} else {
    Write-Error "No disk found for provided serial: $serial"
}

@{
    newGuid = $newGuid
    oldGuid = $oldGuid.trim('{}')
} | ConvertTo-Json
