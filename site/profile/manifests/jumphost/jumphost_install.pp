# == Class: profile::jumphost::jumphost_install
class profile::jumphost::jumphost_install (
) {
  windowsfeature { 'RDS-RD-Server':
    ensure => present,
  }
}
