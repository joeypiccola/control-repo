# == Class: profile::wsus::server

class profile::wsus::server (
) {
  include wsusserver
  wsusserver_computer_target_group { ['Development', 'Staging', 'Production']:
      ensure => 'present',
  }
}
