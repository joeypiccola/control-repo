# == Class: profile::wsus::client
class profile::wsus::client (
    Optional[Boolean] $manage = true,
) {

  # if not exchange or domaincontroller
  if ((!($facts['exchange']) or (!$facts['domaincontroller']))) {
    if $manage {
      class { 'wsus_client':
        target_group => $facts['patch_group'],
        #notify       => Service['wuauserv'],
      }
    }
  }
  #service { 'wuauserv':
  #  ensure => 'running',
  #  enable => true,
  #}
  #exec { 'wuauserv':
  #  provider    => 'powershell',
  #  command     => "Get-Service wuauserv | Restart-Service
  #                  wuauclt.exe /detectnow",
  #  refreshonly => true,
  #}
}

