# == Class: profile::choco_config
class profile::choco_config (
  $location,
) {
  include chocolatey

  chocolateysource {'chocolatey':
    ensure => disabled,
  }

  chocolateysource {'private':
    ensure   => present,
    location => $location,
    priority => 1,
  }
}