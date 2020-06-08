# == Class: wsus_server_win
class wsus_server_win (
  Array $iis_features,
  Array $wsus_features,
  Boolean $iis_wsus_app_pool_pinging_enabled,
  String $iis_wsus_app_pool_identity_type,
  String $iis_wsus_app_pool_idle_timeout,
  String $iis_wsus_app_pool_private_memory,
  String $iis_wsus_app_pool_queue_length,
  String $iis_wsus_app_pool_restart_time_limit,
  String $wsus_directory,
  String $database_type,
  #Optional[String]$database_sql_instance,
  #Optional[String]$database_sql_server,
) {

  #if $database_type == 'sql' {
  #  assert_type(Array[NotUndef], [$database_sql_server, $database_sql_instance])
  #}

  include wsus_server_win::iis::config
  include wsus_server_win::iis::install
  include wsus_server_win::wsus::install

  Class['wsus_server_win::iis::install']
  -> Class['wsus_server_win::iis::config']
  -> Class['wsus_server_win::wsus::install']

}
