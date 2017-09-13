# == Class: profile::choco_packages
class profile::choco_packages (
  $packages
) {
  include chocolatey

  Package {
    ensure => latest,
    provider => chocolatey,
  }

  each ($packages) | $package | {
    package { $package: }
  }
}