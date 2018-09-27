# == Class: profile::wsus::client
class profile::wsus::client (
    Optional[String] $patchgroup = 'Undefined Patch Group',
    Optional[Boolean] $wsus_client = true,
) {

  if $wsus_client {
    class { 'wsus_client':
      target_group => $patchgroup,
      notify       => Exec['wuauserv_svc'],
    }

    exec { 'wuauserv_svc':
      provider    => 'powershell',
      command     => "Get-Service wuauserv | Restart-Service
                      wuauclt.exe /detectnow",
      refreshonly => true,
    }
  }

}
