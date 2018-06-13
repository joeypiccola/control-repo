# == Class: profile::timezone
class profile::timezone (
  $timezone
) {

  class { 'timezone_win':
    timezone => $timezone
  }

}