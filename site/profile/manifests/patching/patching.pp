# == Class: profile::patching::patching
class profile::patching::patching (
  Optional[String] $patchgroup = 'Undefined Patch Group',
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

  # nasty nasty
  if $notkbarticleid.length > 0 {
    $csv = join($notkbarticleid,',')
    $notkbarticleid_param = " -NotKBArticleID ${csv}"
  } else {
    $notkbarticleid_param = ''
  }

  scheduled_task { 'windows_update':
    ensure        => present,
    name          => 'Windows Update (Puppet Managed Scheduled Task)',
    enabled       => true,
    command       => 'C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe',
    arguments     => "-WindowStyle Hidden -ExecutionPolicy Bypass \"c:/new-file.ps1${notkbarticleid_param}\"",
    provider      => 'taskscheduler_api2',
    user          => 'system',
    trigger       => [{
      schedule         => 'daily',
      every            => 1,
      start_time       => '13:48',
      minutes_interval => 1,
      minutes_duration => 3,
    }],
    require      => File['patch_script'],
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
    source => 'puppet:///modules/profile/patching/new-file.ps1',
    path   => 'c:/new-file.ps1',
  }
}
