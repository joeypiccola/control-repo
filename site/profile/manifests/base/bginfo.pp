# == Class: profile::base::bginfo
class profile::base::bginfo (
) {

  require profile::base::chocolatey

  file { 'bgi_config_dir':
    ensure => 'directory',
    path   => 'c:/windows/temp/bginfo',
  }

  file { 'bgi_config':
    source => 'puppet:///modules/profile/bginfo/default.bgi',
    path   => 'c:/windows/temp/bginfo/default.bgi',
  }

  package { 'bginfo':
    ensure   => '4.26',
    provider => 'chocolatey',
    require  => File['bgi_config'],
  }

  file { 'bgi_launch':
    source  => 'puppet:///modules/profile/bginfo/bginfo.bat',
    path    => 'C:/ProgramData/Microsoft/Windows/Start Menu/Programs/StartUp/bginfo.bat',
    require => Package['bginfo'],
  }

}
