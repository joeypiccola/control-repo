# == Class:  role::wsus_server

class role::wsus_server {
  include profile::base
  include profile::webserver::iis
  include profile::wsus::server
  Class['profile::base']
  -> Class['profile::webserver::iis']
  -> Class['profile::wsus::server']
}
