# Class: role::wsus
#
#
class role::wsus_server {
  include profile::base
  include profile::wsus::server
}
