# == Class: profile::wsus::server
class profile::wsus::server (
  String $wsus_directory
) {

  file { $wsus_directory:
    ensure => 'directory',
  }

  $wsus_server_features = ['UpdateServices','UpdateServices-Services','UpdateServices-RSAT','UpdateServices-API','UpdateServices-UI']
  windowsfeature { $wsus_server_features:
    ensure => present,
    #notify => Exec['WsusUtil PostInstall'],
  }

  # dsc_xwebapppool { 'WsusPool':
  #   #dsc_ensure                    => 'present',
  #   #dsc_identitytype              => 'NetworkService',
  #   dsc_idletimeout               => '0:00:00',
  #   #dsc_managedpipelinemode       => 'Integrated',
  #   dsc_name                      => 'WsusPool',
  #   dsc_pingingenabled            => false,
  #   dsc_queuelength               => 2000,
  #   dsc_restartprivatememorylimit => 0,
  #   dsc_restarttimelimit          => '0:00:00',
  #   #dsc_state                     => 'Started',
  #   #require                       => Exec['WsusUtil PostInstall'],
  # }

  iis_application_pool { 'WsusPool':
    idle_timeout       => '00:00:00',
    name               => 'WsusPool',
    pinging_enabled    => false,
    queue_length       => 2000,
    restart_time_limit => '00:00:00',
  }

  # exec { 'WsusUtil PostInstall':
  #   command     => "if (!(Test-Path -Path \$env:TMP)) {
  #                     New-Item -Path \$env:TMP -ItemType Directory
  #                   }
  #                   & 'C:\\Program Files\\Update Services\\Tools\\WsusUtil.exe' PostInstall CONTENT_DIR=\"${wsus_directory}\" MU_ROLLUP=0
  #                   if (\$LASTEXITCODE -eq 1) {
  #                     Exit 1
  #                   }
  #                   else {
  #                     Exit 0
  #                   }",
  #   logoutput   => true,
  #   refreshonly => true,
  #   timeout     => 1200,
  #   provider    => 'powershell',
  #   require     => [
  #     #Dsc_xwebapppool['WsusPool'],
  #     File[$wsus_directory],
  #     Windowsfeature['UpdateServices-UI'],
  #     Windowsfeature['UpdateServices'],
  #   ]
  # }

}
