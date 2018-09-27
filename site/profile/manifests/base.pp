# == Class: profile::base
class profile::base (
) {
  include profile::base::chocolatey
  include profile::base::crypto
  include profile::base::firewall_config
  include profile::base::kms
  include profile::base::localaccounts
  include profile::base::powershell
  include profile::base::nameservers
  include profile::base::timezone
  include profile::base::uac_config
  include profile::puppet_agent
  include profile::wsus::config
  include profile::wsus::patch
  include profile::wsus::report
}
