# == Class: profile::patching::pswindowsupdate_config
class profile::patching::pswindowsupdate_config (
) {

  exec { 'pswindowsupdate':
    command  => "Remove-Item 'C:/Program Files/WindowsPowerShell/Modules/PSWindowsUpdate' -Recurse -Force -ErrorAction SilentlyContinue
                 Import-Module -Name 'BitsTransfer' -ErrorAction Stop
                 Start-BitsTransfer -Source 'http://nuget.ad.piccola.us:8081/PSWindowsUpdate.zip' -Destination 'C:/Windows/Temp' -ErrorAction Stop
                 7z e -spf 'c:/Windows/Temp/PSWindowsUpdate.zip' -o'C:/Program Files/WindowsPowerShell/Modules'
                 Remove-Item -Recurse C:/Windows/Temp/PSWindowsUpdate.zip -ErrorAction Stop",
    onlyif   => "if ([string](Get-Module -ListAvailable -Name 'PSWindowsUpdate').version -eq '2.0.0.4') { exit 1 } else { exit 0 }",
    provider => 'powershell',
    require  => Package['7zip'],
  }

  package { '7zip':
    ensure   => '18.5.0.20180730',
    provider => 'chocolatey',
  }

}
