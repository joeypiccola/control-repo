# == Class: role::jumphost
class role::jumphost {
  include profile::base
  include profile::jumphost::jumphost_install
}
