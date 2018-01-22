# == Class: profile::base
class profile::base (
) {
  include profile::choco_install
  include profile::choco_config
  include profile::choco_packages
  include profile::wsus_config
  include profile::reboot
  include profile::timezone
  include profile::kms
  include profile::nameservers
  include profile::uac_config
  include profile::firewall_config
  include profile::domain_join
  include profile::puppet_agent
  include profile::updatereporting
}
