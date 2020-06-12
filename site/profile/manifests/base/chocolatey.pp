# == Class: profile::base::chocolatey
class profile::base::chocolatey (
  $location,
  $packages,
) {

  include chocolatey

  chocolateysource {'chocolatey':
    ensure   => present,
    location => 'https://chocolatey.org/api/v2',
    priority => 1,
  }

  #chocolateysource {'artifactory':
  #  ensure   => present,
  #  location => $location,
  #  priority => 1,
  #}

  $packages.each | String $package, Hash $attributes | {
    package { $package:
      * => $attributes
    }
  }

}
