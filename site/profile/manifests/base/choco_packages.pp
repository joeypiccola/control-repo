# == Class: profile::base::choco_packages
class profile::base::choco_packages (
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
