# == Class: profile::firewall_config
class profile::firewall_config (
) {

  class { 'firewallprofile_win':
  }

}