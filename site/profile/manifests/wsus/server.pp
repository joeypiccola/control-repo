# == Class: profile::wsus::server
class profile::wsus::server (
  String $wsus_directory
) {

  file { $wsus_directory:
    ensure => 'directory',
    #notify => Exec['WsusUtil PostInstall'],
  }

  $wsus_server_features = ['UpdateServices','UpdateServices-Services','UpdateServices-RSAT','UpdateServices-API','UpdateServices-UI']
  windowsfeature { $wsus_server_features:
    ensure => present,
  }

  dsc_xwebapppool { 'WSUSPool2':
    dsc_name                      => 'WSUSPool2',
    dsc_ensure                    => 'present',
    dsc_state                     => 'Started',
    dsc_managedpipelinemode       => 'Integrated',
    dsc_queuelength               => 2000,
    dsc_identitytype              => 'NetworkService',
    dsc_idletimeout               => '0',
    dsc_pingingenabled            => true,
    dsc_restartprivatememorylimit => 0,
  }

  #exec { 'WsusUtil PostInstall':
  #  command     => "if (!(Test-Path -Path \$env:TMP)) {
  #                    New-Item -Path \$env:TMP -ItemType Directory
  #                  }
  #                  & 'C:\\Program Files\\Update Services\\Tools\\WsusUtil.exe' PostInstall CONTENT_DIR=\"${wsus_directory}\" MU_ROLLUP=0
  #                  if (\$LASTEXITCODE -eq 1) {
  #                    Exit 1
  #                  }
  #                  else {
  #                    Exit 0
  #                  }",
  #  logoutput   => true,
  #  refreshonly => true,
  #  timeout     => 1200,
  #  provider    => 'powershell',
  #  require     => [
  #    Dsc_xwebapppool['WSUSPool'],
  #    File[$wsus_directory],
  #    Windowsfeature['UpdateServices-UI'],
  #    Windowsfeature['UpdateServices'],
  #  ]
  #}

}



#Get-WebConfiguration "/system.applicationHost/applicationPools/add[@name='WSUSPool']/recycling/periodicRestart/@privateMemory"
#Set-WebConfiguration "/system.applicationHost/applicationPools/add[@name='WSUSPool']/recycling/periodicRestart/@privateMemory" -Value 0
