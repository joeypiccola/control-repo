# == Class: profile::testing
class profile::testing (
) {

  class { 'puppet_win':
    value => 'the value i want ps to output'
  }

  file { 'puppet_win_psfile':
    ensure => 'present',
    source => 'puppet:///modules/puppet_win/Test-Param.ps1',
    path   => 'c:/windows/temp',
    before => Exec['puppet_win_psexec'],
  }

  exec { 'puppet_win_psexec':
    command   => '& C:\windows\temp\Test-Param.ps1 -Value blahblah',
    provider  => 'powershell',
    logoutput => true,
  }
}
