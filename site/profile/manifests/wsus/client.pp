# == Class: profile::wsus::client
class profile::wsus::client (
    Optional[Boolean] $manage = true,
) {

  if $manage {
    if $facts['patch_group'] {
      class { 'wsus_client':
        target_group => $facts['patch_group'],
        notify       => Exec['wuauclt'],
      }
      exec { 'wuauclt':
        provider    => 'powershell',
        command     => "Start-Sleep -Seconds 10
                        wuauclt /detectnow",
        refreshonly => true,
      }
    } else {
      notify { 'no_patch_group':
        message => 'WARNING: The fact "patch_group" is blank. wsus_client class will not be applied.',
      }
    }
  }

}

