# == Class: profile::firewall_config
class profile::firewall_config (
) {

  class { 'firewallprofile_win':
    standard_profile => 'disabled',
    public_profile   => 'enabled',
    domain_profile   => 'enabled',
    service_state    => 'running',
  }

}