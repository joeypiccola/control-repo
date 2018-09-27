# == Class: profile::jumphost
class profile::jumphost (
) {
  windowsfeature { 'RDS-RD-Server':
    ensure => present,
  }
}
