# == Class: profile::chocolatey
class profile::chocolatey (
  $chocolatey_download_url,
  $location,
) {
  include chocolatey

  chocolateysource_community {'chocolatey':
    ensure => disabled,
  }

  chocolateysource_private {'chocolatey':
    ensure   => present,
    location => $location,
    priority => 1,
  }
}