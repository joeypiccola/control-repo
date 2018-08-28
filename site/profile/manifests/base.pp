# == Class: profile::base
class profile::base (
) {
  include profile::base::choco_install
  include profile::base::choco_config
  include profile::base::choco_packages
  include profile::base::crypto
  include profile::base::domain_join
  include profile::base::firewall_config
  include profile::base::kms
  include profile::base::nameservers
  include profile::base::timezone
  include profile::base::uac_config
  include profile::base::updatereporting
  include profile::patching::install_saturday_config
  include profile::patching::pswindowsupdate_config
  include profile::patching::wsus_config
  include profile::puppet_agent
}
