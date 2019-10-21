# == Class: profile::wsus::client
class profile::wsus::client (
    Optional[Boolean] $manage = true,
) {

  if $manage {
    if $facts['patch_group'] {
      class { 'wsus_client':
        target_group => $facts['patch_group'],
        #notify       => Exec['wuauserv_svc'],
      }
    }


    # exec { 'wuauserv_svc':
    #   provider    => 'powershell',
    #   command     => "Get-Service wuauserv | Restart-Service
    #                   wuauclt.exe /detectnow",
    #   refreshonly => true,
    # }
  }

}
