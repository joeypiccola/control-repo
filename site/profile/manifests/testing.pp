# == Class: profile::testing
class profile::testing (
  $value,
  $valuetwo,
  $pswindowsupdateurl,
  $wsusscnurl,
) {

  class { 'puppet_win':
    value              => $value,
    valuetwo           => $valuetwo,
    pswindowsupdateurl => $pswindowsupdateurl,
    wsusscnurl         => $wsusscnurl,
  }

}
