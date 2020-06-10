# == Class: wsus_server_win::wsus::install
class wsus_server_win::wsus::install {

  file { $wsus_server_win::wsus_directory:
    ensure => 'directory',
  }

  case $wsus_server_win::database_type {
    'sql': {
      $features = concat(['UpdateServices-DB'], $wsus_server_win::wsus_features)
    }
    default: {
      $features = concat(['UpdateServices-WidDB'], $wsus_server_win::wsus_features)
    }
  }

  windowsfeature { $features:
    ensure  => present,
    #notify => Exec['WsusUtil PostInstall'],
  }

  # exec { 'WsusUtil PostInstall':
  #   command     => "if (!(Test-Path -Path \$env:TMP)) {
  #                     New-Item -Path \$env:TMP -ItemType Directory
  #                   }
  #                   & 'C:\\Program Files\\Update Services\\Tools\\WsusUtil.exe' PostInstall CONTENT_DIR=\"${wsus_server_win::wsus_directory}\" MU_ROLLUP=0
  #                   if (\$LASTEXITCODE -eq 1) {
  #                     exit 1
  #                   }
  #                   else {
  #                     exit 0
  #                   }",
  #   logoutput   => true,
  #   refreshonly => true,
  #   timeout     => 1200,
  #   provider    => 'powershell',
  #   require     => [
  #     Exec['WsusPoolPrivateMemoryLimit'],
  #     File[$wsus_server_win::wsus_directory],
  #     Windowsfeature['UpdateServices-UI'],
  #     Windowsfeature['UpdateServices'],
  #   ]
  # }

}
