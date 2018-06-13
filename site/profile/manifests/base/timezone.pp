# == Class: profile::base::timezone
class profile::base::timezone (
  $timezone
) {

  class { 'timezone_win':
    timezone => $timezone
  }

}
