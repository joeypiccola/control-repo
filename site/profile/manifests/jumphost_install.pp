# == Class: profile::jumphost_install
class profile::jumphost_install (
) {

  windowsfeature { 'RDS-RD-Server':
    ensure => present,
  }

}