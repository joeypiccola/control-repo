# == Class: profile::base::rdp_config
class profile::base::rdp_config (
) {

  class { 'remotedesktop' :
    ensure => present,
    nla    => absent,
  }

}
