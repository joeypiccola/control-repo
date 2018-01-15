# == Class: profile::testing
class profile::testing (
  $value,
) {

  class { 'puppet_win':
    value => 'the value i want ps to output'
  }

}
