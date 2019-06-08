# == Class: profile::web::iis::apps::choco_server
class profile::web::iis::apps::choco_server (
) {

  include profile::web::install

  file { 'choco_web_directories':
    ensure => 'directory',
    path   => ['c:/websites', 'c:/websites/choco_server'],
  }

  file { 'choco_web_contents':
    ensure  => 'directory',
    source  => 'C:/Users/joey.piccola/Desktop/chocolatey.server',
    target  => 'C:/websites/choco_server',
    recurse => true,
    require => File['choco_web_directories'],
  }

  # remove default web site
  -> iis_site {'Default Web Site':
      ensure          => absent,
      applicationpool => 'DefaultAppPool',
    }

  # application in iis
  -> iis_application_pool {'chocolateyserver':
    ensure                    => 'present',
    state                     => 'started',
    enable32_bit_app_on_win64 => true,
    managed_runtime_version   => 'v4.0',
    start_mode                => 'AlwaysRunning',
    idle_timeout              => '00:00:00',
    restart_time_limit        => '00:00:00',
  }

  -> iis_site {'chocolateyserver':
    ensure          => 'started',
    physicalpath    => 'C:/websites/choco_server',
    applicationpool => 'chocolateyserver',
    preloadenabled  => true,
    bindings        =>  [
      {
        'bindinginformation' => '*:80:',
        'protocol'           => 'http'
      }
    ],
    require         => File['choco_web_directories'],
  }

  # lock down web directory
  -> acl { 'c:/websites/choco_server':
    purge                      => true,
    inherit_parent_permissions => false,
    permissions                => [
      { identity => 'Administrators', rights => ['full'] },
      { identity => 'IIS_IUSRS', rights => ['read'] },
      { identity => 'IUSR', rights => ['read'] },
      { identity => "IIS APPPOOL\\chocolateyserver", rights => ['read'] }
    ],
    require                    => File['choco_web_directories'],
  }

  -> acl { 'C:/websites/choco_server/App_Data':
    permissions => [
      { identity => "IIS APPPOOL\\chocolateyserver", rights => ['modify'] },
      { identity => 'IIS_IUSRS', rights => ['modify'] }
    ],
    require     => File['choco_web_contents'],
  }

}
