# == Class: profile::base
class profile::base (
) {
  include profile::choco_install
  include profile::choco_config
  include profile::choco_packages
  include profile::wsus_config
  include profile::timezone
}