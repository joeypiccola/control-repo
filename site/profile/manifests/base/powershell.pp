# == Class: profile::base::powershell
class profile::base::powershell (
  $reboot = undef,
  $upgrade = undef
) {

  if $upgrade == true {
    require profile::base::chocolatey
    case $facts['powershell_version'] {
      /^4\.|5\./: {
        package { 'powershell5':
          ensure   => '5.1.14409.20180811',
          name     => 'powershell',
          provider => 'chocolatey',
        }
        if $reboot == true {
          reboot { 'powershell_upgrade_reboot':
            subscribe => Package['powershell5']
          }
        }
      }
      /^3\./: {
        package { 'powershell4':
          ensure   => '4.0.20141001',
          name     => 'powershell',
          provider => 'chocolatey',
        }
        if $reboot == true {
          reboot { 'powershell_upgrade_reboot':
            subscribe => Package['powershell4']
          }
        }
      }
      default: {
        notice("No upgrade logic of PowerShell Version ${facts['powershell_version']}")
      }
    }
  }

}
