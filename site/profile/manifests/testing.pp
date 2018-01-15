# == Class: profile::testing
class profile::testing (
) {

  class { 'puppet_win':
    value => 'the value i want ps to output'
  }

}
