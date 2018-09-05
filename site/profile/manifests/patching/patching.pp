# == Class: profile::patching::patching
class profile::patching::patching (
  Optional[String] $patchgroup = 'Undefined Patch Group',
  Optional[String] $day_of_week = undef,
  Optional[String] $which_occurrence = undef,
  Optional[Boolean] $wsus_client = undef,
  Optional[Array] $notkbarticleid = [],
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

  # fix the -NotKBArticleID. if needed then supply param with csv. if not needed then leave out.
  if $notkbarticleid.length > 0 {
    $csv = join($notkbarticleid,',')
    $notkbarticleid_param = " -NotKBArticleID ${csv}"
  } else {
    $notkbarticleid_param = ''
  }

  scheduled_task { 'windows_update':
    ensure    => present,
    name      => 'Windows Update (Puppet Managed Scheduled Task)',
    enabled   => true,
    command   => 'C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe',
    arguments => "-WindowStyle Hidden -ExecutionPolicy Bypass \"c:/windows/temp/Install-WindowsUpdate.ps1${notkbarticleid_param}\"",
    provider  => 'taskscheduler_api2',
    user      => 'system',
    trigger   => [{
      schedule         => 'monthly',
      start_time       => '22:00',
      day_of_week      => $day_of_week,
      which_occurrence => $which_occurrence,
      minutes_interval => 10,
      minutes_duration => 60,
    }],
    require   => File['patch_script'],
  }

  exec { 'task_executiontimelimit':
    provider => 'powershell',
    command  => '$taskName = "Windows Update (Puppet Managed Scheduled Task)"
                 $scheduler = New-Object -ComObject Schedule.Service
                 $scheduler.Connect($null, $null, $null, $null)
                 $taskFolder = $scheduler.GetFolder("")
                 $task = $taskFolder.GetTask($taskName).Definition
                 $task.Settings.ExecutionTimeLimit="PT6H"
                 $taskFolder.RegisterTaskDefinition($taskName, $task, 4, $null, $null, 3) | Out-Null',
    onlyif   => '$taskName = "Windows Update (Puppet Managed Scheduled Task)"
                 $scheduler = New-Object -ComObject Schedule.Service
                 $scheduler.Connect($null, $null, $null, $null)
                 $taskFolder = $scheduler.GetFolder("")
                 $task = $taskFolder.GetTask($taskName).Definition
                 if ($task.Settings.ExecutionTimeLimit -eq "PT6H") {
                   exit 1
                 }',
    require  => Scheduled_task['windows_update'],
  }

  file { 'patch_script':
    source => 'puppet:///modules/profile/patching/Install-WindowsUpdate.ps1',
    path   => 'c:/windows/temp/Install-WindowsUpdate.ps1',
  }
}
