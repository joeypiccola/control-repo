# == Class: profile::packages
class profile::packages (
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