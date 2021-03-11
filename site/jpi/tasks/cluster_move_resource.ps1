[CmdletBinding()]
Param(
    [Parameter()]
    [string]$serial,
    [Parameter()]
    [string]$name,
    [Parameter(Mandatory)]
    [ValidateSet('add','remove')]
    [string]$status
)

$ErrorActionPreference = 'stop'

#TODO issue when name is not provided and script still attempts to set name. need to confirm

switch ($status) {
    'add' {
        # ensure needed params -not IsNullOrEmpty
        if ([string]::IsNullOrEmpty($name) -or [string]::IsNullOrEmpty($serial)) {
            Write-Error "Mandatory params missing"
        }
        $disk = get-disk | Where-Object { $_.SerialNumber -eq $serial }
        # if a disk was found
        if (($disk | Measure-Object).count -eq 1) {
            # add the disk
            $addedDisk = $disk | Add-ClusterDisk
            # get existing resources with proposed name
            $proposedName = Get-ClusterResource -Name $name -ErrorAction SilentlyContinue
            # if not existing resources exist name it!
            if (($proposedName | Measure-Object).count -eq 0) {
                $addedDisk.name = $name
            } else {
                Write-Error "Cluster resource with provided name already exists: $name"
            }
        } else {
            Write-Error "No disk found for provided serial: $serial"
        }
    }
    'remove' {
        # ensure needed params -not IsNullOrEmpty
        if ([string]::IsNullOrEmpty($name)) {
            Write-Error "Mandatory params missing"
        }
        $diskResource = Get-ClusterResource -Name $name -ErrorAction SilentlyContinue
        # if a disk was found
        if (($diskResource | Measure-Object).count -eq 1) {
            # remove the disk
            $diskResource | Remove-ClusterResource -Force
        } else {
            Write-Error "Cluster resource with provided name not found: $name"
        }
    }
}

