# == Class: profile::base::bginfo
class profile::base::bginfo (
  Boolean $bginfo_install = false
) {
  if ($bginfo_install) {
    require profile::base::chocolatey

    file { 'bgi_config_dir':
      ensure => 'directory',
      path   => 'c:/windows/temp/bginfo',
    }

    if ((any2bool($facts['clustered'])) or (($facts['networking']['interfaces']).length > 1)) {
      file { 'bgi_config':
        source => 'puppet:///modules/profile/bginfo/cluster_or_multinic.bgi',
        path   => 'c:/windows/temp/bginfo/default.bgi',
      }
    } else {
      file { 'bgi_config':
        source => 'puppet:///modules/profile/bginfo/default.bgi',
        path   => 'c:/windows/temp/bginfo/default.bgi',
      }
    }

    package { 'bginfo':
      ensure   => '4.27',
      provider => 'chocolatey',
      require  => File['bgi_config'],
    }

    file { 'bgi_launch':
      source  => 'puppet:///modules/profile/bginfo/bginfo.bat',
      path    => 'C:/ProgramData/Microsoft/Windows/Start Menu/Programs/StartUp/bginfo.bat',
      require => Package['bginfo'],
    }
  } else {
    package { 'bginfo':
      ensure   => 'absent',
      provider => 'chocolatey',
    }

    file { 'bgi_launch':
      ensure => 'absent',
      path   => 'C:/ProgramData/Microsoft/Windows/Start Menu/Programs/StartUp/bginfo.bat',
    }
  }

}
