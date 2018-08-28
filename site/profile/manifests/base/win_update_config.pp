# == Class: profile::base::win_update_config
class profile::base::win_update_config (
) {

  archive { 'pswindowsupdate':
    ensure  => present,
    extract => true,
    source  => 'http://nuget.ad.piccola.us:8081/PSWindowsUpdate_2004.zip',
    creates => 'C:/Windows/Temp/PSWindowsUpdate_2004',
    cleanup => true,
  }

}
