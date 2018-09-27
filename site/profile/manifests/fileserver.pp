# == Class: profile::fileserver
class profile::fileserver (
) {

  # ugh, you need to assign present and not present based on the OS (08 vs 12)

  $windowsfeatures_present = ['FS-FileServer','FS-Resource-Manager','RSAT-FSRM-Mgmt']
  $windowsfeatures_absent = ['FS-SMB1']

  windowsfeature { $windowsfeatures_present:
    ensure => present,
  }

  windowsfeature { $windowsfeatures_absent:
    ensure => absent,
  }

}
