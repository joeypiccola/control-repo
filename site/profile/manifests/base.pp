# == Class: profile::base
class profile::base (
) {
  include profile::base::bginfo
  include profile::base::chocolatey
  include profile::base::crypto
  include profile::base::eventlog
  include profile::base::firewall_config
  include profile::base::kms
  include profile::base::localaccounts
  include profile::base::rdp_config
  include profile::base::smbv1
  include profile::base::timezone
  include profile::base::uac_config
  #include profile::base::updatereporting
  include profile::puppet_agent
  include profile::wsus::client
}
