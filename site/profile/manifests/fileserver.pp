# == Class: profile::fileserver
class profile::fileserver (
) {

  $windowsfeatures_present = ['FS-FileServer','FS-Resource-Manager']
  $windowsfeatures_absent = ['FS-SMB1']

  windowsfeature { $windowsfeatures_present:
    ensure => present,
  }

  windowsfeature { $windowsfeatures_absent:
    ensure => absent,
  }

}
