# == Class: profile::chocolatey
class profile::chocolatey (
  $chocolatey_download_url
  $location
) {
  include chocolatey

  chocolateysource {'chocolatey':
    ensure => disabled,
  }

  chocolateysource {'chocolatey':
    ensure   => present,
    location => $location
    priority => 1,
  }
}