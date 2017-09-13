# == Class: profile::iis_config
class profile::iis_config (
) {
  include iis

  file { ['d:\\iserver', 'd:\\iserver\\DefaultWebSite']:
    ensure => 'directory'
  }

  file { ['d:\\Logs', 'd:\\Logs\\IIS']:
    ensure => 'directory'
  }

  iis_site { 'Default Web Site':
    logpath      => 'd:\\logs\\IIS',
    physicalpath => 'd:\\iserver\\DefaultWebSite',
  }
}