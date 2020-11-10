[CmdletBinding()]
Param(
    [Parameter(Mandatory)]
    [string]$serial,
    [Parameter()]
    [string]$name
)

$ErrorActionPreference = 'stop'

#TODO issue when name is not provided and script still attempts to set name

$disk = get-disk | Where-Object { $_.SerialNumber -eq $serial }

# if a disk was found
if (($disk | Measure-Object).count -eq 1) {
    # add the disk
    $addedDisk = $disk | Add-ClusterDisk
    # if a name was provided
    if ($null -ne $name) {
        # get existing resources with proposed name
        $proposedName = Get-ClusterResource -Name $name -ErrorAction SilentlyContinue
        # if not existing resources exist name it!
        if (($proposedName | Measure-Object).count -eq 0) {
            $addedDisk.name = $name
        } else {
            Write-Error "Cluster resource with provided name already exists: $name"
        }
    }
} else {
    Write-Error "No disk found for provided serial: $serial"
}
