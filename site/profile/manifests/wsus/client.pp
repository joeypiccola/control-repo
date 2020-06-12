# == Class: profile::wsus::client
class profile::wsus::client (
    Optional[Boolean] $manage = false,
) {

  if $manage {
    if $facts['patch_group'] {
      class { 'wsus_client':
        notify => Exec['wuauclt'] ,
      }

    registry_value { 'HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU\NoAUShutdownOption':
      type => dword,
      data => 1,
      #require => Registry_key['HKLM\SYSTEM\CurrentControlSet\services\mrxsmb10']
    }

    registry_value { 'HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU\NoAUAsDefaultShutdownOption':
      type => dword,
      data => 1,
      #require => Registry_key['HKLM\SYSTEM\CurrentControlSet\services\mrxsmb10']
    }

      # If running a kernelmajversion >= 10.0 then use usoclient else use wuauclt
      if versioncmp($facts[kernelmajversion], '10.0') >= 0 {
        $cmd = 'usoclient startscan'
      } else {
        $cmd = 'wuauclt /detectnow'
      }

      exec { 'wuauclt':
        provider    => 'powershell',
        command     => $cmd,
        refreshonly => true,
      }
    } else {
      notify { 'no_patch_group':
        message => 'WARNING: The fact "patch_group" is blank. wsus_client class will not be applied.',
      }
    }
  }

}
