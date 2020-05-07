# == Class: profile::cluster::clusterquorum
class profile::cluster::clusterquorum (
  String  $dsc_allocationunitsize,
  String  $dsc_diskid,
  String  $dsc_diskidtype,
  String  $dsc_drivelabel,
  String  $dsc_driveletter,
  String  $dsc_issingleinstance,
  String  $dsc_master,
  String  $dsc_number,
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
      dsc_drivelabel         => $dsc_drivelabel,
      dsc_driveletter        => $dsc_driveletter,
      dsc_partitionstyle     => $dsc_partitionstyle,
    }

    dsc_waitforvolume {'quorum_disk_wait':
      dsc_driveletter      => $dsc_driveletter,
      dsc_retrycount       => $dsc_retrycount,
      dsc_retryintervalsec => $dsc_retryintervalsec,
    }

    # dsc_xclusterdisk {'quorum_cluster_disk':
    #   dsc_number => $dsc_number,
    #   dsc_label  => $dsc_drivelabel,
    #   require    => Dsc_waitforvolume['quorum_disk_wait']
    # }
#
    # dsc_xclusterquorum {'SetQuorumToDiskOnly':
    #   issingleinstance => $dsc_issingleinstance,
    #   type             => $dsc_type,
    #   resource         => $dsc_drivelabel,
    #   require          => Dsc_xclusterdisk['quorum_cluster_disk']
    # }
  }

}


