# Class: profile::base::files
#
#
class profile::base::files {

  file { 'pswindowsupdate':
    ensure => 'present',
    source => 'http://nuget.ad.piccola.us:8081/PSWindowsUpdate.zip',
    path   => 'c:/windows/temp/PSWindowsUpdate.zip',
  }

}
