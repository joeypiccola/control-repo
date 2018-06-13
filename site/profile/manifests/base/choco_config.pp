# == Class: profile::base::choco_config
class profile::base::choco_config (
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
