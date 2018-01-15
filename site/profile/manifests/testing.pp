# == Class: profile::testing
class profile::testing (
  $value,
) {

  class { 'puppet_win':
    value => $value,
  }

}
