# == Class: profile::base::powershell
class profile::base::powershell (
  $powershell_upgrade_reboot = undef,
  $upgrade = undef
) {

  if $upgrade == true {
    require profile::base::chocolatey
    case $facts['powershell_version'] {
      /^4\.|5\./: {
        # this is where we begin management of powershell.
        # if we're on some version of 5 the ensure we're on the following version.
        package { 'powershell5':
          ensure   => '5.1.14409.20180811',
          name     => 'powershell',
          provider => 'chocolatey',
        }
      }
      /^3\./: {
        package { 'powershell3':
          ensure   => '4.0.20141001',
          name     => 'powershell',
          provider => 'chocolatey',
        }
      }
      default: {
        notify { 'noMatch':
          name    => 'no match',
          message => 'no match',
        }
      }
    }
    if $powershell_upgrade_reboot == true {
      reboot { 'powershell_upgrade_reboot':
        subscribe => [Package['powershell5'],Package['powershell3']]
      }
    }
  }

}
