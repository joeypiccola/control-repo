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
    notify => Exec['WsusUtil PostInstall'],
  }

  iis_application_pool { 'WsusPool':
    name               => 'WsusPool',
    identity_type      => 'NetworkService',
    idle_timeout       => '00:00:00',
    pinging_enabled    => false,
    queue_length       => 2000,
    restart_time_limit => '00:00:00',
  }

  exec { 'WsusPoolPrivateMemoryLimit':
    provider => 'powershell',
    command  => "\$privateMemoryPath = \"/system.applicationHost/applicationPools/add[@name=\'WsusPool\']/recycling/periodicRestart/@privateMemory\"
                 Set-WebConfiguration \$privateMemoryPath -Value 0",
    onlyif   => "\$privateMemoryPath = \"/system.applicationHost/applicationPools/add[@name=\'WsusPool\']/recycling/periodicRestart/@privateMemory\"
                 if ((Get-WebConfiguration \$privateMemoryPath).value -eq 0) {
                   exit 1
                 } else {
                   exit 0
                 }",
    require  => Iis_application_pool['WsusPool'],
  }

  exec { 'WsusUtil PostInstall':
    command     => "if (!(Test-Path -Path \$env:TMP)) {
                      New-Item -Path \$env:TMP -ItemType Directory
                    }
                    & 'C:\\Program Files\\Update Services\\Tools\\WsusUtil.exe' PostInstall CONTENT_DIR=\"${wsus_directory}\" MU_ROLLUP=0
                    if (\$LASTEXITCODE -eq 1) {
                      exit 1
                    }
                    else {
                      exit 0
                    }",
    logoutput   => true,
    refreshonly => true,
    timeout     => 1200,
    provider    => 'powershell',
    require     => [
      Exec['WsusPoolPrivateMemoryLimit'],
      File[$wsus_directory],
      Windowsfeature['UpdateServices-UI'],
      Windowsfeature['UpdateServices'],
    ]
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

}
