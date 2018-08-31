# == Class: profile::patching::patching
class profile::patching::patching (
  Optional[String] $patchgroup = 'Undefined Patch Group',
) {

  require profile::base::chocolatey

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
    provider    => 'powershell',
    command     => "Get-Service wuauserv | Restart-Service
                    wuauclt.exe /detectnow",
    refreshonly => true,
  }

  scheduled_task { 'windows_update':
    ensure        => present,
    name          => 'Windows Update (Puppet Managed Scheduled Task)',
    enabled       => true,
    command       => 'C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe',
    arguments     => "-WindowStyle Hidden -ExecutionPolicy Bypass -File \"c:/new-file.ps1\"",
    provider      => 'taskscheduler_api2',
    user          => 'system',
    trigger       => [{
      schedule         => 'daily',
      every            => 1,
      start_time       => '16:34',
      minutes_interval => 1,
      minutes_duration => 5,
    }]
  }

}
