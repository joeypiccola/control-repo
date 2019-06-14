# == Class: profile::chocoserver
class profile::chocoserver (
  String $website_name = 'chocolateyserver',
  String $app_pool_name = 'chocolateyserver',
  Integer $port = 80,
) {

  package { 'chocolatey.server':
    ensure          => installed,
    install_options => ['-i'],
    source          => 'https://chocolatey.org/api/v2',
  }

  # iis features specific to chcoo/nuget
  $iis_features = ['Web-Asp-Net45','Web-AppInit']
  iis_feature { $iis_features:
    ensure => 'present',
  }

  file { 'websites_dir':
    ensure => 'directory',
    path   => 'c:/websites',
  }

  file { 'choco_web_contents':
    ensure  => 'directory',
    source  => 'C:/tools/chocolatey.server',
    path    => "c:/websites/${website_name}",
    recurse => true,
    require => Package['chocolatey.server'],
  }

  # application in iis
  -> iis_application_pool { $app_pool_name:
    ensure                    => 'present',
    state                     => 'started',
    enable32_bit_app_on_win64 => true,
    managed_runtime_version   => 'v4.0',
    start_mode                => 'AlwaysRunning',
    idle_timeout              => '00:00:00',
    restart_time_limit        => '00:00:00',
  }

  -> iis_site { $website_name:
    ensure          => 'started',
    physicalpath    => "C:\\websites\\${website_name}",
    applicationpool => $app_pool_name,
    preloadenabled  => true,
    bindings        =>  [
      {
        'bindinginformation' => "*:${port}:",
        'protocol'           => 'http'
      }
    ],
    require         => File['choco_web_contents'],
  }

  # lock down web directory
  -> acl { "c:/websites/${website_name}":
    purge                      => true,
    inherit_parent_permissions => false,
    permissions                => [
      { identity => 'Administrators', rights => ['full'] },
      { identity => 'IIS_IUSRS', rights => ['read'] },
      { identity => 'IUSR', rights => ['read'] },
      { identity => "IIS APPPOOL\\${app_pool_name}", rights => ['read'] }
    ],
    require                    => File['choco_web_contents'],
  }

  -> acl { "C:/websites/${website_name}/App_Data":
    permissions => [
      { identity => "IIS APPPOOL\\${app_pool_name}", rights => ['modify'] },
      { identity => 'IIS_IUSRS', rights => ['modify'] }
    ],
    require     => File['choco_web_contents'],
  }

}
