# == Class: profile::patching::patching
class profile::patching::patching (
  Optional[String] $patchgroup = undef,
) {

  include profile::base::chocolatey

  package { '7zip':
    ensure   => '18.5.0.20180730',
    provider => 'chocolatey',
  }

  package { 'pswindowsupdate':
    ensure   => '2.0.0.4',
    provider => 'chocolatey',
    require  => Package['7zip'],
  }

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
