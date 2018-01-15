# == Class: profile::testing
class profile::testing (
  $value,
) {

  class { 'puppet_win':
    value => $value,
  }

  file { 'puppet_win_psfile':
    ensure => 'present',
    source => 'puppet:///modules/puppet_win/Test-Param.ps1',
    path   => 'c:/windows/temp/Test-Param.ps1',
    before => Exec['puppet_win_psexec'],
  }

  exec { 'puppet_win_psexec':
    command   => "& C:\\windows\\temp\\Test-Param.ps1 -Value ${value}",
    provider  => 'powershell',
    logoutput => true,
  }

  exec { 'puppet_win_psexec_file':
    command   => file("puppet_win/Test-Param.ps1 -Value ${value}"),
    provider  => 'powershell',
    logoutput => true,
  }

}
