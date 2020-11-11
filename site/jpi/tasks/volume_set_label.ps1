[CmdletBinding()]
Param(
    [Parameter(Mandatory)]
    [string]$label_key,
    [Parameter(Mandatory)]
    [string]$label_new
)

$ErrorActionPreference = 'stop'

$volume = Get-Volume | Where-Object { $_.FileSystemLabel -eq $label_key }
$proposedVolumeLabel = Get-Volume | Where-Object { $_.FileSystemLabel -eq $label_new }

if (($proposedVolumeLabel | Measure-Object).count -gt 0) {
    Write-Error "Volume with proposed new label already exists: $label_new"
}

switch (($volume | Measure-Object).count)
{
    0 {
        Write-Error "No volume found for provided label: $label_key"
    }
    1 {
        $volume | Set-Volume -NewFileSystemLabel $label_new
    }
    {$_ -gt 1} {
        Write-Error "More than one volume found for provided label: $label_key"
    }
}

@{
    newLabel = $label_new
    oldLabel = $label_key
} | ConvertTo-Json
