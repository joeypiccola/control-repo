# == Class: profile::base::chocolatey
class profile::base::chocolatey (
  $location,
  $packages,
) {
  include chocolatey

  chocolateysource {'chocolatey':
    ensure => disabled,
  }

  chocolateysource {'artifactory':
    ensure   => present,
    location => $location,
    priority => 1,
  }

  $packages.each | String $package, Hash $attributes | {
    Package { $package:
      * => $attributes
    }
  }

}
