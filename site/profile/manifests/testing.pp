# == Class: profile::testing
class profile::testing (
  $downloaddirectory,
  $pswindowsupdateurl,
  $wsusscnurl,
) {

  schedule { 'scan':
    range  => '6 - 12',
    period => daily,
    repeat => 1,
  }

  class { 'puppet_win':
    pswindowsupdateurl => $pswindowsupdateurl,
    wsusscnurl         => $wsusscnurl,
    downloaddirectory  => $downloaddirectory,
    schedule           => 'scan',
  }

}
