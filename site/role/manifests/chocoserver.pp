# == Class: role::chocoserver
class role::chocoserver {
  include profile::base
  include profile::dfsr
  include profile::chocoserver
  include profile::webserver::iis
  Class['profile::webserver::iis'] -> Class['profile::chocoserver']
}
