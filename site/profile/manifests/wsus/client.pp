# == Class: profile::wsus::client
class profile::wsus::client (
    Optional[Boolean] $manage = false,
) {

  if $manage {
    if $facts['patch_group'] {
      class { 'wsus_client':
        notify => Exec['wuauclt'] ,
      }
      exec { 'wuauclt':
        provider    => 'powershell',
        command     => "Start-Sleep -Seconds 10
                       \$osMajorVersion = ([version](Get-WmiObject -Class win32_operatingsystem).Version).major
                       if (\$osMajorVersion -ge 10) {
                         usoclient startscan
                       } else {
                         wuauclt /detectnow
                       }",
        refreshonly => true,
      }
    } else {
      notify { 'no_patch_group':
        message => 'WARNING: The fact "patch_group" is blank. wsus_client class will not be applied.',
      }
    }
  }

}
Start-Sleep -Seconds 10
$osVersion = ([version](Get-WmiObject -Class win32_operatingsystem).Version).major
if (/$osVersion -ge 10) {
  usoclient startscan
} else {
  wuauclt /detectnow
}
