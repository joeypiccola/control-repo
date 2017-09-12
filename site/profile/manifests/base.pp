# == Class: profile::base
class profile::base (
  $packages,
) {
  include chocolatey

  Package {
    ensure => latest,
    provider => chocolatey,
  }
}