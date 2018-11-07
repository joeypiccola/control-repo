# == Class: profile::base::updatereporting
class profile::base::updatereporting (
  $wsusscn_url,
) {

  class { 'updatereporting_win':
    wsusscn_url => $wsusscn_url,
  }

}
