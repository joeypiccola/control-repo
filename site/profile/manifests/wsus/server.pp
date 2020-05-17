# == Class: profile::wsus::server
class profile::wsus::server (
  String $wsus_directory
) {

  $wsus_server_features = ['UpdateServices','UpdateServices-Services','UpdateServices-RSAT','UpdateServices-API','UpdateServices-UI']
  windowsfeature { $wsus_server_features:
    ensure => present,
  }

  file { $wsus_directory:
    ensure => 'directory',
  }

  exec { "post install wsus content directory ${wsus_directory}":
    command     => "if (!(Test-Path -Path \$env:TMP)) {
                      New-Item -Path \$env:TMP -ItemType Directory
                    }
                    & 'C:\\Program Files\\Update Services\\Tools\\WsusUtil.exe' PostInstall CONTENT_DIR=\"${wsus_directory}\" MU_ROLLUP=0
                    if (\$LASTEXITCODE -eq 1) {
                      Exit 1
                    }
                    else {
                      Exit 0
                    }",
    logoutput   => true,
    refreshonly => true,
    timeout     => 1200,
    provider    => 'powershell',
    require     => [
        Windowsfeature['UpdateServices'],
        Windowsfeature['UpdateServices-UI'],
        File[$wsus_directory]
      ]
  }

  iis_application_pool { 'WSUSPool':
    ensure                       => 'present',
    identity_type                => 'NetworkService',
    idle_timeout                 => 0,
    managed_pipeline_mode        => 'Integrated',
    pinging_enabled              => False,
    queue_length                 => 2000,
    restart_private_memory_limit => 0,
    restart_time_limit           => 0,
    state                        => 'started',
    require                      => Iis_feature['Web-WebServer'],
  }

}
