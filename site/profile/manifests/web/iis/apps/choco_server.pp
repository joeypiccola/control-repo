# == Class: profile::web::iis::apps::choco_server
class profile::web::iis::apps::choco_server (
) {

  require profile::web::install

  file { 'websites_dir':
    ensure => 'directory',
    path   => 'c:/websites',
  }

  file { 'choco_server_dir':
    ensure  => 'directory',
    path    => 'c:/websites/choco_server',
    require => File['websites_dir'],
  }

  file { 'choco_web_contents':
    ensure  => 'directory',
    source  => 'C:/Users/joey.piccola/Desktop/chocolatey.server',
    path    => 'C:/websites/choco_server',
    recurse => true,
    require => File['choco_server_dir'],
  }

  # remove default web site
  iis_site {'Default Web Site':
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
    require         => File['choco_server_dir'],
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
    require                    => File['choco_server_dir'],
  }

  -> acl { 'C:/websites/choco_server/App_Data':
    permissions => [
      { identity => "IIS APPPOOL\\chocolateyserver", rights => ['modify'] },
      { identity => 'IIS_IUSRS', rights => ['modify'] }
    ],
    require     => File['choco_web_contents'],
  }

}
