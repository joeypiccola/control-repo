[CmdletBinding()]
Param(
    [Parameter(Mandatory)]
    [string]$serial,
    [Parameter(Mandatory)]
    [ValidateSet('offline','online')]
    [string]$status,
    [Parameter()]
    [boolean]$ensure_read_write = $true
)

$ErrorActionPreference = 'stop'

#TODO maybe find way to write in hash existing and modified IsReadOnly details

$disk = Get-Disk | Where-Object { $_.SerialNumber -eq $serial }

if (($disk | Measure-Object).count -eq 1) {
    switch ($status) {
        'online' {
            # if the disk is not online bring it online!
            if ($disk.OperationalStatus -ne 'Online') {
                Set-Disk -Number $disk.number -IsOffline $false
                # if the disk is read only and ensure r+w enabled then make it r+w
                if ($disk.IsReadOnly -eq $true -and $ensure_read_write) {
                    Set-Disk -Number $disk.number -IsReadOnly $false
                }
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
