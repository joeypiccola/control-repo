# == Class: role::fileserver
class role::fileserver {
  include profile::base
  include profile::fileserver
}
