[CmdletBinding()]
Param(
    [Parameter(Mandatory)]
    [string]$serial,
    [Parameter(Mandatory)]
    [ValidateSet('offline','online')]
    [string]$status
)

$ErrorActionPreference = 'stop'

$disk = Get-Disk | Where-Object { $_.SerialNumber -eq $serial }

if (($disk | Measure-Object).count -eq 1) {
    switch ($status) {
        'online' {
            # if the disk is not online bring it online!
            if ($disk.OperationalStatus -ne 'Online') {
                Set-Disk -Number $disk.number -IsOffline $false -IsReadOnly $false
            }
        }
        'offline' {
            # if the disk is not ofline take it offline!
            if ($disk.OperationalStatus -ne 'Offline') {
                Set-Disk -Number $disk.number -IsOffline $true
            }
        }
    }
} else {
    Write-Error "No disk found for provided serial: $serial"
}

@{
    existingStatus = $disk.OperationalStatus
    modifiedStatus = $status
} | ConvertTo-Json
