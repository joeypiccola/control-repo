# == Class: profile::wsus::server

class profile::wsus::server (
) {
  # include wsusserver module
  include wsusserver
  # if an upstream wsus server include the target_groups defined type
  if $facts['application_component'] == 'upstream' {
    wsusserver_computer_target_group { ['Development', 'Staging', 'Production']:
        ensure => 'present',
    }
  }
}
