# == Class: wsus_server_win::iis::config
class wsus_server_win::iis::config {

  iis_application_pool { 'WsusPool':
    name               => 'WsusPool',
    identity_type      => $wsus_server_win::iis_wsus_app_pool_identity_type,
    idle_timeout       => $wsus_server_win::iis_wsus_app_pool_idle_timeout,
    pinging_enabled    => $wsus_server_win::iis_wsus_app_pool_pinging_enabled,
    queue_length       => $wsus_server_win::iis_wsus_app_pool_queue_length,
    restart_time_limit => $wsus_server_win::iis_wsus_app_pool_restart_time_limit,
  }

  exec { 'WsusPoolPrivateMemoryLimit':
    provider => 'powershell',
    command  => "\$privateMemoryPath = \"/system.applicationHost/applicationPools/add[@name=\'WsusPool\']/recycling/periodicRestart/@privateMemory\"
                 Set-WebConfiguration \$privateMemoryPath -Value ${$wsus_server_win::iis_wsus_app_pool_private_memory}",
    onlyif   => "\$privateMemoryPath = \"/system.applicationHost/applicationPools/add[@name=\'WsusPool\']/recycling/periodicRestart/@privateMemory\"
                 if ((Get-WebConfiguration \$privateMemoryPath).value -eq 0) {
                   exit 1
                 } else {
                   exit 0
                 }",
    require  => Iis_application_pool['WsusPool'],
  }

}
