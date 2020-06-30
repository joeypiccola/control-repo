# == Class: profile::wsus::client
class profile::wsus::client (
    Optional[Boolean] $manage = false,
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

      # If running a kernelmajversion >= 10.0 then use usoclient else use wuauclt
      if versioncmp($facts[kernelmajversion], '10.0') >= 0 {
        $scheduled_tasks = [
          'Microsoft/Windows/UpdateOrchestrator/Backup Scan',
          'Microsoft/Windows/UpdateOrchestrator/Maintenance Install',
          'Microsoft/Windows/UpdateOrchestrator/MusUx_UpdateInterval',
          'Microsoft/Windows/UpdateOrchestrator/Reboot',
          'Microsoft/Windows/UpdateOrchestrator/Schedule Scan Static Task',
          'Microsoft/Windows/UpdateOrchestrator/Schedule Scan',
          'Microsoft/Windows/UpdateOrchestrator/USO_UxBroker',
        ]
        scheduled_task { '/Microsoft/Windows/UpdateOrchestrator/Backup Scan':
          enabled  => false,
          #provider => 'taskscheduler_api2',
        }
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

