# == Class: wsus_server_win
class wsus_server_win (
  Array  $wsus_server_win::params::iis_features,
  Array  $wsus_server_win::params::wsus_features,
  String $wsus_server_win::params::wsus_directory,
) inherits wsus_server_win::params {

  include wsus_server_win::iis
  include wsus_server_win::wsus

  Class['wsus_server_win::iis']
  -> Class['wsus_server_win::wsus']

}
