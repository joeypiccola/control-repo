[CmdletBinding()]
Param(
    [Parameter()]
    [string]$name,
    [Parameter(Mandatory)]
    [ValidateSet('add','remove')]
    [string]$status
)

$ErrorActionPreference = 'stop'

switch ($status) {
    'add' {
        # get cluster resource
        $clusterResource = Get-ClusterResource -Name $name -ErrorAction SilentlyContinue
        # if a cluster resource was found
        if (($clusterResource | Measure-Object).count -eq 1) {
            # add to csv
            $clusterResource | Add-ClusterSharedVolume
        } else {
            Write-Error "Cluster resource with provided name not found: $name"
        }
    }
    'remove' {
        # get csv
        $csvResource = Get-ClusterSharedVolume -Name $name -ErrorAction SilentlyContinue
        # if a csv was found
        if (($csvResource | Measure-Object).count -eq 1) {
            # remove csv
            $csvResource | Remove-ClusterSharedVolume
        } else {
            Write-Error "Cluster shared volume with provided name not found: $name"
        }
    }
}
