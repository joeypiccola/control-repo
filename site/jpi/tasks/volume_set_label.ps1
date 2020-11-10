[CmdletBinding()]
Param(
    [Parameter(Mandatory)]
    [string]$label,
    [Parameter(Mandatory)]
    [string]$new_label
)

$ErrorActionPreference = 'stop'

$volume = Get-Volume | Where-Object { $_.FileSystemLabel -eq $label }
$proposedVolumeLabel = Get-Volume | Where-Object { $_.FileSystemLabel -eq $new_label }

if (($proposedVolumeLabel | Measure-Object).count -gt 0) {
    Write-Error "Volume with proposed new label already exists: $new_label"
}

switch (($volume | Measure-Object).count)
{
    0 {
        Write-Error "No volume found for provided label: $label"
    }
    1 {
        $volume | Set-Volume -NewFileSystemLabel $new_label
    }
    {$_ -gt 1} {
        Write-Error "More than one volume found for provided label: $label"
    }
}

@{
    newLabel = $label
    oldLabel = $volume.FileSystemLabel
} | ConvertTo-Json
