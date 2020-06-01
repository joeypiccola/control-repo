# == Class: failovercluster_win::clusterquorum
class failovercluster_win::clusterquorum {

  if $facts['hostname'] == $failovercluster_win::primary_node {
    # online, init, format, letter and label the quorum drive
    dsc_disk {'quorum_disk':
      dsc_allocationunitsize => $failovercluster_win::quorum_allocation_unit_size,
      dsc_diskid             => $failovercluster_win::quorum_diskid,
      dsc_diskidtype         => $failovercluster_win::quorum_disk_id_type,
      dsc_fslabel            => $failovercluster_win::quorum_fs_label,
      dsc_driveletter        => $failovercluster_win::quorum_drive_letter,
      dsc_partitionstyle     => $failovercluster_win::quorum_partition_style,
    }

    if $failovercluster_win::manage_quorum {
      dsc_waitforvolume {'quorum_disk_wait':
        dsc_driveletter      => $failovercluster_win::quorum_drive_letter,
        dsc_retrycount       => $failovercluster_win::quorum_retry_count,
        dsc_retryintervalsec => $failovercluster_win::quorum_retry_interval_sec,
      }

      exec {'quorum_cluster_disk_add':
        provider => 'powershell',
        command  => "Import-Module FailoverClusters
                    Get-Disk -UniqueId '${failovercluster_win::quorum_diskid}' | Add-ClusterDisk",
        onlyif   => "\$diskInstance = Get-CimInstance -ClassName MSCluster_Disk -Namespace \'Root\\MSCluster\' | Where-Object {\$_.UniqueId -eq '${failovercluster_win::quorum_diskid}'}
                    if (\$null -ne \$diskInstance) {
                      exit 1
                    }",
        require  => Dsc_waitforvolume['quorum_disk_wait'],
      }

      exec {'quorum_cluster_disk_label':
        provider => 'powershell',
        command  => "\$diskInstance = Get-CimInstance -ClassName MSCluster_Disk -Namespace \'Root\\MSCluster\' | Where-Object {\$_.UniqueId -eq '${failovercluster_win::quorum_diskid}'}
                    \$diskResource = Get-ClusterResource |
                                    Where-Object -FilterScript { \$_.ResourceType -eq 'Physical Disk' } |
                                        Where-Object -FilterScript {
                                            (\$_ | Get-ClusterParameter -Name DiskIdGuid).Value -eq \$diskInstance.Id
                                        }
                    \$diskResource.Name = '${failovercluster_win::quorum_fs_label}'
                    \$diskResource.Update()",
        onlyif   => "\$diskInstance = Get-CimInstance -ClassName MSCluster_Disk -Namespace \'Root\\MSCluster\' | Where-Object {\$_.UniqueId -eq '${failovercluster_win::quorum_diskid}'}
                    \$diskResource = Get-ClusterResource |
                                    Where-Object -FilterScript { \$_.ResourceType -eq 'Physical Disk' } |
                                        Where-Object -FilterScript {
                                            (\$_ | Get-ClusterParameter -Name DiskIdGuid).Value -eq \$diskInstance.Id
                                        }
                    if ('${failovercluster_win::quorum_fs_label}' -eq \$diskResource.name) {
                        exit 1
                    }",
        require  => Exec['quorum_cluster_disk_add'],
      }

      dsc_xclusterquorum {'create_quorum':
        dsc_issingleinstance => $failovercluster_win::quorum_is_single_instance,
        dsc_type             => $failovercluster_win::quorum_type,
        dsc_resource         => $failovercluster_win::quorum_fs_label,
        require              => Exec['quorum_cluster_disk_label'],
      }
    }
  }

}
