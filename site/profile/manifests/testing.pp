# == Class: profile::testing
class profile::testing (
  $download_directory,
  $pswindowsupdate_url,
  $wsusscn_url,
) {

  class { 'puppet_win':
    pswindowsupdate_url => $pswindowsupdate_url,
    wsusscn_url         => $wsusscn_url,
    download_directory  => $download_directory,
  }

}
