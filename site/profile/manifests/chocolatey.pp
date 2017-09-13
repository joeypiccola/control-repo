# == Class: profile::chocolatey
class profile::chocolatey (
  $chocolatey_download_url,
  $location,
) {
  include chocolatey

  class {'chocolatey':
    chocolatey_download_url       => $chocolatey_download_url,
    use_7zip                      => false,
    choco_install_timeout_seconds => 2700,
  }

  chocolateysource {'chocolatey':
    ensure => disabled,
  }

  chocolateysource {'chocolatey':
    ensure   => present,
    location => $location,
    priority => 1,
  }
}