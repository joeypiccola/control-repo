# == Class: profile::fileserver
class profile::fileserver (
) {

  $windowsfeatures_present = ['FS-FileServer','FS-Resource-Manager','RSAT-FSRM-Mgmt','RSAT-CoreFile-Mgmt']
  $windowsfeatures_absent = ['FS-SMB1']

  windowsfeature { $windowsfeatures_present:
    ensure => present,
  }

  windowsfeature { $windowsfeatures_absent:
    ensure => absent,
  }

}
