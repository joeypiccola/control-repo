# == Class:  role::wsus_server

class role::wsus_server {
  include profile::base
  include profile::webserver::iis
  include profile::wsus
  Class['profile::base']
  -> Class['profile::web::iis']
  -> Class['profile::wsus']
}
