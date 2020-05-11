# == Class: profile::cluster::clusterquorum
class profile::cluster::clusterquorum (
  String  $dsc_allocationunitsize,
  String  $dsc_diskid,
  String  $dsc_diskidtype,
  String  $dsc_fslabel,
  String  $dsc_driveletter,
  String  $dsc_issingleinstance,
  String  $dsc_partitionstyle,
  Integer $dsc_retrycount,
  Integer $dsc_retryintervalsec,
  String  $dsc_type,
  String  $dsc_master = $profile::cluster::cluster::dsc_master,
) {

  if $facts['hostname'] == $dsc_master {
    # online, init, format, letter and label the quorum drive
    dsc_disk {'quorum_disk':
      dsc_allocationunitsize => $dsc_allocationunitsize,
      dsc_diskid             => $dsc_diskid,
      dsc_diskidtype         => $dsc_diskidtype,
      dsc_fslabel            => $dsc_fslabel,
      dsc_driveletter        => $dsc_driveletter,
      dsc_partitionstyle     => $dsc_partitionstyle,
    }

    dsc_waitforvolume {'quorum_disk_wait':
      dsc_driveletter      => $dsc_driveletter,
      dsc_retrycount       => $dsc_retrycount,
      dsc_retryintervalsec => $dsc_retryintervalsec,
    }

    exec {'quorum_cluster_disk_add':
      provider => 'powershell',
      command  => "Import-Module FailoverClusters
                   Get-Disk -UniqueId '${dsc_diskid}' | Add-ClusterDisk",
      onlyif   => "\$diskInstance = Get-CimInstance -ClassName MSCluster_Disk -Namespace \'Root\\MSCluster\' | Where-Object {\$_.UniqueId -eq '${dsc_diskid}'}
                   if (\$null -ne \$diskInstance) {
                     exit 1
                   }",
      require  => Dsc_waitforvolume['quorum_disk_wait'],
    }

    exec {'quorum_cluster_disk_label':
      provider => 'powershell',
      command  => "\$diskInstance = Get-CimInstance -ClassName MSCluster_Disk -Namespace \'Root\\MSCluster\' | Where-Object {\$_.UniqueId -eq '${dsc_diskid}'}
                   \$diskResource = Get-ClusterResource |
                                   Where-Object -FilterScript { \$_.ResourceType -eq 'Physical Disk' } |
                                       Where-Object -FilterScript {
                                           (\$_ | Get-ClusterParameter -Name DiskIdGuid).Value -eq \$diskInstance.Id
                                       }
                   \$diskResource.Name = '${dsc_fslabel}'
                   \$diskResource.Update()",
      onlyif   => "\$diskInstance = Get-CimInstance -ClassName MSCluster_Disk -Namespace \'Root\\MSCluster\' | Where-Object {\$_.UniqueId -eq '${dsc_diskid}'}
                   \$diskResource = Get-ClusterResource |
                                   Where-Object -FilterScript { \$_.ResourceType -eq 'Physical Disk' } |
                                       Where-Object -FilterScript {
                                           (\$_ | Get-ClusterParameter -Name DiskIdGuid).Value -eq \$diskInstance.Id
                                       }
                   if ('${dsc_fslabel}' -eq \$diskResource.name) {
                       exit 1
                   }",
      require  => Exec['quorum_cluster_disk_add'],
    }

    dsc_xclusterquorum {'create_quorum':
      dsc_issingleinstance => $dsc_issingleinstance,
      dsc_type             => $dsc_type,
      dsc_resource         => $dsc_fslabel,
      require              => Exec['quorum_cluster_disk_label'],
    }
  }

}
