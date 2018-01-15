# == Class: profile::testing
class profile::testing (
  $value,
  $pswindowsupdateurl,
  $wsusscnurl,
) {

  class { 'puppet_win':
    value              => $value,
    pswindowsupdateurl => $pswindowsupdateurl,
    wsusscnurl         => $wsusscnurl,
  }

}
