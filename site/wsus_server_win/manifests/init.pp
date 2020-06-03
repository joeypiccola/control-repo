# == Class: wsus_server_win
class wsus_server_win (
  Array $iis_features,
  Array $wsus_features,
  String $iis_identity_type,
  String $iis_idle_timeout,
  String $iis_pinging_enabled,
  String $iis_private_memory,
  String $iis_queue_length,
  String $iis_restart_time_limit,
  String $wsus_directory,
) {

  include wsus_server_win::iis::install
  include wsus_server_win::iis::config
  include wsus_server_win::wsus::install

  Class['wsus_server_win::iis::install']
  -> Class['wsus_server_win::iis::config']
  -> Class['wsus_server_win::wsus::install']

}
