# == Class: profile::rdp_config
class profile::rdp_config (
) {

  class { 'remotedesktop' : 
    ensure => present,
    nla    => absent,
  }

}