# == Class: profile::updatereporting
class profile::updatereporting (
  $wsusscn_url,
) {

  class { 'updatereporting_win':
    wsusscn_url => $wsusscn_url,
  }
}
