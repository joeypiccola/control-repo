# == Class:  role::wsus_server

class role::wsus_server {
  include profile::base
  include profile::wsus::server
  Class['profile::base'] -> Class['profile::wsus::server']
}
