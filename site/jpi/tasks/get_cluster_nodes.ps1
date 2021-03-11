$winDomain = Get-Cluster | Select-Object -ExpandProperty Domain
$clusterNodes = Get-ClusterNode | Select-Object -ExpandProperty name | ForEach-Object { $_ + '.' + $winDomain }
@{
    data = $clusterNodes
} | ConvertTo-Json

<#
    {
        "data" : [ "cluster-a-01.ad.piccola.us", "cluster-a-02.ad.piccola.us" ]
    }
#>
