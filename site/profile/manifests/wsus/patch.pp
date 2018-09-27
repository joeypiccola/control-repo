# == Class: profile::wsus::patch
class profile::wsus::patch (
  Optional[String] $day_of_week = undef,
  Optional[String] $which_occurrence = undef,
  Optional[Array] $notkbarticleid = [],
) {

  require profile::wsus::pswindowsupdate

  ## fix the -NotKBArticleID. if needed then supply param with csv. if not needed then leave out.
  #if $notkbarticleid.length > 0 {
  #  $csv = join($notkbarticleid,',')
  #  $notkbarticleid_param = " -NotKBArticleID ${csv}"
  #} else {
  #  $notkbarticleid_param = ''
  #}
#
  #scheduled_task { 'windows_update':
  #  ensure    => absent,
  #  name      => 'Windows Update (Puppet Managed Scheduled Task)',
  #  enabled   => true,
  #  command   => 'C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe',
  #  arguments => "-WindowStyle Hidden -ExecutionPolicy Bypass \"c:/windows/temp/Install-WindowsUpdate.ps1${notkbarticleid_param}\"",
  #  provider  => 'taskscheduler_api2',
  #  user      => 'system',
  #  trigger   => [{
  #    schedule         => 'monthly',
  #    start_time       => '22:00',
  #    day_of_week      => $day_of_week,
  #    which_occurrence => $which_occurrence,
  #    minutes_interval => 10,
  #    minutes_duration => 60,
  #  }],
  #  require   => File['patch_script'],
  #}
#
  #exec { 'task_executiontimelimit':
  #  provider => 'powershell',
  #  command  => '$taskName = "Windows Update (Puppet Managed Scheduled Task)"
  #               $scheduler = New-Object -ComObject Schedule.Service
  #               $scheduler.Connect($null, $null, $null, $null)
  #               $taskFolder = $scheduler.GetFolder("")
  #               $task = $taskFolder.GetTask($taskName).Definition
  #               $task.Settings.ExecutionTimeLimit="PT6H"
  #               $taskFolder.RegisterTaskDefinition($taskName, $task, 4, $null, $null, 3) | Out-Null',
  #  onlyif   => '$taskName = "Windows Update (Puppet Managed Scheduled Task)"
  #               $scheduler = New-Object -ComObject Schedule.Service
  #               $scheduler.Connect($null, $null, $null, $null)
  #               $taskFolder = $scheduler.GetFolder("")
  #               $task = $taskFolder.GetTask($taskName).Definition
  #               $executionTimeLimit = $task.Settings.ExecutionTimeLimit
  #               # check both in H and S bc srv12 reports in H and srv08 reports in S.
  #               if (($executionTimeLimit -eq "PT6H")) -or ($executionTimeLimit -eq "PT21600S")) {
  #                 exit 1
  #               }',
  #  require  => Scheduled_task['windows_update'],
  #}
#
  #file { 'patch_script':
  #  source => 'puppet:///modules/profile/patching/Install-WindowsUpdate.ps1',
  #  path   => 'c:/windows/temp/Install-WindowsUpdate.ps1',
  #}
}
