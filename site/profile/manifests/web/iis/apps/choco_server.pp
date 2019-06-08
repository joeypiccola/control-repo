# == Class: profile::web::iis::apps::choco_server
class profile::web::iis::apps::choco_server (
) {

  require profile::web::install

  $_chocolatey_server_location = 'c:\websites\choco_server'

  file {$_chocolatey_server_location:
    ensure => 'directory'
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
    physicalpath    => $_chocolatey_server_location,
    applicationpool => 'chocolateyserver',
    preloadenabled  => true,
    bindings        =>  [
      {
        'bindinginformation' => '*:80:',
        'protocol'           => 'http'
      }
    ],
    require         => File[$_chocolatey_server_location],
  }

  # lock down web directory
  -> acl { $_chocolatey_server_location:
    purge                      => true,
    inherit_parent_permissions => false,
    permissions                => [
      { identity => 'Administrators', rights => ['full'] },
      { identity => 'IIS_IUSRS', rights => ['read'] },
      { identity => 'IUSR', rights => ['read'] },
      { identity => "IIS APPPOOL\\chocolateyserver", rights => ['read'] }
    ],
    require                    => File[$_chocolatey_server_location],
  }

  -> acl { "${_chocolatey_server_location}/App_Data":
    permissions => [
      { identity => "IIS APPPOOL\\chocolateyserver", rights => ['modify'] },
      { identity => 'IIS_IUSRS', rights => ['modify'] }
    ],
    require     => File[$_chocolatey_server_location],
  }

}
