# == Class: profile::wsus::client
class profile::wsus::client (
    Optional[Boolean] $manage = false,
    Optional[Array] $scheduled_tasks_to_remove = false,
) {

  if $manage {
    if $facts['patch_group'] {
      class { 'wsus_client':
        notify => Exec['wu_detect'] ,
      }

      # manage additional settings not included with wsus_client module
      registry_value { 'HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU\NoAUShutdownOption':
        type => dword,
        data => 1,
      }
      registry_value { 'HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU\NoAUAsDefaultShutdownOption':
        type => dword,
        data => 1,
      }

      # remove scheduled tasks that cuase unwanted desktop/user notifications
      if $scheduled_tasks_to_remove.length > 0 {
        # scheduled_task { 'Microsoft\\Windows\\UpdateOrchestrator\\Refresh Settings':
        #   enabled       => false,
        #   command       => 'c:\\windows\\system32\\usoclient.exe',
        #   compatibility => 4,
        #   #arguments    => 'RefreshSettings',
        #   #ensure       => absent,
        #   #command       => 'echo This task has been administratively disabled by Puppet.',
        #   #provider      => 'taskscheduler_api2',
        # }
        $scheduled_tasks_to_remove.each | String $scheduled_task_to_remove, Hash $attributes | {
          scheduled_task { $scheduled_task_to_remove:
            * => $attributes
          }
        }
      }




      # If running a kernelmajversion >= 10.0 then use usoclient else use wuauclt
      if versioncmp($facts[kernelmajversion], '10.0') >= 0 {
        $cmd = 'usoclient startscan'
      } else {
        $cmd = 'wuauclt /detectnow'
      }

      exec { 'wu_detect':
        provider    => 'powershell',
        command     => $cmd,
        refreshonly => true,
      }
    } else {
      notify { 'no_patch_group':
        message => 'WARNING: The fact "patch_group" is blank. wsus_client class will not be applied.',
      }
    }
  }

}

