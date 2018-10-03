# == Class: profile::utility
class profile::utility (
) {

  $windowsfeatures_present = ['Telnet-Client']

  windowsfeature { $windowsfeatures_present:
    ensure => present,
  }

}
