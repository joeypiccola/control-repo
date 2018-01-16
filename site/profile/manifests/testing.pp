# == Class: profile::testing
class profile::testing (
  $value,
  $valuetwo,
  $pswindowsupdateurl,
  $wsusscnurl,
) {

  schedule { 'daily':
    period => daily,
    repeat => 4,
  }

  class { 'puppet_win':
    value              => $value,
    valuetwo           => $valuetwo,
    pswindowsupdateurl => $pswindowsupdateurl,
    wsusscnurl         => $wsusscnurl,
    schedule           => 'daily',
  }

}
