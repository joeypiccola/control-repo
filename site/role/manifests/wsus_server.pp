# Class: role::wsus
#
#
class role::wsus {
  include profile::base
  include profile::wsus::server
}
