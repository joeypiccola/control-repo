# == Class: profile::firewall_config
class profile::firewall_config (
) {

  class { 'firewallprofile_win':
    standard_profile => true,
    public_profile   => true,
    domain_profile   => true,
  }

}