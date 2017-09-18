# == Class: profile::firewall_config
class profile::firewall_config (
) {

  class { 'windows_firewall':
    ensure => 'running'
  }

}