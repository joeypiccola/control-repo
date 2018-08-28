# == Class: profile::patching::patching
class profile::patching::patching (
  Optional[String] $patchgroup = undef,
) {

  include profile::patching::pswindowsupdate_config

  class { 'wsus_client':
    target_group => $patchgroup,
    notify       => Exec['wuauserv_svc']
  }

  exec { 'wuauserv_svc':
    provider => 'powershell',
    command  => "Get-Service wuauserv | Restart-Service
                 wuauclt.exe /detectnow",
  }

}
