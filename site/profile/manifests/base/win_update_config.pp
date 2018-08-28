# == Class: profile::base::win_update_config
class profile::base::win_update_config (
) {

  # archive { 'pswindowsupdate':
  #   ensure       => present,
  #   extract      => true,
  #   extract_path => 'C:/Windows/Temp',
  #   source       => 'http://nuget.ad.piccola.us:8081/PSWindowsUpdate_2004.zip',
  #   path         => 'C:/Program Files/WindowsPowerShell/Modules',
  #   cleanup      => true,
  # }

  exec { 'ps_pswindowsupdate':
    command  => "Import-Module -Name 'BitsTransfer'
                 Start-BitsTransfer -Source 'http://nuget.ad.piccola.us:8081/PSWindowsUpdate.zip' -Destination 'C:/Windows/Temp'
                 7z e -spf 'c:/Windows/Temp/PSWindowsUpdate.zip' -o'C:/Program Files/WindowsPowerShell/Modules'",
    onlyif   => "if ([string](Get-Module -ListAvailable -Name 'PSWindowsUpdate').version -eq '2.0.0.4' { exit 1 } else { exit 0 }",
    provider => 'powershell',
    require  => Package['7zip'],
  }

  package { '7zip':
    ensure   => '18.5.0.20180730',
    provider => 'chocolatey',
  }
}
