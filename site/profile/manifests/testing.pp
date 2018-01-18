# == Class: profile::testing
class profile::testing (
  $downloaddirectory,
  $pswindowsupdateurl,
  $wsusscnurl,
) {

  class { 'puppet_win':
    pswindowsupdateurl => $pswindowsupdateurl,
    wsusscnurl         => $wsusscnurl,
    downloaddirectory  => $downloaddirectory,
  }

}
