# == Class: profile::base::firewall_config
class profile::base::firewall_config (
) {

  class { 'firewallprofile_win':
    standard_profile     => 'disabled',
    public_profile       => 'disabled',
    domain_profile       => 'disabled',
    service_status       => 'running',
    service_startup_type => 'automatic',
  }

}
