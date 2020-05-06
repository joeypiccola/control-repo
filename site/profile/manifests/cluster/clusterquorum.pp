# == Class: profile::cluster::clusterquorum
class profile::cluster::clusterquorum (
  String $dsc_allocationunitsize,
  String $dsc_driveletter,
  String $dsc_drivelabel,
  String $dsc_partitionstyle,
  String $dsc_diskidtype,
  String $dsc_diskid,
  Integer $dsc_retryintervalsec,
  Integer $dsc_retrycount,
  String $dsc_issingleinstance,
  String $dsc_type,
  String $dsc_number,
  String $dsc_master
) {

  if $facts['hostname'] == $dsc_master {
    # online, init, format, letter and label the quorum drive
    dsc_disk {'quorum_disk':
      dsc_allocationunitsize => $dsc_allocationunitsize,
      dsc_driveletter        => $dsc_driveletter,
      dsc_drivelabel         => $dsc_drivelabel,
      dsc_partitionstyle     => $dsc_partitionstyle,
      dsc_diskidtype         => $dsc_diskidtype,
      dsc_diskid             => $dsc_diskid,
    }

    dsc_waitforvolume {'quorum_disk_wait':
      dsc_driveletter      => $dsc_driveletter,
      dsc_retryintervalsec => $dsc_retryintervalsec,
      dsc_retrycount       => $dsc_retrycount,
    }

    dsc_xclusterdisk {'quorum_cluster_disk':
      dsc_number => $dsc_number,
      dsc_label  => $dsc_drivelabel,
      require    => Dsc_waitforvolume['quorum_disk_wait']
    }

    dsc_xclusterquorum {'SetQuorumToDiskOnly':
      issingleinstance => $dsc_issingleinstance,
      type             => $dsc_type,
      resource         => $dsc_drivelabel,
      require          => Dsc_xclusterdisk['quorum_cluster_disk']
    }
  }

}
