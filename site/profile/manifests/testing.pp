# == Class: profile::testing
class profile::testing (
  $value,
  $valuetwo,
  $pswindowsupdateurl,
  $wsusscnurl,
) {

  schedule { 'scan':
    range  => '21 - 3',
    period => daily,
    repeat => 1,
  }

  class { 'puppet_win':
    pswindowsupdateurl => $pswindowsupdateurl,
    wsusscnurl         => $wsusscnurl,
    schedule           => 'scan',
  }

}
