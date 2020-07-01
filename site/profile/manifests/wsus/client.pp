# == Class: profile::wsus::client
class profile::wsus::client (
    Optional[Boolean] $manage = false,
    Optional[Hash] $scheduled_tasks_to_remove = false,
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
        $scheduled_tasks_to_remove.each | String $scheduled_task_to_remove, Hash $attributes | {
          scheduled_task { $scheduled_task_to_remove:
            * => $attributes
          }
        }
      }

      # define command used for contacting update server
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

