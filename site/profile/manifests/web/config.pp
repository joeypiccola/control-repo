# == Class: profile::web::config
class profile::web::config (
) {

  file { ['d:\\iserver', 'd:\\iserver\\DefaultWebSite']:
    ensure => 'directory'
  }

  -> file { ['d:\\Logs', 'd:\\Logs\\IIS']:
    ensure => 'directory'
  }

  -> iis_site { 'Default Web Site':
    ensure       => 'started',
    physicalpath => 'd:\\iserver\\DefaultWebSite',
    logpath      => 'd:\\logs\\IIS',
  }
}