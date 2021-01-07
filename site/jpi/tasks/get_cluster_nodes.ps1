$winDomain = Get-Cluster | Select-Object -ExpandProperty Domain
$clusterNodes = Get-ClusterNode | Select-Object -ExpandProperty name | ForEach-Object { $_ + '.' + $winDomain }
@{
    data = $clusterNodes
} | ConvertTo-Json
