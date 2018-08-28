# == Class: profile::base
class profile::base (
) {
  include profile::base::choco_install
  include profile::base::choco_config
  include profile::base::choco_packages
  include profile::base::crypto
  include profile::base::timezone
  include profile::base::kms
  include profile::base::nameservers
  include profile::base::uac_config
  include profile::base::firewall_config
  include profile::base::domain_join
  include profile::base::updatereporting
  include profile::base::wsus_config
  include profile::puppet_agent
  include profile::base::win_update_config
}
