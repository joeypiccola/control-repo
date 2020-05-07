# == Class: profile::cluster::clusterquorum
class profile::cluster::clusterquorum (
  String  $dsc_allocationunitsize,
  String  $dsc_diskid,
  String  $dsc_diskidtype,
  String  $dsc_fslabel,
  String  $dsc_driveletter,
  String  $dsc_issingleinstance,
  String  $dsc_master,
  #String  $dsc_number,
  String  $dsc_partitionstyle,
  Integer $dsc_retrycount,
  Integer $dsc_retryintervalsec,
  String  $dsc_type,
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
                   Get-Disk -UniqueId ${dsc_diskid} | Add-ClusterDisk",
      onlyif   => "$diskInstance = Get-CimInstance -ClassName MSCluster_Disk -Namespace \'Root\\MSCluster\' | Where-Object {$_.UniqueId -eq ${dsc_diskid}}
                   if ($diskInstance.count -eq 1) {
                     exit 1
                   }",
      require  => Dsc_waitforvolume['quorum_disk_wait'],
    }

    #exec {'quorum_cluster_disk_label':
    #  provider => 'powershell',
    #  command  => "Import-Module FailoverClusters
    #               Get-Disk -UniqueId ${dsc_diskid} | Add-ClusterDisk",
    #  onlyif   => "$diskInstance = Get-CimInstance -ClassName MSCluster_Disk -Namespace 'Root\\MSCluster' -Filter "UniqueId = ${dsc_diskid}")
    #               if ($diskInstance) {
    #                 exit 1
    #               }",
    #  require  => Exec['quorum_cluster_disk_add'],
    #}


    # dsc_xclusterdisk {'quorum_cluster_disk':
    #   dsc_number => $dsc_number,
    #   dsc_label  => $dsc_drivelabel,
    #   require    => Dsc_waitforvolume['quorum_disk_wait']
    # }

    #dsc_xclusterquorum {'create_quorum':
    #  dsc_issingleinstance => $dsc_issingleinstance,
    #  dsc_type             => $dsc_type,
    #  dsc_resource         => $dsc_fslabel,
    #  require              => Dsc_xclusterdisk['quorum_cluster_disk'],
    #}
  }

}


  #exec { 'task_executiontimelimit':
  #  provider => 'powershell',
  #  command  => '$taskName = "Windows Update (Puppet Managed Scheduled Task)"
  #               $scheduler = New-Object -ComObject Schedule.Service
  #               $scheduler.Connect($null, $null, $null, $null)
  #               $taskFolder = $scheduler.GetFolder("")
  #               $task = $taskFolder.GetTask($taskName).Definition
  #               $task.Settings.ExecutionTimeLimit="PT6H"
  #               $taskFolder.RegisterTaskDefinition($taskName, $task, 4, $null, $null, 3) | Out-Null',
  #  onlyif   => '$taskName = "Windows Update (Puppet Managed Scheduled Task)"
  #               $scheduler = New-Object -ComObject Schedule.Service
  #               $scheduler.Connect($null, $null, $null, $null)
  #               $taskFolder = $scheduler.GetFolder("")
  #               $task = $taskFolder.GetTask($taskName).Definition
  #               $executionTimeLimit = $task.Settings.ExecutionTimeLimit
  #               # check both in H and S bc srv12 reports in H and srv08 reports in S.
  #               if (($executionTimeLimit -eq "PT6H")) -or ($executionTimeLimit -eq "PT21600S")) {
  #                 exit 1
  #               }',
  #  require  => Scheduled_task['windows_update'],
  #}
#
