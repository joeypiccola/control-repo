# == Class: profile::base
class profile::base (
  $packages,
) {
  include chocolatey

  Package {
    ensure => latest,
    provider => chocolatey,
  }

  # Dynamic installed packages (Defined in Heira)
  each ($packages) | $package | {
    package { $package: }
  }
    
}