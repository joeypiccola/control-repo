# == Class: profile::fileserver
class profile::fileserver (
) {

  $windowsfeatures_present = ['FS-FileServer','FS-Resource-Manager','RSAT-FSRM-Mgmt']
  $windowsfeatures_absent  = ['FS-DFS-Namespace','FS-DFS-Replication']
  # DEMO: 'FS-SMB1'

  windowsfeature { $windowsfeatures_present:
    ensure => present,
  }

  windowsfeature { $windowsfeatures_absent:
    ensure => absent,
  }

}
