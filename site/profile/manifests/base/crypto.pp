# == Class: profile::base::crypto
class profile::base::crypto (
) {

  class { 'crypto_win':
    notify => Registry_key['RebootPending']
  }

  registry_key { 'RebootPending':
    ensure => present,
    path   => 'HKLM\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending',
  }

}
