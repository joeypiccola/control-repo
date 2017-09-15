# == Class: profile::timezone
class profile::timezone (
  $timezone
) {

  class { '::timezone':
    timezone => $timezone
  }

}