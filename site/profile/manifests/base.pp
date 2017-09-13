# == Class: profile::base
class profile::base (
) {
  include profile::choco_install
  include profile::choco_config
  include profile::choco_packages
}